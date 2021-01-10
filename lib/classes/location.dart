import 'dart:math';

class Location{

  final String location;
  final String locationId = String.fromCharCodes(List.generate(10, (index) => 97 + Random().nextInt(25)));
  
  Location({this.location, String locationId});

  factory Location.fromJson(Map<String, dynamic> map){
    return Location(
      location: map['location'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'location' : this.location,
      'locationId' : this.locationId
    };
  }

}