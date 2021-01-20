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
  var ratecard;

  @override
  Widget build(BuildContext context) {
    final _firestoreServices =
        Provider.of<FirestoreServices>(context, listen: false);

    Widget pricetile(String txt, String val) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Card(
          child: ListTile(
            title: Text(txt),
            trailing: Text(val),
            onTap: () {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('update the $txt price'),
                      content: TextFormField(
                        initialValue: val,
                        onChanged: (valu) {
                          updated_value = valu;
                        },
                      ),
                      actions: [
                        FlatButton(
                          onPressed: () async {
                            final temp = double.parse(updated_value);
                            ratecard[txt] = temp;
                            await _firestoreServices.rootCollectionReference
                                .doc('ratecard')
                                .set(ratecard)
                                .then((value) => print('updated rate card'));
                            Navigator.of(context).pop();
                          },
                          child: Text('Update'),
                          color: Colors.green,
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.grey,
                        ),
                      ],
                    );
                  });
            },
          ),
        ),
      );
    }

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
              FlatButton(onPressed: (){
                setState(() {});
              }, child: Text('Refresh')),
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
                        children: [
                          pricetile('gold', ratecard['gold'].toString()),
                          pricetile('silver', ratecard['silver'].toString()),
                          pricetile('bronze', ratecard['bronze'].toString()),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }))
        ],
      ),
    );
  }
}
