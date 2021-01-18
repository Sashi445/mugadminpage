import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
import 'package:mugadminpage/classes/banner.dart';
import 'package:mugadminpage/classes/location.dart';

class FirestoreServices {
  final instance = FirebaseFirestore.instance;

  final rootCollectionReference =
      FirebaseFirestore.instance.collection('AppData');

  // Future createAppRootCollection() async{
  //   try{
  //     final collectionReference = instance.collection('AppData');
  //     collectionReference.doc('config').set({
  //       'projectName' : 'Servudyam',
  //       'application' : 'Database for admin and customer application'
  //     }).then((value) => print('root collection added'))
  //     .catchError((error) => print('Failed due to $error'));
  //   }catch(e){
  //     throw Exception('An exception was thrown creating this root collection');
  //   }
  // }

  Future getdata() async {
    try {
      final text = await rootCollectionReference
          .doc('termsandconditions')
          .get()
          .then((value) => value);
      return text['termsandconditions'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future updateText(String txtctr) async {
    try {
      final text = await rootCollectionReference.doc('termsandconditions').set({
        'termsandconditions': txtctr,
      }).then((value) => print('updated'));
    } catch (e) {
      print(e);
    }
  }

  Future<bool> addLocation({Location location}) async {
    try {
      final docRef = rootCollectionReference.doc('locations');
      instance
          .runTransaction((transaction) async {
            DocumentSnapshot docSnapshot = await transaction.get(docRef);
            final locationsList = docSnapshot['locations'];
            locationsList.add(location.toMap());
            transaction.update(docRef, {'locations': locationsList});
          })
          .then((value) => print('Successfully added location!!'))
          .catchError(
              (error) => print('Failed to add location due to : $error'));
      return true;
    } catch (e) {
      print('An exception was thrown : $e');
      return false;
    }
  }

  Future<bool> deleteLocation({Location location}) async {
    try {
      final docRef = rootCollectionReference.doc('locations');
      var res = await instance.runTransaction((transaction) async {
        DocumentSnapshot documentSnapshot = await transaction.get(docRef);
        var locationsList = documentSnapshot.data()['locations'];
        locationsList = locationsList.map((e) => Location.fromJson(e)).toList();
        for (int i = 0; i < locationsList.length; i++) {
          final temp = locationsList[i];
          if (temp.location == location.location) {
            locationsList.removeAt(i);
          }
        }
        transaction.update(docRef,
            {'locations': locationsList.map((e) => e.toMap()).toList()});
      }).then((value) {
        print('Successfully deleted location');
        return true;
      }).catchError((error) {
        print('failed to delete location due to error');
        print(error);
        return false;
      });
      return res;
    } catch (e) {
      print('An exception was thrown while deleteing the location : $e');
      return false;
    }
  }

  Future getLocationsList() async {
    try {
      final document =
          await rootCollectionReference.doc('locations').get().then((value) {
        print('successfully got locations');
      }).catchError(((error) {
        print('An errpr was found!! : $error');
      }));
      print(document);
      return document['locations'];
    } catch (e) {
      print('An exception was thrown : $e');
      return null;
    }
  }

  Future<bool> createBanner(BannerObject banner) async {
    try {
      final bannersCollection = instance.collection('banners');
      final res = await instance.runTransaction((transaction) async {
        final docRef = bannersCollection
            .doc('${banner.bannerId}' + '|' + '${banner.vendorId}');
        transaction.set(docRef, banner.toMap());
      }).then((value) {
        print('Successfully added banner');
        return true;
      }).catchError((error) {
        print('An error was caught : $error');
        return false;
      });
      print(res);
      return res;
    } catch (e) {
      print('An exception was thrown : $e');
      return false;
    }
  }

  Future getSnapshots() async {
    try {
      final bannersReference = instance.collection('banners');
      final documentSnapshots = await bannersReference.get();
      final bannerMaps = [];
      documentSnapshots.docs.forEach((DocumentSnapshot snapshot) {
        bannerMaps.add(snapshot.data());
      });
      return bannerMaps;
    } catch (e) {
      print('something went wrong : $e');
    }
  }
}
