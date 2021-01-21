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

  Future getTermsAndConditionsData() async {
    try {
      final text = await rootCollectionReference
          .doc('termsandconditions')
          .get()
          .then((value) => value);
      return text.data();
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future getBannerPriceByLocaiton(String location) async {
    try {
      final docRef = rootCollectionReference.doc('ratecard');
      final val = await instance.runTransaction((transaction) async {
        DocumentSnapshot docSnapshot = await transaction.get(docRef);
        return docSnapshot.data()[location];
      }).then((value) => value);
      print(val);
      return val;
    } catch (e) {
      print("An exception was thrown : $e");
    }
  }

  Future updateTermsAndConditionsText(
    String type,
    String newText,
  ) async {
    try {
      final termsAndConditionsDocRef =
          rootCollectionReference.doc('termsandconditions');
      final termsAndConditionsResult =
          instance.runTransaction((transaction) async {
        DocumentSnapshot termsAndConditionsSnap =
            await transaction.get(termsAndConditionsDocRef);
        Map<String, dynamic> termsAndConditionsMap =
            termsAndConditionsSnap.data();
        termsAndConditionsMap[type] = newText;
        transaction.update(termsAndConditionsDocRef, termsAndConditionsMap);
      }).then((value) {
        print("Updated terms and conditions");
        return true;
      }).catchError((error) {
        print(
            "Something went wrong while updating terms and conditions : $error");
        return false;
      });
      return termsAndConditionsResult;
    } catch (e) {
      print(e);
    }
  }

  //returns true if given location doesn't exist
  bool searchForLocation(List locationsList, String location) {
    for (final locationMap in locationsList) {
      if (locationMap['location'] == location) {
        return false;
      }
    }
    return true;
  }

  Future<bool> addLocationToRateCard(String location){
    try{
        final rateCardDocRef = rootCollectionReference.doc('ratecard');
        final rateCardRes = instance.runTransaction((transaction) async {
          DocumentSnapshot rateCardDoc = await transaction.get(rateCardDocRef);
          Map<String, dynamic> rateCardMap = rateCardDoc.data();
          rateCardMap[location] = 0.0;
          transaction.update(rateCardDocRef, rateCardMap);
          return true;
        }).then((value) {
          print("Location added to rate card!!");
          return value;
        }).catchError((error) {
          print(
              "Something went wrong while adding location to ratecard : $error");
          return false;
        });
        return rateCardRes;
    }catch(e){
      print("An exception occures ; $e");
      return Future.delayed(Duration(seconds: 1)).then((value) => false);
    }
  }

  Future<bool> addLocation({Location location}) async {
    try {
      final docRef = rootCollectionReference.doc('locations');

      final res = await instance.runTransaction((transaction) async {
        DocumentSnapshot docSnapshot = await transaction.get(docRef);
        final locationsList = docSnapshot['locations'];
        bool val = searchForLocation(locationsList, location.location);
        if (val == false) {
          print("location already exists!!");
          return false;
        }
        locationsList.add(location.toMap());
        transaction.update(docRef, {'locations': locationsList});
        return true;
      }).then((value) {
        print(value);
        return value;
      }).catchError((error) {
        print('Failed to add location due to : $error');
        return false;
      });

      if(res == true){
        final rateCardRes = await addLocationToRateCard(location.location);
        return rateCardRes ? true : false;
      }else{
        return false;
      }

    } catch (e) {
      print('An exception was thrown : $e');
      return false;
    }
  }

  Future<bool> deleteLocationFromRateCard(Location location) async {
    try {
      final docRef = await instance.collection('AppData').doc('ratecard').get();
      final docMap = docRef.data();
      docMap.remove(location.location);
      print(docMap);
      final res = await instance
          .collection('AppData')
          .doc('ratecard')
          .set(docMap)
          .then((value) => true)
          .catchError((error) => false);
      return res;
      // final res = instance.runTransaction((transaction) async {
      //   final docSnap = await transaction.get(docRef);
      //   Map<String,dynamic> docMap = docSnap.data();
      //   docMap.remove(location.location);
      //   print(docMap);
      //   transaction.update(docRef, docMap);
      // }).then((value){
      //   print("Successfully deleted location from ratecard!!");
      //   return true;
      // })
      // .catchError((error){
      //   print("an error was caught!! : $error");
      //   return false;
      // });
      // return res;

    } catch (e) {
      print("An exceptionwas caught : $e");
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
      final rateCardRes = await deleteLocationFromRateCard(location);
      if (res && rateCardRes) {
        print("Success");
        return true;
      }
      print("Something went wrong!!");
      return false;
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
      final bannersCollection =
          rootCollectionReference.doc('banners').collection('bannerData');
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

  //key here refers to location and value refers to price at that location
  Future updateRateCard(String key, double value) async {
    try {
      final rateCardDocRef = rootCollectionReference.doc('ratecard');
      final result = instance.runTransaction((transaction) async {
        DocumentSnapshot rateCardSnap = await transaction.get(rateCardDocRef);
        Map<String, dynamic> rateCardMap = rateCardSnap.data();
        rateCardMap[key] = value;
        transaction.update(rateCardDocRef, rateCardMap);
      }).then((result) {
        print("Updated rate card at location $key to $value!!");
        return true;
      }).catchError((error) {
        print("Something went wrong while updating rate card : $error");
        return false;
      });
      return result;
    } catch (e) {
      print("An exceptionwas caught : $e");
      return false;
    }
  }

  Future getBannerSnapshots() async {
    try {
      final bannersReference =
          rootCollectionReference.doc('banners').collection('bannerData');
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

  DateTime getDateFromMap(dynamic dateMap) => DateTime.utc(
      dateMap['year'],
      dateMap['month'],
      dateMap['day'],
      dateMap['hour'],
      dateMap['minute'],
      dateMap['second']);

  //takes in the banner document and returns the status of the banner
  String _updateStatus(Map<String, dynamic> bannerMap) {
    final startDate = getDateFromMap(bannerMap['startTime']);
    final endDate = getDateFromMap(bannerMap['endTime']);
    final presentDate = DateTime.now();
    final duration1 = presentDate.difference(startDate);
    final duration2 = presentDate.difference(endDate);
    if (duration1.isNegative) {
      if (startDate.day == presentDate.day &&
          startDate.month == presentDate.month &&
          startDate.year == presentDate.year)
        return "Approved";
      else
        return "Active";
    } else if (!duration1.isNegative && duration2.isNegative) {
      return "Active";
    } else if (!duration1.isNegative && !duration2.isNegative) {
      return "Expired";
    }
    return "Wrong input!!";
  }

  Future runningStatusCheckOnBanners() async {
    try {
      final bannerCollectionReference =
          rootCollectionReference.doc('banners').collection('bannerData');
      //using batch writes here because need to update every banner status
      WriteBatch batch = instance.batch();
      bannerCollectionReference.get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((DocumentSnapshot document) {
          Map<String, dynamic> documentMap = document.data();
          final res = _updateStatus(documentMap);
          documentMap['status'] = res;
          batch.update(document.reference, documentMap);
        });
      }).then((value) {
        batch.commit();
      });
      print("Running status check on banners using batches!!");
      // return batch.commit();
    } catch (e) {
      print("An exception was thrown : $e");
    }
  }
}
