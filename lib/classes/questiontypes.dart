

import 'package:mugadminpage/classes/question.dart';

//Contains simpler question types like date text amount

class TextTypeQuestion extends Question{
  
  final String answer; // text answer
  TextTypeQuestion({this.answer, String question}) : super(question: question){
    this.type = 1;
  }

  factory TextTypeQuestion.fromJson(Map<String, dynamic> json) {
    return TextTypeQuestion(
      question: json['question'],
      answer: json['answer']
    );
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'question' : this.question,
      'answer' : this.answer,
      'type' : this.type
    };
  }
}

class DateTypeQuestion extends Question{

  final DateTime dateTime;

  DateTypeQuestion({this.dateTime, String question}) : super(question: question){
    this.type = 2;
  }

  factory DateTypeQuestion.fromJson(Map<String, dynamic> json){
    final _dateTime = json['dateTime'];
    return DateTypeQuestion(
      question: json['question'],
      dateTime: DateTime.utc(_dateTime['year'], _dateTime['month'], _dateTime['day'])
    );
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'question' : this.question,
      'type' : this.type,
      'dateTime' : {
        'year' : this.dateTime.year,
        'month' : this.dateTime.month,
        'day' : this.dateTime.day
      }
    };
  }
}

class AmountType extends Question{
  final double amount;
  AmountType({this.amount, String question}) : super(question: question){
    this.type = 3;
  }

  factory AmountType.fromJson(Map<String, dynamic> json) {
    return AmountType(
      question: json['question'],
      amount: json['amount']
    );
  } 

  @override
  Map<String, dynamic> toMap(){
    return {
      'question' : this.question,
      'type' : this.type,
      'amount' : this.amount
    };
  }

}