import 'dart:async';

import 'package:mugadminpage/classes/banner.dart';
import 'package:mugadminpage/classes/location.dart';
import 'package:mugadminpage/services/firebase_firestore_services.dart';

class BannerStream{

  var bannerData;

  var bannerObject = BannerObject();

  final firestoreServices = FirestoreServices();

  final _bannerStreamController = StreamController<BannerObject>();

  Stream<BannerObject> get bannerStream => _bannerStreamController.stream;

  BannerStream(){
    addDataToStream();
  }

  DateTime getDateTimeFromDateMap(Map<String, dynamic> dateTime) => DateTime.utc(dateTime['year'], dateTime['month'], dateTime['day'], dateTime['hour'], dateTime['minute'], dateTime['second']);

// int compareTo(Duration other)
// Compares this Duration to other, returning zero if the values are equal.

// Returns a negative integer if this Duration is shorter than other, or a positive integer if it is longer.

// A negative Duration is always considered shorter than a positive one.

// It is always the case that duration1.compareTo(duration2) < 0 iff (someDate + duration1).compareTo(someDate + duration2) < 0.

  void setInitialStartTime(){
    var currDate = DateTime.now();
    var currDateDuration = currDate.
    for(var banner in bannerData){
      if()
    } 
  }

  void getToKnowBanners(){

  }

  void setLocation(Location location){
    var bannerCount = 0;
    for(var banner in bannerData){
      if(location.location == banner['location']){
        bannerCount = bannerCount + 1;
      }
    }
  }

  void setBannerDataFromDatabase() async{
    bannerData = await firestoreServices.getBannerSnapshots();
  }

  void setStartTime(DateTime startDate){
    bannerObject.setStartDate(startDate);
    addDataToStream();
  }

  void setEndTime(DateTime endDate){
    bannerObject.setEndDate(endDate);
    addDataToStream();
  }

  void addDataToStream(){
    _bannerStreamController.sink.add(bannerObject);
  }

}