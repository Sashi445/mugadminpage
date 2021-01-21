class Option{
  final String option;
  final bool value;
  
  Option({this.option, this.value});

  factory Option.fromJson(Map<String, dynamic> json){
    return Option(
      option: json['option'],
      value: json['value']
    );
  } 

  Map<String,dynamic> toMap(){
    return {
      'option' : this.option,
      'value' : this.value
    };
  }

}