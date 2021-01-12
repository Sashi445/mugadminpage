import 'package:flutter/material.dart';
import 'package:mugadminpage/services/firebase_firestore_services.dart';
import 'package:mugadminpage/views/post_banner_form.dart';
import 'package:provider/provider.dart';

class PostBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final firestoreServices = Provider.of<FirestoreServices>(context, listen:false);

    firestoreServices.getBanners();

    return Scaffold(
      body:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          ListTile(
            title: Text('Running and approved banners'),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(),
            )
          )
        ],),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Row(children: [
          Icon(Icons.add),
          Text('Create')
        ],),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PostBannerForm(firestoreServices: firestoreServices,)
          ));
        },
      ),
    );
  }
}