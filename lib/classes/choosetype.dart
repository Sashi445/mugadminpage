import 'package:mugadminpage/classes/option.dart';
import 'package:mugadminpage/classes/question.dart';

class ChooseType extends Question{

  final List<Option> options;

  //true - singleCorrectType(radio)
  //false - multiple correct type(checkbox)
  final chooseType;

  
  ChooseType({this.options, this.chooseType, String question}) : super(question: question);

  factory ChooseType.fromJson(Map<String, dynamic> json) {
    final List<Map<String,dynamic>> optionMaps = json['options'];
    final _options = optionMaps.map((e) => Option.fromJson(e)).toList();
    return ChooseType(
      question: json['question'],
      options: _options,
      chooseType: json['chooseType']
    );
  }
  
  @override
  Map<String, dynamic> toMap(){
    final List<Map<String, dynamic>> optionMaps = [];
    for(final option in this.options){
      optionMaps.add(option.toMap());
    }
    this.type = 0;
    return {
      'question' : this.question,
      'type' : 0,
      'options' : optionMaps,
      'chooseType' : this.chooseType
    };
  }

}