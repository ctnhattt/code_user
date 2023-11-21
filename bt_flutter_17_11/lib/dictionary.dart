import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class DictionaryEntry {
  String term;
  String definition;

  DictionaryEntry({required this.term, required this.definition});

  factory DictionaryEntry.fromJson(Map<String, dynamic> json) {
    return DictionaryEntry(
      term: json.keys.first,
      definition: json.values.first,
    );
  }
}

class DictionaryLoader {
  Future<String> _loadDictionaryAsset() async {
    return await rootBundle.loadString('data/dictionary.json');
  }

  Future<List<DictionaryEntry>> loadDictionary() async {
    String jsonString = await _loadDictionaryAsset();
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    List<DictionaryEntry> entries = jsonMap.entries.map((entry) => DictionaryEntry.fromJson({entry.key: entry.value})).toList();
    return entries;
  }
}
