import 'package:flutter/material.dart';
import 'package:mugadminpage/services/firebase_firestore_services.dart';
import 'package:mugadminpage/views/post_banner_form.dart';
import 'package:provider/provider.dart';
import 'package:firebase/firebase.dart' as fb;

class PostBanner extends StatefulWidget {
  @override
  _PostBannerState createState() => _PostBannerState();
}

class _PostBannerState extends State<PostBanner> {

  String dateFormatter(int day, int month, int year){
    return day.toString() + '/' + month.toString() + '/' + year.toString();
  }

  List<DataRow> getDataRows(List data) {
    return data
        .map((e) => DataRow(cells: [
              DataCell(Text(e['bannerId'].toString())),
              DataCell(Text(e['vendorId'])),
              DataCell(Text(dateFormatter(e['startTime']['day'], e['startTime']['month'], e['startTime']['year']))),
              DataCell(Text(dateFormatter(e['endTime']['day'], e['startTime']['month'], e['startTime']['year']))),
              DataCell(Text('${e['location']['location']}')),
              DataCell(Container(
                height: 100,
                width: 150,
                child: PhotoWidget(imageUrl: e['imageUrl'],)
              )),
            ]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final firestoreServices =
        Provider.of<FirestoreServices>(context, listen: false);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text('Running and approved banners'),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: FutureBuilder(
                future: firestoreServices.getBannerSnapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final bannerMapsList = snapshot.data;
                    return DataTable(
                      columns: [
                        DataColumn(label: Text('Banner ID')),
                        DataColumn(label: Text('Vendor ID')),
                        DataColumn(label: Text('Start Date')),
                        DataColumn(label: Text('End Date')),
                        DataColumn(label: Text('Location')),
                        DataColumn(label: Text('Image Data'))
                      ],
                      rows: getDataRows(bannerMapsList)
                    );
                    // return Container();
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Row(
          children: [Icon(Icons.add), Text('Create')],
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PostBannerForm(
                    firestoreServices: firestoreServices,
                  )));
        },
      ),
    );
  }
}


class PhotoWidget extends StatelessWidget {
  
  final String imageUrl;

  PhotoWidget({this.imageUrl});

  Future<Uri> downloadUrl() {
  return fb
      .storage()
      .refFromURL('gs://servudyam-9b91b.appspot.com')
      .child(imageUrl)
      .getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: downloadUrl().asStream() ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.connectionState ==  ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }else{
          return GestureDetector(
            onTap: (){
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Container(
                    height: MediaQuery.of(context).size.height/2,
                    width: MediaQuery.of(context).size.width/2,
                    child: Image.network(snapshot.data.toString())),
                  actions: [
                    FlatButton(
                      child: Text('Close'),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )
              );
            },
            child: Image.network(snapshot.data.toString(), fit: BoxFit.fill));
        }
      },
    );
  }
}
