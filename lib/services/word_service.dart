import 'dart:math';
import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/word_service.dart';

enum StudyMode { recall, multipleChoice, typing }

extension StudyModeX on StudyMode {
  String get label {
    switch (this) {
      case StudyMode.recall:
        return 'In je hoofd (flashcard)';
      case StudyMode.multipleChoice:
        return 'Meerkeuze';
      case StudyMode.typing:
        return 'Typen';
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<WordItem> _words = [];
  int _idx = 0;
  bool _revealed = false;
  int _good = 0;
  int _bad = 0;
  StudyMode _mode = StudyMode.recall;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await WordService.loadWords();
    items.shuffle(_rng);
    setState(() => _words = items);
  }

  void _next({bool? correct}) {
    if (correct == true) _good++;
    if (correct == false) _bad++;
    if (_words.isEmpty) return;
    setState(() {
      _revealed = false;
      _idx = (_idx + 1) % _words.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ready = _words.isNotEmpty;
    final word = ready ? _words[_idx] : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LeanraLanguage'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text('✅ $_good  ❌ $_bad', style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: ready
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButton<StudyMode>(
                    value: _mode,
                    onChanged: (m) => setState(() => _mode = m ?? StudyMode.recall),
                    items: StudyMode.values
                        .map((m) => DropdownMenuItem(value: m, child: Text(m.label)))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            word!.prompt,
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          if (_mode == StudyMode.recall) ...[
                            if (_revealed)
                              Text(word.answer, style: const TextStyle(fontSize: 22))
                            else
                              Text('Tik op “Toon antwoord”', style: TextStyle(color: Colors.grey[600])),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              children: [
                                OutlinedButton(
                                  onPressed: () => setState(() => _revealed = true),
                                  child: const Text('Toon antwoord'),
                                ),
                                FilledButton.icon(
                                  onPressed: _revealed ? () => _next(correct: true) : null,
                                  icon: const Icon(Icons.check),
                                  label: const Text('Goed'),
                                ),
                                FilledButton.tonalIcon(
                                  onPressed: _revealed ? () => _next(correct: false) : null,
                                  icon: const Icon(Icons.close),
                                  label: const Text('Fout'),
                                ),
                              ],
                            ),
                          ] else if (_mode == StudyMode.typing) ...[
                            _TypingBlock(
                              word: word,
                              onResult: (ok) => _next(correct: ok),
                            ),
                          ] else ...[
                            _MultipleChoiceBlock(
                              word: word,
                              pool: _words,
                              onResult: (ok) => _next(correct: ok),
                              rng: _rng,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Woord ${_idx + 1}/${_words.length}'),
                      IconButton(
                        onPressed: () => _next(),
                        icon: const Icon(Icons.skip_next),
                        tooltip: 'Volgende',
                      )
                    ],
                  )
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _TypingBlock extends StatefulWidget {
  final WordItem word;
  final void Function(bool ok) onResult;

  const _TypingBlock({required this.word, required this.onResult});

  @override
  State<_TypingBlock> createState() => _TypingBlockState();
}

class _TypingBlockState extends State<_TypingBlock> {
  final _ctrl = TextEditingController();
  String? _feedback;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _ctrl,
          decoration: const InputDecoration(labelText: 'Typ het vertaalde woord'),
          onSubmitted: (_) => _check(),
        ),
        const SizedBox(height: 8),
        FilledButton(onPressed: _check, child: const Text('Check')),
        if (_feedback != null) ...[
          const SizedBox(height: 8),
          Text(_feedback!, style: TextStyle(color: _feedback!.startsWith('✅') ? Colors.green : Colors.red)),
        ],
      ],
    );
  }

  void _check() {
    final given = _ctrl.text.trim();
    final ok = given.toLowerCase() == widget.word.answer.toLowerCase();
    setState(() {
      _feedback = ok ? '✅ Goed!' : '❌ Fout — ${widget.word.answer}';
    });
    Future.delayed(const Duration(milliseconds: 600), () => widget.onResult(ok));
  }
}

class _MultipleChoiceBlock extends StatefulWidget {
  final WordItem word;
  final List<WordItem> pool;
  final Random rng;
  final void Function(bool ok) onResult;

  const _MultipleChoiceBlock({
    required this.word,
    required this.pool,
    required this.onResult,
    required this.rng,
  });

  @override
  State<_MultipleChoiceBlock> createState() => _MultipleChoiceBlockState();
}

class _MultipleChoiceBlockState extends State<_MultipleChoiceBlock> {
  int? _selected;
  late final List<String> _options;

  @override
  void initState() {
    super.initState();
    _options = _buildOptions();
  }

  List<String> _buildOptions() {
    final opts = <String>{widget.word.answer};
    while (opts.length < 4 && opts.length < widget.pool.length) {
      final candidate = widget.pool[widget.rng.nextInt(widget.pool.length)].answer;
      opts.add(candidate);
    }
    final list = opts.toList()..shuffle(widget.rng);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(_options.length, (i) {
          return RadioListTile<int>(
            value: i,
            groupValue: _selected,
            onChanged: (v) => setState(() => _selected = v),
            title: Text(_options[i]),
          );
        }),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: _selected == null
              ? null
              : () {
                  final ok = _options[_selected!] == widget.word.answer;
                  widget.onResult(ok);
                },
          child: const Text('Bevestig'),
        ),
      ],
    );
  }
}
