import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Video Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Video Player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(() {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> convertVideo(String inputPath, String outputPath) async {
    final arguments = '-i $inputPath -c:v libx264 -c:a copy $outputPath';
    await _flutterFFmpeg.execute(arguments);
    return outputPath;
  }

  void _playVideo() {
    setState(() {
      _isPlaying = true;
      _controller.play();
    });
  }

  void _pauseVideo() {
    setState(() {
      _isPlaying = false;
      _controller.pause();
    });
  }

  void _stopVideo() {
    setState(() {
      _isPlaying = false;
      _controller.pause();
      _controller.seekTo(Duration.zero);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: _isPlaying ? _pauseVideo : _playVideo,
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.stop),
                  onPressed: _stopVideo,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String inputPath = 'path/to/input/video.avi';
          String outputPath = 'path/to/output/video.mp4';
          String convertedPath = await convertVideo(inputPath, outputPath);

          setState(() {
            _controller = VideoPlayerController.file(File(convertedPath
