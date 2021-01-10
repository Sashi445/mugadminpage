import 'package:flutter/material.dart';

class PostBannerForm extends StatefulWidget {
  @override
  _PostBannerFormState createState() => _PostBannerFormState();
}

class _PostBannerFormState extends State<PostBannerForm> {
  var _selectedStartDate = DateTime.now();

  final Map<String, dynamic> bannerForm = {};

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _selectedStartDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2030));
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
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
                children: [Text('Vendor1'), Text('Vendor2')],
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
                    title:
                        Text('${_selectedStartDate.toLocal()}'.split(' ')[0]),
                    subtitle: Text('Choose start date'),
                    trailing: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  )),
                  Card(
                      child: ListTile(
                    title:
                        Text('${_selectedStartDate.toLocal()}'.split(' ')[0]),
                    subtitle: Text('Choose End date'),
                    trailing: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  )),
                  Card(
                      child: ListTile(
                    title: Text('Pick an image'),
                    trailing: IconButton(
                      icon: Icon(Icons.add_photo_alternate),
                      onPressed: (){

                      },
                    ),
                  )),
          ],
        ),
      ),
      floatingActionButton:
          FloatingActionButton.extended(label: Text('Save'), onPressed: () {}),
    );
  }
}
