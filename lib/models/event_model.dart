import 'package:flutter/material.dart';

class EventModel {
  String title;
  String description;
  String time;
  String date;
  String year;
  String month;
  String day;
  String hour;
  String minute;
  bool isFavourite;
  bool isEnabled=false;

  EventModel(
      {required this.title,
      required this.description,
      required this.time,
      required this.date,
      required this.year,
      required this.month,
      required this.day,
      required this.hour,
      required this.minute,
      required this.isFavourite});

  factory EventModel.fromJson(Map json) {
    return EventModel(
        title: json['title'],
        description: json['description'],
        time: json['time'],
        date: json['date'],
        year: json['year'],
        month: json['month'],
        day: json['day'],
        hour: json['hour'],
        minute: json['minute'],
        isFavourite: json['isFavourite']
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'time': time,
        'date': date,
        'year': year,
        'month': month,
        'day': day,
        'hour': hour,
        'minute': minute,
        'isFavourite':isFavourite
      };

  convertToDate(){
    return DateTime(int.parse(year),int.parse(month),int.parse(day),int.parse(hour),int.parse(minute));
  }

}
