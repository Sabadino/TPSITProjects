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
  int _decimi = 0;
  bool _isPaused = false;
  String _buttonState = 'START';
  
  Timer? _timer;
  StreamController<int>? _tickStream;
  StreamController<int>? _secStream;

  @override
  void initState() {
    super.initState();
    
    _tickStream = StreamController<int>();
    _secStream = StreamController<int>();
    
    // 10 tick = 1 secondo
    int count = 0;
    _tickStream!.stream.listen((tick) {
      count++;
      if (count == 10) {
        _secStream!.add(_decimi ~/ 10);
        count = 0;
      }
    });
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isPaused) return;
      
      _tickStream?.add(1);
      setState(() {
        _decimi++;
      });
    });
  }

  void onMainButtonPress() {
    setState(() {
      if (_buttonState == 'START') {
        _buttonState = 'STOP';
        _decimi = 0;
        _isPaused = false;
        startTimer();
      } else if (_buttonState == 'STOP') {
        _buttonState = 'RESET';
        _timer?.cancel();
      } else {
        _buttonState = 'START';
        _decimi = 0;
      }
    });
  }

  void onPausePress() {
    if (_buttonState != 'STOP') return;
    
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  String getTimeText() {
    int totalSec = _decimi ~/ 10;
    int min = totalSec ~/ 60;
    int sec = totalSec % 60;
    int dec = _decimi % 10;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}.${dec}';
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
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isPaused ? 'PAUSED' : _buttonState,
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
            heroTag: 'pause',
            onPressed: onPausePress,
            backgroundColor: Colors.orange,
            child: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
          ),
          const SizedBox(width: 15),
          FloatingActionButton(
            heroTag: 'main',
            onPressed: onMainButtonPress,
            backgroundColor: _buttonState == 'START' 
                ? Colors.green 
                : _buttonState == 'STOP' 
                    ? Colors.red 
                    : Colors.blue,
            child: Icon(
              _buttonState == 'START' 
                  ? Icons.play_arrow 
                  : _buttonState == 'STOP' 
                      ? Icons.stop 
                      : Icons.refresh,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tickStream?.close();
    _secStream?.close();
    super.dispose();
  }
}