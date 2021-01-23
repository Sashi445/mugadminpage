import 'package:flutter/material.dart';
import 'package:mugadminpage/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

class TermsandConditions extends StatefulWidget {
  @override
  _TermsandConditionsState createState() => _TermsandConditionsState();
}

class _TermsandConditionsState extends State<TermsandConditions> {
  @override
  Widget build(BuildContext context) {
    final _firestoreServices =
        Provider.of<FirestoreServices>(context, listen: false);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('Terms and Conditions'),
            centerTitle: true,
            bottom: TabBar(
                labelColor: Colors.amber,
                unselectedLabelColor: Colors.black,
                indicatorColor: Colors.amber,
                tabs: [
                  Tab(
                    text: 'Vendor',
                  ),
                  Tab(
                    text: 'User',
                  ),
                ]),
          ),
          body: TabBarView(children: [
            ViewWidget(
              type: 'vendor',
              firestoreServices: _firestoreServices,
            ),
            ViewWidget(
              type: 'customer',
              firestoreServices: _firestoreServices,
            ),
          ]),
        ));
  }
}

// ignore: must_be_immutable
class ViewWidget extends StatefulWidget {
  String type;
  final FirestoreServices firestoreServices;

  ViewWidget({this.type, this.firestoreServices});

  @override
  _ViewWidgetState createState() => _ViewWidgetState();
}

class _ViewWidgetState extends State<ViewWidget> {
  final textctr = TextEditingController();
  int l = 0;

  Widget snackBarTerms(String textResult) {
    return SnackBar(
      content: Text(textResult),
      duration: Duration(seconds: 5),
    );
  }

  Widget updateFunction(int l) {
    if (l == 0 || textctr.text.isEmpty) {
      return FlatButton(
          color: Colors.red,
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Update'),
          ));
    } else if (l != 0 && textctr.text.isNotEmpty) {
      return FlatButton(
        color: Colors.green,
        onPressed: () async {
          bool terms = await widget.firestoreServices
              .updateTermsAndConditionsText(widget.type, textctr.text);
          terms == true
              ? Scaffold.of(context)
                  .showSnackBar(snackBarTerms('updated sucessfully'))
              : Scaffold.of(context)
                  .showSnackBar(snackBarTerms('failed to update'));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Update'),
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: widget.firestoreServices.getTermsAndConditionsData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      maxLines: 10,
                      initialValue: snapshot.data[widget.type],
                      onChanged: (value) {
                        textctr.text = value;
                        setState(() {
                          l = 1;
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                    ),
                  );
                } else {
                  return Center(
                      child: Text(
                    'Loading...',
                    style: TextStyle(color: Colors.black),
                  ));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: updateFunction(l),
          )
        ],
      ),
    );
  }
}
