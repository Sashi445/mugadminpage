import 'package:mugadminpage/classes/choosetype.dart';
import 'package:mugadminpage/classes/question.dart';
import 'dart:math';

import 'package:mugadminpage/classes/questiontypes.dart';

class Service{
  final String serviceId = String.fromCharCodes(List.generate(5, (index) => 97 + Random().nextInt(26)));
  String name;
  bool status;
  List<Question> questions;

  Service({this.name, this.status, this.questions});

  factory Service.fromJson(Map<String, dynamic> json){
    final questionMaps = json['questions'];
    final List<Question> questions = [];
    for(final questionMap in questionMaps){
      switch (questionMap['type']) {
        case 0: questions.add(ChooseType(
                  question: questionMap['question'],
                  options: questionMap['options'],
                  chooseType: questionMap['chooseType']
                ));
                break;
        case 1: questions.add(TextTypeQuestion(
                 question: questionMap['question'],
                 answer: questionMap['answer']  
                ));
                break;
        case 2: questions.add(DateTypeQuestion(
                  question: questionMap['question'],
                  dateTime: questionMap['dateTime']
                ));
                 break;
        case 3: questions.add(AmountType(
                  question: questionMap['question'],
                  amount: questionMap['amount']
                ));
                break;
        default: print('There was some problem with type!!');
                 break;
      }
    }
    return Service(
      name: json['name'],
      status: json['status'],
      questions: questions
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name' : this.name,
      'status' : this.status,
      'serviceId' : this.serviceId,
      'questions' : this.questions.map((e) => e.toMap()).toList()
    };
  }

}