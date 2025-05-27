import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class EventModel {
  final String id;
  final String eventName;
  final String registerUrl;
  final String location;
  final DateTime date;
  final DateTime updatedAt;
  final DateTime createdAt;
  final List<String> images;
  final String details;
  final DateTime expiry;
  EventModel({
    required this.id,
    required this.eventName,
    required this.registerUrl,
    required this.location,
    required this.date,
    required this.updatedAt,
    required this.createdAt,
    required this.images,
    required this.details,
    required this.expiry,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'eventName': eventName,
      'registerUrl': registerUrl,
      'location': location,
      'date': date.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt.millisecondsSinceEpoch ~/ 1000,
      'images': images,
      'details': details,
      'expiry': expiry.millisecondsSinceEpoch ~/ 1000,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] as String,
      eventName: map['eventname'] as String,
      registerUrl: map['registeredUrl'] as String,
      location: map['location'] as String,
      date: DateTime.parse(map['date']),
      updatedAt: DateTime.parse(map['updatedAt']),
      createdAt:
          DateTime.fromMillisecondsSinceEpoch((map['createdAt'] as int) * 1000),
      images: List<String>.from(map['images'] ?? []),
      details: map['details'] as String? ?? '',
      expiry:
          DateTime.fromMillisecondsSinceEpoch((map['expiray'] as int) * 1000),
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
