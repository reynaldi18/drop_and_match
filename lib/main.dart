import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:drag_drop/database/queries/time_query.dart';
import 'package:drag_drop/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';

import 'database/db_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'PressStart',
      ),
      home: ColorGame(),
    );
  }
}

class ColorGame extends StatefulWidget {
  ColorGame({Key? key}) : super(key: key);

  createState() => ColorGameState();
}

class ColorGameState extends State<ColorGame> {
  /// Map to keep track of score
  final Map<dynamic, bool> score = {};

  final DbHelper _helper = new DbHelper();

  /// Choices for game
  final Map choices = {
    SvgPicture.asset(
      'assets/images/bleach.svg',
      color: Colors.green,
      width: 80,
    ): SvgPicture.asset(
      'assets/images/bleach.svg',
      width: 80,
    ),
    SvgPicture.asset(
      'assets/images/square.svg',
      color: Colors.yellow,
      width: 80,
    ): SvgPicture.asset(
      'assets/images/square.svg',
      width: 80,
    ),
    SvgPicture.asset(
      'assets/images/rectangle.svg',
      color: Colors.red,
      width: 80,
    ): SvgPicture.asset(
      'assets/images/rectangle.svg',
      width: 80,
    ),
    SvgPicture.asset(
      'assets/images/diamond.svg',
      color: Colors.purple,
      width: 80,
    ): SvgPicture.asset(
      'assets/images/diamond.svg',
      width: 80,
    ),
    SvgPicture.asset(
      'assets/images/circle.svg',
      color: Colors.brown,
      width: 80,
    ): SvgPicture.asset(
      'assets/images/circle.svg',
      width: 80,
    )
  };

  // Random seed to shuffle order of items.
  Random seed = Random();
  List<int> seedValue = [1, 2, 3, 4, 5];
  int setSeed = 0;
  Timer? _timer;
  int _time = 0;

  @override
  void initState() {
    startTimer();
    setSeed = seed.nextInt(seedValue.length);
    super.initState();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          _time++;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time: $_time Second'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
          );
          setState(() {
            score.clear();
            _time = 0;
          });
        },
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: choices.keys.map((emoji) {
                    return Draggable<Widget>(
                      data: emoji,
                      child: Container(
                        child: Emoji(
                          emoji: score[emoji] == true ? Container() : emoji,
                        ),
                      ),
                      feedback: Emoji(emoji: emoji),
                      childWhenDragging: Emoji(
                        emoji: Container(),
                      ),
                    );
                  }).toList()),
              Container(
                height: 2,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: choices.keys
                    .map((emoji) => _buildDragTarget(emoji))
                    .toList()
                      ..shuffle(
                        Random(setSeed),
                      ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDragTarget(emoji) {
    return DragTarget(
      builder: (BuildContext context, List<Widget?> incoming, List rejected) {
        if (score[emoji] == true) {
          return Container(
            color: Colors.white,
            child: Text('Correct!'),
            alignment: Alignment.center,
            height: 80,
            width: 80,
          );
        } else {
          return choices[emoji];
        }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          score[emoji] = true;
          plyr.play('success.mp3');
        });
        if (score.length == 5) {
          _timer?.cancel();
          _showMyDialog(context, _time);
          _helper.insert(TimeQuery.TABLE_NAME, {"TIME":_time});
        }
      },
      onLeave: (data) {},
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class Emoji extends StatelessWidget {
  Emoji({Key? key, required this.emoji}) : super(key: key);

  final Widget emoji;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: emoji,
      ),
    );
  }
}

Future<void> _showMyDialog(BuildContext context, int time) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Yeay kamu berhasil!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text('Perolehan waktu kamu: $time detik'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Next'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Result()),
              );
            },
          ),
        ],
      );
    },
  );
}

AudioCache plyr = AudioCache();
