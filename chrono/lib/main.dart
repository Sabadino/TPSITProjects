import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const ChronoApp());
}

class ChronoApp extends StatelessWidget {
  const ChronoApp({super.key});

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
  const ChronoScreen({super.key});

  @override
  State<ChronoScreen> createState() => _ChronoScreenState();
}

class _ChronoScreenState extends State<ChronoScreen> {
  int totalSeconds = 0;
  bool paused = false;
  String buttonState = 'START';
  
  StreamSubscription<int>? tickSubscription;
  StreamController<int>? secStream;

  @override
  void initState() {
    super.initState();
    secStream = StreamController<int>();
  }

  void startCounting() {
    // Stream.periodic genera tick ogni 100ms
    Stream<int> tickStream = Stream.periodic(
      const Duration(milliseconds: 100),
      (count) => count,
    );
    
    // Pipe: 10 tick = 1 secondo
    int tickCount = 0;
    tickSubscription = tickStream.listen((tick) {
      if (paused) return;
      
      tickCount++;
      if (tickCount == 10) {
        secStream?.add(totalSeconds);
        tickCount = 0;
      }
      
      setState(() {
        totalSeconds++;
      });
    });
  }

  void onMainButtonPress() {
    setState(() {
      if (buttonState == 'START') {
        buttonState = 'STOP';
        totalSeconds = 0;
        paused = false;
        startCounting();
      } else if (buttonState == 'STOP') {
        buttonState = 'RESET';
        tickSubscription?.cancel();
      } else {
        buttonState = 'START';
        totalSeconds = 0;
        paused = false;
      }
    });
  }

  void onPauseButtonPress() {
    if (buttonState != 'STOP') return;
    
    setState(() {
      paused = !paused;
    });
  }

  String getTimeText() {
    int min = totalSeconds ~/ 600;
    int sec = (totalSeconds ~/ 10) % 60;
    int tenth = totalSeconds % 10;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}.$tenth';
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                getTimeText(),
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              paused ? 'PAUSED' : (buttonState == 'STOP' ? 'RUNNING' : buttonState),
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn1',
            onPressed: onPauseButtonPress,
            backgroundColor: Colors.orange,
            child: Icon(paused ? Icons.play_arrow : Icons.pause),
          ),
          const SizedBox(width: 15),
          FloatingActionButton(
            heroTag: 'btn2',
            onPressed: onMainButtonPress,
            backgroundColor: buttonState == 'START' ? Colors.green : (buttonState == 'STOP' ? Colors.red : Colors.blue),
            child: Icon(buttonState == 'START' ? Icons.play_arrow : (buttonState == 'STOP' ? Icons.stop : Icons.refresh)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tickSubscription?.cancel();
    secStream?.close();
    super.dispose();  
  }
}
