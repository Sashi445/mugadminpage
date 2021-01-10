class Banner{
  static int regNo;
  String location;
  int bannerId;
  String vendorId;
  DateTime createTime;
  DateTime startTime;
  DateTime endTime;
  String imageUrl;
  double price;
  Banner({this.location, this.vendorId, this.createTime, this.endTime, this.imageUrl}){
    regNo++;
    this.bannerId = regNo;
  }



}

