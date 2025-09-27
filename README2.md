App-navigatie & hoofdstructuur
– Maak in lib/main.dart een MaterialApp met named routes:

return MaterialApp(
  title: 'Leanralanguage',
  initialRoute: '/',
  routes: {
    '/': (_) => const HomeScreen(),
    '/quiz': (_) => const QuizScreen(),
    '/result': (_) => const ResultScreen(),
  },
);


– Zo kun je vanuit je HomeScreen navigeren naar de quiz en resultaten.

Screens aanmaken
– HomeScreen:

Toon een lijstje met modi (bijv. “In je hoofd”, “Meerkeuze”, “Typen”) als ListView.

Elke modus is een ListTile die met Navigator.pushNamed(context, '/quiz', arguments: modus) naar de quiz gaat.
– QuizScreen:

Ontvangt via ModalRoute.of(context)!.settings.arguments de gekozen modus.

Laadt de woordenlijst (CSV) via een WordService (of ChangeNotifier) en toont vragen/blokken.
– ResultScreen:

Krijgt via arguments de score mee en toont een samenvatting: correct, fout, opnieuw starten.

Data-laag opzetten
– Maak lib/services/word_service.dart:

import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../models/word.dart';

class WordService {
  Future<List<Word>> loadWords() async {
    final raw = await rootBundle.loadString('assets/data/woordenlijst.csv');
    final rows = const CsvToListConverter().convert(raw, eol: '\n');
    return rows.map((r) => Word(fromCsvRow: r)).toList();
  }
}


– Implementeer in lib/models/word.dart een constructor Word.fromCsvRow(List<dynamic> row).

State-management
– Voorbeeld: gebruik een eenvoudige ChangeNotifier (of Riverpod) om de lijst met woorden en voortgang bij te houden.
– Injecteer WordService in main.dart via een ChangeNotifierProvider (of InheritedWidget) zodat elke screen toegang heeft tot de data.

UI-details & styling
– Voeg in pubspec.yaml de csv-dependency toe:

dependencies:
  csv: ^5.0.0


– Gebruik consistent materiaal-design: AppBar-titels, Buttons, padding, etc.
– Voorzie elke screen van een SafeArea en voldoende marges (Padding) zodat het er netjes uitziet op alle telefoons.

Testen in debug-modus
– Run in de container:

flutter run


(kies Linux desktop als device)
– Of download de APK en installeer op je telefoon zoals besproken.