// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Todomodel {
  Todomodel({
    required this.title,
    this.decription,
    this.id,
    required this.isComplated,
    required this.author,
  });
  String? id;
  final String title;
  final String? decription;
  final bool isComplated;
  final String author;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'decription': decription,
      'isComplated': isComplated,
      'author': author,
    };
  }

  factory Todomodel.fromMap(Map<String, dynamic> map) {
    return Todomodel(
      title: map['title'] as String,
      decription: map['decription'] as String,
      isComplated: map['isComplated'] as bool,
      author: map['author'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todomodel.fromJson(String source) =>
      Todomodel.fromMap(json.decode(source) as Map<String, dynamic>);
}
