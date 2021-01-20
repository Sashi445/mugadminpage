
class BannerObject{
  
  static int count = 0;
  Map<String,dynamic>  location;
  int bannerId;
  String vendorId;
  final DateTime createTime  = DateTime.now();
  DateTime startTime;
  DateTime endTime;
  String imageUrl;
  double price;
  String status = "Approved";
  final bool adminAuthorised = true;
  
  BannerObject(){
    this.bannerId = count;
    count++;
  }

  //ignore using most of the time
  void initiateSomething(){
    this.location = {
      'location' : '',
      'locationId' : ''
    };
    vendorId = '';
    imageUrl = '';
    price = 0.0;
    startTime = DateTime.now();
    endTime = DateTime.now();
  }

  void setLocation(Map<String, dynamic> location){
    this.location = location;
  }

  void setPrice(double price){
    this.price = price;
  }

  void setImageUrl(String url){
    this.imageUrl = url;
  }

  void setvendorId(String vendorId){
    this.vendorId = vendorId;
  }

  void setStartDate(DateTime startDate){
    this.startTime = startDate;
  }

  void setEndDate(DateTime endDate){
    this.endTime = endDate;
  }

  int getDaysOfMonth(int month){
    switch(month){
      case 1: return 31;
      case 2: return 28;
      case 3: return 31;
      case 4: return 30;
      case 5: return 31;
      case 6: return 30;
      case 7: return 31;
      case 8: return 31;
      case 9: return 30;
      case 10: return 31;
      case 11: return 30;
      case 12: return 31;
      default: return 0;
    }
  }

  int getNumDays(){
    int days = 0;
    if(this.startTime.year == this.endTime.year){
      if(this.startTime.month == this.endTime.month){
        days += this.endTime.day - this.startTime.day;
      }else{
        for(int i = this.startTime.month; i<this.endTime.month; i++){
          days += 1 ;
        }
      }
    }
    return days;
  }

  Map<String, int> dateMapper(DateTime dateTime){
    return {
      'year' : dateTime.year,
      'month' : dateTime.month,
      'day' : dateTime.day,
      'hour' : dateTime.hour,
      'minute' : dateTime.minute,
      'second' : dateTime.second
    };
  }

  Map<String, dynamic> toMap(){
    return {
      'bannerId' : this.bannerId,
      'vendorId' : this.vendorId,
      'createTime' : dateMapper(this.createTime),
      'startTime' : dateMapper(this.startTime),
      'endTime' : dateMapper(this.endTime),
      'imageUrl' : this.imageUrl,
      'price' : this.price,
      'location' : this.location,
      'adminAuthorized' : this.adminAuthorised,
      'status' : this.status
    };
  }

}


