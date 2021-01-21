import 'package:flutter/material.dart';
import 'package:mugadminpage/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

class TermsandConditions extends StatefulWidget {
  @override
  _TermsandConditionsState createState() => _TermsandConditionsState();
}

class _TermsandConditionsState extends State<TermsandConditions> {
  final textctr = TextEditingController();
  int l = 0;

  @override
  Widget build(BuildContext context) {
    final _firestoreServices =
        Provider.of<FirestoreServices>(context, listen: false);

    Widget but(int l) {
      if (l == 0) {
        return FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Update'),
            ));
      } else {
        return FlatButton(
          color: Colors.green,
          onPressed: () {
            _firestoreServices.updateText(textctr.text);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Update'),
          ),
        );
      }
    }

    return Container(
      child: Column(
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Terms And Conditions'),
          )),
          Expanded(
            child: FutureBuilder(
              future: _firestoreServices.getdata(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      maxLines: 10,
                      initialValue: snapshot.data,
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
            child: but(l),
          )
        ],
      ),
    );
  }
}
