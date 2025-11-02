import 'package:flutter/material.dart';
import 'dart:async';

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
  
  StreamController<int>? tickStream;
  StreamController<int>? secStream;

  @override
  void initState() {
    super.initState();
    
    tickStream = StreamController<int>();
    secStream = StreamController<int>();
    
    // Pipe: 10 tick = 1 secondo
    int count = 0;
    tickStream!.stream.listen((tick) {
      count++;
      if (count == 10) {
        secStream!.add(totalSeconds);
        count = 0;
      }
    });
  }

  String getTimeText() {
    int min = totalSeconds ~/ 60;
    int sec = totalSeconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  void startCounting() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!running || paused) {
        timer.cancel();
        return;
      }
      tickStream?.add(1);
      totalSeconds++;
      setState(() {});
    });
  }

  void onMainButtonPress() {
    setState(() {
      if (!running) {
        running = true;
        totalSeconds = 0;
        startCounting();
      } else {
        running = false;
      }
    });
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
      floatingActionButton: FloatingActionButton(
        onPressed: onMainButtonPress,
        backgroundColor: running ? Colors.red : Colors.green,
        child: Icon(running ? Icons.stop : Icons.play_arrow),
      ),
    );
  }

  @override
  void dispose() {
    tickStream?.close();
    secStream?.close();
    super.dispose();
  }
}