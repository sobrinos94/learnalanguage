import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../models/word.dart';

class WordService {
  Future<List<Word>> loadWords() async {
    final raw = await rootBundle.loadString('assets/data/woordenlijst.csv');
    final rows = const CsvToListConverter().convert(raw, eol: '\n');
    return rows.skip(1).map((r) => Word.fromCsvRow(r)).toList();
  }
}
