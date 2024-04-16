import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    audioRecord = Record();
    audioPlayer = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Recording'),
      ),
      body: Center(
        child: Column(
          children: [
            if (isRecording) const Text('Recording in progress...'),
            ElevatedButton(
              onPressed: isRecording ? stopRecording : startRecording,
              child: Text(isRecording ? 'Stop Recording' : 'Strat Recording'),
            ),
            const SizedBox(height: 25.0),
            if (!isRecording && audioPath.isNotEmpty) ...[
              ElevatedButton(
                onPressed: playRecording,
                child: const Text('Play Recording'),
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  Get.back(result: audioPath);
                },
                child: const Text('Select Recording'),
              ),
            ]
          ],
        ),
      ),
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
      print('Error Start Reording $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
        print('audioPath -> $audioPath');
      });
    } catch (e) {
      print('Error Stop Reording $e');
    }
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    } catch (e) {
      print('Error Play Reording $e');
    }
  }
}
