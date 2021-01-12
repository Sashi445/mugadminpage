import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase/firebase.dart' as fb;
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

  final banner = BannerObject();

  var buttonData = {
    'color' : Colors.red,
    'iconData' : Icons.close
  };

  var imageUrl;

  var _selectedVendor;

  var _selectedStartDate = DateTime.now();

  var _selectedEndDate = DateTime.now();

  var _selectedLocation;

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
    for (int i = 0; i < 10; i++) {
      vendorIds.add(createRandomVendorId());
    }
    super.initState();
  }

  final Map<String, dynamic> bannerForm = {};

  String createRandomVendorId() {
    final charCodes = List.generate(10, (index) => 97 + Random().nextInt(26));
    return String.fromCharCodes(charCodes);
  }

  void _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _selectedStartDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2030));
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        banner.setStartDate(picked);
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    final _picked = await showDatePicker(
        context: context,
        initialDate: _selectedStartDate,
        firstDate: _selectedStartDate,
        lastDate: DateTime(2030));
    if (_picked != null && _picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = _picked;
        banner.setEndDate(_picked);
      });
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
        child: Column(
          children: [
            ListTile(
              title: Text('Create Banner'),
            ),
            Card(
              child: ExpansionTile(title: Text('Choose Vendor'), children: [
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(3.0),
                  color: Colors.grey[200],
                  child: ListView.builder(
                      itemCount: vendorIds.length,
                      itemBuilder: (context, index) => Card(
                            child: ListTile(
                              title: Text(vendorIds.elementAt(index)),
                              leading: Text((index + 1).toString()),
                              onTap: () {
                                setState(() {
                                  this._selectedVendor = vendorIds[index];
                                });
                              },
                            ),
                          )),
                )
              ]),
            ),
            Card(
              child: ExpansionTile(
                title: Text('Choose Location'),
                children: [
                    Container(
                    height: MediaQuery.of(context).size.height / 5,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(3.0),
                    color: Colors.grey[200],
                    child: FutureBuilder(
                      future: widget.firestoreServices.rootCollectionReference.doc('locations').get(),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          final locationsData = snapshot.data;
                          final locations = locationsData['locations'];
                          return ListView.builder(
                            itemCount: locations.length,
                            itemBuilder: (context, index) => Card(child: ListTile(
                              title: Text(locations[index]['location']),
                              subtitle: Text(locations[index]['locationId']),
                              onTap: (){
                                setState(() {
                                  this._selectedLocation = locations[index]['locationId'];
                                });
                              },
                            ),),
                          );
                        }
                        else if(snapshot.hasError){
                          return Center(child: Text(snapshot.error),);
                        }
                        else{
                          return Center(child: CircularProgressIndicator(),);
                        }
                      },
                    )
                  )
                ],
              ),
            ),
            // Expanded(
            //   child: GridView(
            //     // physics: NeverScrollableScrollPhysics(),
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //         childAspectRatio: 11,
            //         crossAxisCount: 2),
            //     children: [

            //     ],
            //   ),
            // ),
            Card(
                child: ListTile(
              title: Text('${_selectedStartDate.toLocal()}'.split(' ')[0]),
              subtitle: Text('Choose start date'),
              trailing: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectStartDate(context),
              ),
            )),
            Card(
                child: ListTile(
              title: Text('${_selectedEndDate.toLocal()}'.split(' ')[0]),
              subtitle: Text('Choose End date'),
              trailing: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectEndDate(context),
              ),
            )),
            Card(
                child: ListTile(
              title: Text('Pick an image'),
              trailing: IconButton(
                icon: Icon(Icons.add_photo_alternate),
                onPressed: () async {
                  final path = '${this.banner.bannerId}' + '|' + 
                      '${this._selectedLocation}' +
                      '${this._selectedVendor}';
                  uploadImage(onSelected: (file) {
                    setState(() {
                      this.imageUrl = fb
                          .storage()
                          .refFromURL('gs://servudyam-9b91b.appspot.com/')
                          .child(path)
                          .put(file)
                          .future
                          .then((_) {
                            print('path : $path');
                        print('Added to Storage!!');
                        setState(() {
                          this.imageUrl = path;
                          this.buttonData['color'] = Colors.green;
                          this.buttonData['iconData'] = Icons.check;
                        });
                      }).catchError((error) {
                        print('An error was caught : $error');
                      });
                    });
                  });
                },
              ),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('save'),
              Icon(buttonData['iconData'])
          ],),
          backgroundColor: buttonData['color'],
          onPressed: () async {
            banner.setImageUrl(imageUrl.toString());
            banner.setLocation(_selectedLocation);
            banner.setvendorId(_selectedVendor);
            await widget.firestoreServices
                .createBanner(banner)
                .then((value) {
              print('Added Banner successfully!!');
            });
            Navigator.of(context).pop();
          }),
    );
  }
}
