import 'package:flutter/material.dart';
import 'package:mugadminpage/services/firebase_auth_services.dart';
import 'package:mugadminpage/views/add_locations_page.dart';
import 'package:mugadminpage/views/post_banner_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  bool extended = true;

  int selected = 0;
  
  final _widgets = [
    AddLocationsPage(),
    Container(
      child: Center(child: Text('Services and forms')),
    ),
    PostBanner(),
    Container(
      child: Center(child: Text('Terms and conditions')),
    ),
    Container(
      child: Center(child: Text('Rating Section')),
    )
  ];

  @override
  Widget build(BuildContext context) {

    final firebaseAuthServices = Provider.of<FirebaseAuthServices>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Servudyam')
      ),
      drawer: Drawer(
        child: Column(children: [
          RaisedButton(
            child: Text('Sign out'),
            onPressed: () async {
              await firebaseAuthServices.signOutTheSession();
            },
          )
        ],),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(children: [
          NavigationRail(
            leading: IconButton(
              icon: Icon(Icons.switch_right),
              onPressed: () {
                setState(() {
                  extended = !extended;
                });
              },
            ),
            extended: extended,
            minExtendedWidth: MediaQuery.of(context).size.width / 6,
            selectedIndex: selected,
            labelType: NavigationRailLabelType.none,
            onDestinationSelected: (val) {
              setState(() {
                selected = val;
              });
            },
            destinations: [
              NavigationRailDestination(
                  icon: Icon(Icons.gps_fixed),
                  label: Center(child: Text('Locations'))),
              NavigationRailDestination(
                  icon: Icon(Icons.design_services),
                  label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Services and forms'))),
              NavigationRailDestination(
                  icon: Icon(Icons.post_add_rounded),
                  label: Center(child: Text('Post a banner'))),
              NavigationRailDestination(
                  icon: Icon(Icons.text_format_outlined),
                  label: Center(child: Text('Terms and conditions'))),
              NavigationRailDestination(
                  icon: Icon(Icons.rate_review_outlined),
                  label: Center(child: Text('Rate card')))
            ],
          ),
          Expanded(flex: 2, child: _widgets.elementAt(selected))
        ]),
      ),
    );
  }
}
