import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/word_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Word> words;
  int index = 0;
  int score = 0;
  bool loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!loaded) {
      WordService().loadWords().then((list) {
        setState(() {
          words = list.take((ModalRoute.of(context)!.settings.arguments as Map)['count']).toList();
          loaded = true;
        });
      });
    }
  }

  void next(bool correct) {
    if (correct) score++;
    if (index+1 < words.length) {
      setState(() => index++);
    } else {
      Navigator.pushReplacementNamed(context, '/result', arguments: {'score': score, 'total': words.length});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final word = words[index];
    return Scaffold(
      appBar: AppBar(title: Text('Quiz ${index+1}/${words.length}')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(word.source, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: () => next(true), child: const Text('Goed')),
          ElevatedButton(onPressed: () => next(false), child: const Text('Fout')),
        ]),
      ),
    );
  }
}
