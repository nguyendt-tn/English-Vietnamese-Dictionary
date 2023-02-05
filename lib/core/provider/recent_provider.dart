import 'package:dictionary/core/helpers/db_helper.dart';
import 'package:dictionary/core/models/dictionary.dart';
import 'package:flutter/material.dart';

class RecentProvider extends ChangeNotifier {
  List<DictionaryModel> _itemRecents = [];
  List<DictionaryModel> _itemFavorites = [];

  List<DictionaryModel> get itemRecents => _itemRecents;
  List<DictionaryModel> get itemFavorites => _itemFavorites;

  Future insertDatabase(
      String word,
      String pronunciationUS,
      String pronunciationUK,
      String definition,
      String form,
      String similar,
      String speciality,
      String isLiked) async {
    final newRecent = DictionaryModel(
        word: word,
        pronunciationUS: pronunciationUS,
        pronunciationUK: pronunciationUK,
        definition: definition,
        form: form,
        similar: similar,
        speciality: speciality,
        isLiked: isLiked);
    _itemRecents.add(newRecent);

    await DBHelper.insertRecent({
      'word': newRecent.word,
      'pronunciationUS': newRecent.pronunciationUS,
      'pronunciationUK': newRecent.pronunciationUK,
      'definition': newRecent.definition,
      'form': newRecent.form,
      'similar': newRecent.similar,
      'speciality': newRecent.speciality,
      'isLiked': newRecent.isLiked ?? 'false'
    });

    notifyListeners();
  }

  Future<void> selectRecents() async {
    final dataList = await DBHelper.selectAllRecent();
    _itemRecents = dataList
        .map((item) => DictionaryModel(
            id: item['id'].toString(),
            word: item['word'],
            pronunciationUS: item['pronunciationUS'],
            pronunciationUK: item['pronunciationUK'],
            definition: item['definition'],
            form: item['form'],
            similar: item['similar'],
            speciality: item['speciality'],
            isLiked: item['isLiked']))
        .toList();
    notifyListeners();
  }

  Future<void> selectFavorites() async {
    final dataList = await DBHelper.selectAllFavorite();
    _itemFavorites = dataList
        .map((item) => DictionaryModel(
            id: item['id'].toString(),
            word: item['word'],
            pronunciationUS: item['pronunciationUS'],
            pronunciationUK: item['pronunciationUK'],
            definition: item['definition'],
            form: item['form'],
            similar: item['similar'],
            speciality: item['speciality'],
            isLiked: item['isLiked']))
        .toList();
    notifyListeners();
  }

  Future<void> updateRecentById(id, String isLiked) async {
    final db = await DBHelper.database();
    await db.update(
      'histories',
      {'isLiked': isLiked},
      where: "id = ?",
      whereArgs: [id],
    );
    notifyListeners();
  }
}
