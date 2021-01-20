import 'dart:async';
import 'package:mugadminpage/classes/banner.dart';
import 'package:mugadminpage/services/firebase_firestore_services.dart';

class BannerStream {
  var bannerData;

  var bannerObject = BannerObject();

  final _bannerCheckList = {
    'location' : false,
    'startTime' : false,
    'imageUrl' : false,
    'vendorId' : false,
    'endTime' : false,
    'uploadEvent' : false
  };

  final firestoreServices = FirestoreServices();

  final _bannerStreamController = StreamController<BannerObject>();

  Stream<BannerObject> get bannerStream => _bannerStreamController.stream;

  BannerStream(){ 
    bannerObject.initiateSomething(); 
    initiateDataItems();
  }

  DateTime getDateTimeFromDateMap(Map<String, dynamic> dateTime) =>
      DateTime.utc(dateTime['year'], dateTime['month'], dateTime['day'],
          dateTime['hour'], dateTime['minute'], dateTime['second']);

//returns 0 if a == b
//returns 1 if a > b
//returns -1 if a < b

  int compareTwoDurations(Duration a) => a.compareTo(Duration());

  int compareTwoDates(DateTime a, DateTime b) =>
      compareTwoDurations(a.difference(b));

  List getBannersByLocation(String location){
    final bannersByLocation = [];
    for(var banner in bannerData){
      if(banner['location']['location'] == location ){
        bannersByLocation.add(banner);
      }
    }
    return bannersByLocation;
  }

  void setInitialStartTime(List bannerMaps) {
    var minDate = DateTime.now();
    bool changed = false;
    minDate = DateTime.utc(minDate.year+1, minDate.month, minDate.day, minDate.hour, minDate.minute, minDate.second);
    for (var banner in bannerMaps) {
      var endDate = getDateTimeFromDateMap(banner['endTime']);
      if (compareTwoDates(endDate, minDate) == -1) {
        minDate = endDate;
        changed = true;
      }
    }
    if(changed == false){
      bannerObject.setStartDate(DateTime.now());
      print(DateTime.now());
    }else{
      print(minDate);
      bannerObject.setStartDate(
        DateTime.utc(minDate.year, minDate.month, minDate.day + 1, minDate.hour, minDate.minute, minDate.second)
      );
    }
  }

  void getToKnowBanners(String location) {
    var bannerMaps = getBannersByLocation(location);
    if(bannerMaps.length < 5){
      bannerObject.setStartDate(DateTime.now());
    }else{
      setInitialStartTime(bannerMaps);
    }
    _bannerCheckList['location'] = true;
    _bannerCheckList['startTime'] = true;
    addDataToStream();
  }

  Future<void> setBannerDataFromDatabase() async {
    bannerData = await firestoreServices.getBannerSnapshots();
    addDataToStream();
  }

  Future getLocations() async {
    final locationDocRef = await firestoreServices.rootCollectionReference.doc('locations').get();
    return locationDocRef.data()['locations'];
  }
  void setVendorId(String vendorId){
    bannerObject.setvendorId(vendorId);
    _bannerCheckList['vendorId'] = true;
    addDataToStream();
  }

  void setLocation(Map<String, dynamic> location){
    bannerObject.setLocation(location);
    addDataToStream();
  }

  void setEndDate(DateTime endTime) async {
    bannerObject.setEndDate(endTime);
    _bannerCheckList['endTime'] = true;
    await setBannerPrice(bannerObject.location['location']);
    addDataToStream();
  }

  Future<void> setBannerPrice(String location) async {
    var duration = bannerObject.endTime.difference(bannerObject.startTime);
    int days = duration.inDays;
    var pricePerDay = await firestoreServices.getBannerPriceByLocaiton(location);
    bannerObject.setPrice(days*pricePerDay);
    addDataToStream();
  }

  void setImageUrl(String url){
    bannerObject.setImageUrl(url);
    _bannerCheckList['uploadEvent'] = true;
    _bannerCheckList['imageUrl'] = true;
    addDataToStream();
  }

  bool checkList(){
    bool allChecked = true;
    for(var key in _bannerCheckList.keys){
      if(_bannerCheckList[key] == false){
        print(key);
        allChecked = false;
      }
    }
    if(allChecked){
      print("All checked banner is ready to upload!!");
      addDataToStream();
    }else{
      print("Something is unchecked!!");
    }
    return allChecked;
  }

  void initiateDataItems() async{
    await setBannerDataFromDatabase();
  }

  void addDataToStream() {
    _bannerStreamController.sink.add(bannerObject);
  }

  void addBannerToDatabase() async {
    await firestoreServices.createBanner(bannerObject);
  }

}
