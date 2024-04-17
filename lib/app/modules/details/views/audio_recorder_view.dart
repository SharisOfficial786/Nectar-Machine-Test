import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:machine_test_nectar/app/widgets/app_snackbar.dart';
import 'package:record/record.dart';

class AudioRecorderView extends StatefulWidget {
  const AudioRecorderView({super.key});

  @override
  State<AudioRecorderView> createState() => _AudioRecorderViewState();
}

class _AudioRecorderViewState extends State<AudioRecorderView> {
  late Record audioRecord;
  late AudioPlayer audioPlayer;

  bool isRecording = false;
  String audioPath = '';

  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;

  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

  @override
  void initState() {
    audioRecord = Record();
    audioPlayer = AudioPlayer();
    Future.delayed(Duration.zero, () {
      startRecording();
    });

    _initiliazeTempPlayer();
    super.initState();
  }

  void _initiliazeTempPlayer() {
    _playerState = audioPlayer.state;
    audioPlayer.getDuration().then((value) {
      setState(() {
        _duration = value;
      });
    });
    audioPlayer.getCurrentPosition().then((value) {
      setState(() {
        _position = value;
      });
    });
    _initStreams();
  }

  void _initStreams() {
    _durationSubscription = audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = audioPlayer.onPositionChanged.listen(
      (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription =
        audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  Future<void> _play() async {
    try {
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
      setState(() => _playerState = PlayerState.playing);
    } catch (e) {
      AppSnackbar.showSnackbar('Error Play Reording', '$e');
    }
  }

  Future<void> _pause() async {
    await audioPlayer.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await audioPlayer.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isRecording) ...[
          Lottie.asset(
            'assets/json/audio_record.json',
            height: 100.0,
            width: 100.0,
          ),
          const Text('Recording in progress...'),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: stopRecording,
            child: const Text('Stop Recording'),
          ),
        ],
        if (!isRecording && audioPath.isNotEmpty) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (!_isPlaying)
                      IconButton(
                        key: const Key('temp_play_button'),
                        onPressed: _isPlaying ? null : _play,
                        iconSize: 27.0,
                        icon: const Icon(Icons.play_arrow),
                        color: color,
                      ),
                    if (_isPlaying)
                      IconButton(
                        key: const Key('temp_pause_button'),
                        onPressed: _isPlaying ? _pause : null,
                        iconSize: 27.0,
                        icon: const Icon(Icons.pause),
                        color: color,
                      ),
                    Flexible(
                      child: SliderTheme(
                        data: const SliderThemeData(
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 10),
                        ),
                        child: Slider(
                          onChanged: (value) {
                            final duration = _duration;
                            if (duration == null) {
                              return;
                            }
                            final position = value * duration.inMilliseconds;
                            audioPlayer.seek(
                              Duration(milliseconds: position.round()),
                            );
                          },
                          value: (_position != null &&
                                  _duration != null &&
                                  _position!.inMilliseconds > 0 &&
                                  _position!.inMilliseconds <
                                      _duration!.inMilliseconds)
                              ? _position!.inMilliseconds /
                                  _duration!.inMilliseconds
                              : 0.0,
                        ),
                      ),
                    ),
                    Text(
                      _position != null
                          ? '$_positionText / $_durationText'
                          : _duration != null
                              ? _durationText
                              : '',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        if (!isRecording && audioPath.isNotEmpty) ...[
          const SizedBox(height: 15.0),
          OutlinedButton(
            onPressed: () {
              _stop();
              Get.back();
            },
            style: OutlinedButton.styleFrom(
              minimumSize: Size(Get.width, 45.0),
            ),
            child: const Text('Cancel'),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              Get.back(result: audioPath);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(Get.width, 45.0),
            ),
            child: const Text('Select Recording'),
          ),
        ]
      ],
    );
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      AppSnackbar.showSnackbar('Error Start Reording', '$e');
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
      });
    } catch (e) {
      AppSnackbar.showSnackbar('Error Stop Reording', '$e');
    }
  }
}
