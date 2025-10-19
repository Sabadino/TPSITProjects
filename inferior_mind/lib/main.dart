import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inferior Mind',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Inferior Mind'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Color> _colorSequence = [];

  String _message = "Guess the color sequence";

  List<Color> _selectedColors = List.generate(4, (index) => Colors.grey);

  List<int> _colorIndices = List.generate(4, (index) => 0);

  final List<Color> _availableColors = [Colors.blue, Colors.red, Colors.yellow];

  @override
  void initState() {
    super.initState();
    _generateSequence();
  }

  void _generateSequence() {
    final r = Random();

    _colorSequence = [];

    for (int i = 0; i < 4; i++) {
      int randomIndex = r.nextInt(_availableColors.length);
      Color randomColor = _availableColors[randomIndex];
      _colorSequence.add(randomColor);
    }
  }

  void _changeColor(int index) {
    setState(() {
      // serve per ricostruire il widget (aggiornare l'interfaccia,è un metodo di stateful widget)
      _colorIndices[index]++;
      if (_colorIndices[index] >= _availableColors.length) {
        _colorIndices[index] = 0;
        _selectedColors[index] = _availableColors[0];
      } else {
        _selectedColors[index] = _availableColors[_colorIndices[index]];
      }
    });
  }

  void _checkWin() {
    setState(() {
      if (_selectedColors.contains(Colors.grey)) {
        _message = "You must fill all the colors!";
        return;
      } else if (_selectedColors.toString() == _colorSequence.toString()) {
        _message = "You win! 🎯";
        _generateSequence();
      } else {
        _message = "Try again!";
      }

      _selectedColors = List.generate(4, (index) => Colors.grey);

      _colorIndices = List.generate(4, (index) => 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        shadowColor: Theme.of(context).shadowColor,
        elevation: 4,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_message, style: Theme.of(context).textTheme.headlineSmall),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedColors[index],
                  ),
                  onPressed: () => _changeColor(index),
                  child: null,
                );
              }),
            ), //Text(_colorSequence.toString())
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _checkWin,
        tooltip: 'Check',
        child: const Icon(Icons.question_mark),
      ),
    );
  }
}
