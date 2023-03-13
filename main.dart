import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _playVideo(BuildContext context) {
    final url = _urlController.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IjkPlayerPage(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: '输入网络地址',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _playVideo(context),
              child: Text('播放视频'),
            ),
          ],
        ),
      ),
    );
  }
}

class IjkPlayerPage extends StatefulWidget {
  final String url;

  const IjkPlayerPage({Key? key, required this.url}) : super(key: key);

  @override
  _IjkPlayerPageState createState() => _IjkPlayerPageState();
}

class _IjkPlayerPageState extends State<IjkPlayerPage> {
  late IjkMediaController _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initController() async {
    _controller = IjkMediaController();
    await _controller.setNetworkDataSource(
      widget.url,
      autoPlay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('视频播放'),
      ),
      body: IjkPlayer(ijkMediaController: _controller),
    );
  }
}
