import 'dart:ffi';

class DictionaryModel {
  String? id;
  String word;
  String pronunciationUS;
  String pronunciationUK;
  String definition;
  String form;
  String similar;
  String speciality;
  String? isLiked;

  DictionaryModel(
      {this.id,
      required this.word,
      required this.pronunciationUS,
      required this.pronunciationUK,
      required this.definition,
      required this.form,
      required this.similar,
      required this.speciality,
      this.isLiked});
}
