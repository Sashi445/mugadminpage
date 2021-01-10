import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_web_image_picker/flutter_web_image_picker.dart';

class PostBannerForm extends StatefulWidget {
  @override
  _PostBannerFormState createState() => _PostBannerFormState();
}

class _PostBannerFormState extends State<PostBannerForm> {
  var _selectedStartDate = DateTime.now();

  var _selectedEndDate = DateTime.now();

  Image _image;

  final vendorIds = [

  ];

  @override
  void initState(){
    for(int i=0; i<10; i++){
      vendorIds.add(createRandomVendorId());
    }
    super.initState();
  }

  final Map<String, dynamic> bannerForm = {};

  String createRandomVendorId(){
    final charCodes = List.generate(10, (index) => 97 + Random().nextInt(26));
    return String.fromCharCodes(charCodes);
  }

  void _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _selectedStartDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2030)
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    final _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: _selectedStartDate,
        lastDate: DateTime(2030));
    if (_picked != null && _picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = _picked;
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
              child: ExpansionTile(
                title: Text('Choose Vendor'),
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/5,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(3.0),
                    color: Colors.grey[200],
                    child: ListView.builder(
                      itemCount: vendorIds.length,
                      itemBuilder: (context, index) => Card(
                                              child: ListTile(
                          title: Text(vendorIds.elementAt(index)),
                          leading: Text((index + 1).toString()),
                        ),
                      )
                    ),
                  )
                ]
              ),
            ),
            Card(
              child: ExpansionTile(
                title: Text('Choose Location'),
                children: [Text('location1'), Text('location2')],
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
                  final image = await FlutterWebImagePicker.getImage;
                  setState(() {
                    _image = image;
                  });
                },
              ),
            )),
            Container(
              child: _image == null ? Text('No data') : SizedBox(
                height:100, width: 100,
                child: _image),
            )
          ],
        ),
      ),
      floatingActionButton:
          FloatingActionButton.extended(label: Text('Save'), onPressed: () {}),
    );
  }
}
