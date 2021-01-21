import 'package:flutter/material.dart';
import 'package:mugadminpage/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class RateCard extends StatefulWidget {
  @override
  _RateCardState createState() => _RateCardState();
}

// ignore: camel_case_types
class _RateCardState extends State<RateCard> {
  String updatedValue = '';
  Map<String, dynamic> ratecard;

  @override
  Widget build(BuildContext context) {
    final _firestoreServices =
        Provider.of<FirestoreServices>(context, listen: false);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
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
                    return ListView(
                        children: ratecard.keys.map((e) {
                      return Card(
                        child: ListTile(
                          title: Text(e),
                          trailing: Text(ratecard[e].toString()),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text('Update $e the value'),
                                      content: TextFormField(
                                        initialValue: ratecard[e].toString(),
                                        onChanged: (val) {
                                          updatedValue = val;
                                        },
                                      ),
                                      actions: [
                                        FlatButton(
                                            onPressed: () async {
                                              print(double.parse(updatedValue));
                                              await _firestoreServices
                                                  .updateRateCard(
                                                      e,
                                                      double.parse(
                                                          updatedValue));
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
                }),
          )
        ],
      ),
    );
  }
}
