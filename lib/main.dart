import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Instellingen
  String langDirection = 'Duits → Nederlands';
  String itemType = '1 Woord';
  String answerMode = 'Gedachte';
  String theme = 'Algemeen';
  int count = 10;
  bool retryErrors = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instellingen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Taalrichting
          DropdownButton<String>(
            value: langDirection,
            items: const [
              DropdownMenuItem(value: 'Duits → Nederlands', child: Text('Duits → Nederlands')),
              DropdownMenuItem(value: 'Nederlands → Duits', child: Text('Nederlands → Duits')),
            ],
            onChanged: (v) => setState(() => langDirection = v!),
          ),
          const SizedBox(height: 8),
          // 2. Aantal woorden
          DropdownButton<int>(
            value: count,
            items: [5,10,20,50].map((n) => DropdownMenuItem(value: n, child: Text('$n woorden'))).toList(),
            onChanged: (v) => setState(() => count = v!),
          ),
          const SizedBox(height: 8),
          // 3. Modus
          DropdownButton<String>(
            value: answerMode,
            items: const [
              DropdownMenuItem(value: 'Gedachte', child: Text('In Gedachte')),
              DropdownMenuItem(value: 'Meerkeuze', child: Text('Meerkeuze')),
              DropdownMenuItem(value: 'Exact', child: Text('Exact Schrijven')),
            ],
            onChanged: (v) => setState(() => answerMode = v!),
          ),
          const SizedBox(height: 8),
          // 4. Herhaal fouten
          SwitchListTile(
            title: const Text('Herhaal fouten'),
            value: retryErrors,
            onChanged: (v) => setState(() => retryErrors = v),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/quiz', arguments: {
                'lang': langDirection,
                'count': count,
                'mode': answerMode,
                'retry': retryErrors,
              });
            },
            child: const Text('Start Quiz'),
          ),
        ],
      ),
    );
  }
}
