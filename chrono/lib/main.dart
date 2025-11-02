import 'package:flutter/material.dart';

void main() {
  runApp(const ChronoApp());
}

class ChronoApp extends StatelessWidget {
  const ChronoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chrono',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ChronoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChronoScreen extends StatefulWidget {
  const ChronoScreen({Key? key}) : super(key: key);

  @override
  State<ChronoScreen> createState() => _ChronoScreenState();
}

class _ChronoScreenState extends State<ChronoScreen> {
  int totalSeconds = 0;
  bool running = false;
  bool paused = false;

  String getTimeText() {
    int min = totalSeconds ~/ 60;
    int sec = totalSeconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Chrono'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                getTimeText(),
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}