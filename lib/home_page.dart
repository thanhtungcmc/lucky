import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lucky_money/assets.dart';
import 'package:lucky_money/scratch_box.dart';
import 'package:scratcher/scratcher.dart';

import 'board_view.dart';
import 'model.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double _angle = 0;
  double _current = 0;
  bool _showImg = true;
  bool _clicked=false;
  late AnimationController _ctrl;
  late Animation _ani;
  late ConfettiController _controller;

  late AudioPlayer _audioPlayer;
  final List<Luck> _items = [
    Luck("apple", Colors.accents[0]),
    Luck("raspberry", Colors.accents[2]),
    Luck("grapes", Colors.accents[4]),
    Luck("fruit", Colors.accents[6]),
    Luck("milk", Colors.accents[8]),
    Luck("salad", Colors.accents[10]),
    Luck("cheese", Colors.accents[12]),
    Luck("carrot", Colors.accents[14]),
  ];

  @override
  void initState() {
    super.initState();
    var _duration = Duration(milliseconds: 20000);
    _ctrl = AnimationController(vsync: this, duration: _duration);
    _ani = CurvedAnimation(parent: _ctrl, curve: Curves.fastLinearToSlowEaseIn);
    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showDialog();
      }
    });
    _controller = ConfettiController(
      duration: Duration(seconds: 3),
    );
    _audioPlayer = AudioPlayer();
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 1200),
    // )..addStatusListener(
    //       (listener) {
    //     if (listener == AnimationStatus.completed) {
    //       _animationController.reverse();
    //     }
    //   },
    // );
    // _animation = Tween(begin: 1.0, end: 1.5).animate(
    //   CurvedAnimation(
    //     parent: _ctrl,
    //     curve: Curves.elasticIn,
    //   ),
    // );
  }

  _showDialog() async {
    await Future.delayed(Duration(milliseconds: 50));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Material(
            type: MaterialType.transparency,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        child: const Text(
                          'Bạn đã trúng 1 lì xì\nCào để mở',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                        width: MediaQuery.of(context).size.width / 1.2,
                        color: Colors.white,
                      ),
                      ScratchBox(
                        image: 'asset/image/image.jpeg',
                        onScratch: () async {
                          _controller.play();
                          await _audioPlayer.setAsset('asset/firework.mp3');
                          await _audioPlayer.setVolume(1);
                           _audioPlayer.play();
                        },
                      )
                    ],
                  ),
                  ConfettiWidget(
                    blastDirectionality: BlastDirectionality.explosive,
                    confettiController: _controller,
                    particleDrag: 0.05,
                    emissionFrequency: 0.05,
                    numberOfParticles: 100,
                    gravity: 0.05,
                    shouldLoop: false,
                    colors: const [
                      Colors.green,
                      Colors.red,
                      Colors.yellow,
                      Colors.blue,
                    ],
                  ),
                ],
              ),
            ),
          );
        }).then((value) {
      _audioPlayer.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green, Colors.blue.withOpacity(0.2)])),
        child: AnimatedBuilder(
            animation: _ani,
            builder: (context, child) {
              final _value = _ani.value;
              final _angle = _value * this._angle;
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  BoardView(
                    items: _items,
                    current: _current,
                    angle: _angle,
                    showImg: _showImg,
                  ),
                  _buildGo(),

                  _buildResult(_value),
                ],
              );
            }),
      ),
    );
  }

  _buildGo() {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        child: Container(
          alignment: Alignment.center,
          height: 72,
          width: 72,
          child: Text(
            _clicked ? '' : 'Quất',
            style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: _animations,
      ),
    );
  }

  _animations() {
    if(_ctrl.isAnimating){
      return;
    }
    if(_clicked){
      _showDialog();
      return;
    }
    if (!_ctrl.isAnimating) {
      _clicked = true;
      var _random = 0.25;
      _angle = 20 + 2 + _random;
      _showImg = false;
      _ctrl.forward(from: 0.0).then((_) {
        _current = (_current + _random);
        _current = _current - _current ~/ 1;
        _ctrl.reset();
      });
    }
  }

  int _calIndex(value) {
    var _base = (2 * pi / _items.length / 2) / (2 * pi);
    return (((_base + value) % 1) * _items.length).floor();
  }

  _buildResult(_value) {
    var _index = _calIndex(_value * _angle + _current);
    // String _asset = Assets.imageUrlList[_index];
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('by Thanh Tung'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(Assets.dan, height: 80, width: 80),
          ),
        ),
      ],
    );
  }
}
