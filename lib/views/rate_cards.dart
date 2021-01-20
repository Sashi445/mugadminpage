import 'package:flutter/material.dart';
import 'package:mugadminpage/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class Rate_Card extends StatefulWidget {
  @override
  _Rate_CardState createState() => _Rate_CardState();
}

// ignore: camel_case_types
class _Rate_CardState extends State<Rate_Card> {
  String updated_value = '';
  Map<String, dynamic> ratecard;

  @override
  Widget build(BuildContext context) {
    final _firestoreServices =
        Provider.of<FirestoreServices>(context, listen: false);

    // Future<Widget> pricetile(String txt, double val) {
    //   return 
    // }

    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(child: Text('Rate Card')),
              ),
              FlatButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Text('Refresh')),
            ],
          ),
          Expanded(
              child: FutureBuilder(
                  future: _firestoreServices.rootCollectionReference
                      .doc('ratecard')
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final docsnapshot = snapshot.data;
                      ratecard = docsnapshot.data();
                      return Column(
                          children: ratecard.keys.map((e) {
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ListTile(
                            // tileColor: Colors.white,
                            title: Text(e),
                            trailing: Text(ratecard[e].toString()),
                            onTap: () {
                              showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Update $e the value'),
                content: TextFormField(
                  initialValue: ratecard[e].toString(),
                  onChanged: (va) {
                    updated_value = va;
                  },
                ),
                actions: [
                  FlatButton(
                      onPressed: () async {
                        await _firestoreServices
                            .updateRateCard(e, double.parse(updated_value));
                        Navigator.pop(context);
                      },
                      child: Text('update')),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('cancel'))
                ],
              ));
                            },
                          ),
                        );
                      }).toList());
                    } else {
                      return CircularProgressIndicator();
                    }
                  }))
        ],
      ),
    );
  }
}
