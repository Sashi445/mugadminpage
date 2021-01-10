import 'package:flutter/material.dart';
import 'package:mugadminpage/views/post_banner_form.dart';

class PostBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          ListTile(
            title: Text('Running and approved banners'),
          ),
          Expanded(
            child: Container(color: Colors.amber),
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
            builder: (context) => PostBannerForm()
          ));
        },
      ),
    );
  }
}