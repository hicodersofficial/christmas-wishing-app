import 'dart:convert';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:christmas/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  static const String routeName = "/home";
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool _showSplash = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _controller;
  List<User> _users = [];
  List<Widget> _usersInView = [];
  bool _isShowingFollowers = false;

  final int _inViewElement = 15;
  int _seedIndex = 0;
  Future<void> _playAudio() async {
    await _audioPlayer.play(
        'https://dm0qx8t0i9gc9.cloudfront.net/previews/audio/BsTwCwBHBjzwub4i4/wind-chimes-steady-chime_zJB9i8N__NWM.mp3');
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _audioPlayer.onPlayerCompletion.listen((event) async {
      await _playAudio();
    });
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showSplash = false;
        });
        await _playAudio();
      }
    });
    rootBundle.loadString('assets/data/users.json').then((value) {
      final List data = jsonDecode(value);
      setState(() {
        _users = data.map((user) => User.fromJson(user)).toList();
      });
    });
  }

  double _randomPosition(offset) {
    return Random().nextDouble() * offset;
  }

  void loadUsers() async {
    final List<Widget> loadedUsers = [];
    if (_users.length - _seedIndex >= _inViewElement) {
      for (var i = 0; i < _inViewElement; i++) {
        loadedUsers.add(
          UserTile(
              _users[_seedIndex + i],
              _randomPosition(MediaQuery.of(context).size.height - 100),
              _randomPosition(MediaQuery.of(context).size.width - 100)),
        );
      }
    } else {
      for (var i = 0; i < _users.length - _seedIndex; i++) {
        loadedUsers.add(
          UserTile(
              _users[_seedIndex + i],
              _randomPosition(MediaQuery.of(context).size.height - 100),
              _randomPosition(MediaQuery.of(context).size.width - 100)),
        );
      }
    }

    setState(() {
      _usersInView = loadedUsers;
    });

    await Future.delayed(const Duration(seconds: 3), () {
      if (_seedIndex < _users.length && _isShowingFollowers) {
        _seedIndex += _inViewElement;
        _usersInView = [];
        loadUsers();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: _showSplash
            ? Column(
                children: [
                  const SizedBox(height: 110),
                  FadeInDown(
                    child: Lottie.asset(
                      'assets/animations/anime-1.json',
                      height: MediaQuery.of(context).size.width,
                      controller: _controller,
                      onLoaded: (LottieComposition composition) {
                        _controller.duration =
                            composition.duration - const Duration(seconds: 1);
                        _controller.forward();
                      },
                    ),
                  ),
                ],
              )
            : Stack(
                alignment: Alignment.topCenter,
                children: [
                  FadeIn(
                    child: Lottie.asset(
                      'assets/animations/anime-4.json',
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    child: Builder(builder: (context) {
                      return FadeInUp(
                        child: Lottie.asset(
                          'assets/animations/anime-2.json',
                          height: MediaQuery.of(context).size.width,
                          animate: !_isShowingFollowers,
                        ),
                      );
                    }),
                  ),
                  if (_isShowingFollowers)
                    Container(
                      height: MediaQuery.of(context).size.height,
                      color: const Color(0xB9000000),
                    ),
                  Positioned(
                    bottom: 20,
                    width: MediaQuery.of(context).size.width - 100,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.all(15),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          )),
                      child: Text(_isShowingFollowers ? "Stop" : "Start"),
                      onPressed: () {
                        if (_isShowingFollowers) {
                          setState(() {
                            _isShowingFollowers = false;
                            _seedIndex += _inViewElement;
                            _usersInView = [];
                          });
                        } else {
                          setState(() {
                            _isShowingFollowers = true;
                          });
                          loadUsers();
                        }
                      },
                    ),
                  ),
                  ..._usersInView
                ],
              ),
      ),
    );
  }
}

class User {
  final String username;
  final String fullName;
  final String imageUrl;

  User(this.username, this.fullName, this.imageUrl);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json["username"], json["name"], json["imgUrl"]);
  }
}
