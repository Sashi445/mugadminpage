import 'package:flutter/material.dart';
import 'package:mugadminpage/classes/location.dart';
import 'package:mugadminpage/services/firebase_firestore_services.dart';

class AddLocationsPage extends StatefulWidget {
  @override
  _AddLocationsPageState createState() => _AddLocationsPageState();
}

class _AddLocationsPageState extends State<AddLocationsPage> {
  final firestoreServices = FirestoreServices();

  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                trailing: FlatButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text('Refresh')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        decoration:
                            InputDecoration(labelText: 'Enter a location'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: RaisedButton(
                          child: Text('Add'),
                          onPressed: () async {
                            var res = await firestoreServices.addLocation(
                                location:
                                    Location(location: textEditingController.text));
                            Future.delayed(Duration(seconds: 1)).then((value) {
                              setState(() {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Added Location'),
                                ));
                                textEditingController.clear();
                              });
                            });
                            print(res);
                          }),
                    )
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: firestoreServices.rootCollectionReference
                        .doc('locations')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        final locations = snapshot.data['locations'];
                        return ListView.builder(
                            itemCount: locations.length,
                            itemBuilder: (context, index) => Card(
                                  child: ListTile(
                                    subtitle: Text(locations.elementAt(
                                        locations.length -
                                            1 -
                                            index)['locationId']),
                                    title: Text(
                                        locations.elementAt(index)['location']),
                                    trailing: IconButton(
                                        onPressed: () {
                                          firestoreServices.deleteLocation(
                                              location: Location.fromJson(
                                                  locations.elementAt(index)));
                                          Future.delayed(
                                                  Duration(milliseconds: 1000))
                                              .then((value) {
                                            setState(() {
                                              Scaffold.of(context)
                                                  .showSnackBar(SnackBar(
                                                content:
                                                    Text('Location deleted!!'),
                                              ));
                                            });
                                          });
                                        },
                                        icon: Icon(Icons.delete)),
                                  ),
                                ));
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Loading, Please wait!!',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error));
                      } else {
                        return Center(
                          child: Text('Something went wrong'),
                        );
                      }
                    }),
              )
            ],
          )),
    );
  }
}
