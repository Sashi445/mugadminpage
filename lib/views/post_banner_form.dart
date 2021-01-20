import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase/firebase.dart' as fb;
import 'package:mugadminpage/blocs/bannerstream.dart';
import 'dart:html';

import 'package:mugadminpage/classes/banner.dart';
import 'package:mugadminpage/services/firebase_firestore_services.dart';

class PostBannerForm extends StatefulWidget {
  final FirestoreServices firestoreServices;

  const PostBannerForm({Key key, this.firestoreServices}) : super(key: key);

  @override
  _PostBannerFormState createState() => _PostBannerFormState();
}

class _PostBannerFormState extends State<PostBannerForm> {
  final bannerStream = BannerStream();

  bool buttonState = false;

  var imageUrl;

  var _selectedEndDate = DateTime.now();

  final vendorIds = [];

  void uploadImage({@required Function(File file) onSelected}) {
    InputElement uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });
  }

  @override
  void initState() {
    bannerStream.setBannerDataFromDatabase();
    for (int i = 0; i < 10; i++) {
      vendorIds.add(createRandomVendorId());
    }
    bannerStream.addDataToStream();
    super.initState();
  }

  final Map<String, dynamic> bannerForm = {};

  String createRandomVendorId() {
    final charCodes = List.generate(10, (index) => 97 + Random().nextInt(26));
    return String.fromCharCodes(charCodes);
  }

  void _selectEndDate(BuildContext context) async {
    final _picked = await showDatePicker(
        context: context,
        initialDate: bannerStream.bannerObject.startTime,
        firstDate: bannerStream.bannerObject.startTime,
        lastDate: DateTime(2070));
    if (_picked != null && _picked != _selectedEndDate) {
      bannerStream.setEndDate(_picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: bannerStream.bannerStream,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active) {
                BannerObject bannerObject = snapshot.data;
                return ListView(
                  children: [
                    ListTile(
                      title: Text('Create Banner'),
                    ),
                    Card(
                      child: ListTile(
                        title: Text('Request Number'),
                        trailing: Text(bannerObject.bannerId.toString()),
                      ),
                    ),
                    Card(
                      child: ExpansionTile(
                          title: Text(bannerObject.vendorId == ''
                              ? "Choose a vendor"
                              : bannerObject.vendorId),
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 5,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(3.0),
                              color: Colors.grey[200],
                              child: ListView.builder(
                                  itemCount: vendorIds.length,
                                  itemBuilder: (context, index) => Card(
                                        child: ListTile(
                                          title:
                                              Text(vendorIds.elementAt(index)),
                                          leading: Text((index + 1).toString()),
                                          onTap: () {
                                            bannerStream
                                                .setVendorId(vendorIds[index]);
                                          },
                                        ),
                                      )),
                            )
                          ]),
                    ),
                    Card(
                      child: ExpansionTile(
                        title: Text(bannerObject.location['location'] == ''
                            ? "Choose a location"
                            : bannerObject.location['location']),
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height / 5,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(3.0),
                              color: Colors.grey[200],
                              child: FutureBuilder(
                                future: bannerStream.getLocations(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final locations = snapshot.data;
                                    return ListView.builder(
                                      itemCount: locations.length,
                                      itemBuilder: (context, index) => Card(
                                        child: ListTile(
                                          title: Text(
                                              locations[index]['location']),
                                          subtitle: Text(
                                              locations[index]['locationId']),
                                          onTap: () {
                                            bannerStream
                                                .setLocation(locations[index]);
                                            bannerStream.getToKnowBanners(
                                                locations[index]['location']);
                                          },
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text(snapshot.error),
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ))
                        ],
                      ),
                    ),
                    Card(
                        child: ListTile(
                      title: Text(
                          '${bannerObject.startTime.toLocal()}'.split(' ')[0] ??
                              "Not selected"),
                      subtitle: Text('Start Date Goes Here(Auto-generated)'),
                    )),
                    Card(
                        child: ListTile(
                      title: Text(
                          '${bannerObject.endTime.toLocal()}'.split(' ')[0]),
                      subtitle: Text('Choose End date'),
                      trailing: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectEndDate(context),
                      ),
                    )),
                    Card(
                      child: ListTile(
                        title: Text("Price"),
                        subtitle: Text('Auto-generated'),
                        trailing:
                            Text(bannerObject.price.ceilToDouble().toString()),
                      ),
                    ),
                    Card(
                        child: ListTile(
                      title: Text('Pick an image'),
                      trailing: IconButton(
                        icon: Icon(Icons.add_photo_alternate),
                        onPressed: () async {
                          final path = '${bannerObject.bannerId}' +
                              '|' +
                              '${bannerObject.location['locationId']}' +
                              '|' +
                              '${bannerObject.vendorId}';
                          uploadImage(onSelected: (file) {
                            setState(() {
                              this.imageUrl = fb
                                  .storage()
                                  .refFromURL(
                                      'gs://servudyam-9b91b.appspot.com/')
                                  .child(path)
                                  .put(file)
                                  .future
                                  .then((_) {
                                print('path : $path');
                                print('Added to Storage!!');
                              })
                              .then((value){
                                bannerStream.setImageUrl(path);
                                setState(() {
                                  buttonState = bannerStream.checkList();
                                });
                                print("ButtonState: $buttonState");
                              })
                              .catchError((error) {
                                print(
                                    'An error was caught with uploading to storage : $error');
                              });
                            });
                          });
                        },
                      ),
                    ))
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('save'),
              Icon(buttonState ? Icons.check : Icons.close)
            ],
          ),
          backgroundColor:buttonState ? Colors.green : Colors.red,
          onPressed: () async {
            bannerStream.addBannerToDatabase();
            Navigator.of(context).pop();
          }),
    );
  }
}
