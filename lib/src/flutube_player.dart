import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class FluTube extends StatefulWidget {
  /// Youtube URL of the video
  final String videourl;

  /// Initialize the Video on Startup. This will prep the video for playback.
  final bool autoInitialize;

  /// Play the video as soon as it's displayed
  final bool autoPlay;

  /// Start video at a certain position
  final Duration startAt;

  /// Whether or not the video should loop
  final bool looping;

  /// Whether or not to show the controls
  final bool showControls;

  /// The Aspect Ratio of the Video. Important to get the correct size of the
  /// video!
  ///
  /// Will fallback to fitting within the space allowed.
  final double aspectRatio;

  /// The colors to use for controls on iOS. By default, the iOS player uses
  /// colors sampled from the original iOS 11 designs.
  final ChewieProgressColors cupertinoProgressColors;

  /// The colors to use for the Material Progress Bar. By default, the Material
  /// player uses the colors from your Theme.
  final ChewieProgressColors materialProgressColors;

  /// The placeholder is displayed underneath the Video before it is initialized
  /// or played.
  final Widget placeholder;

  FluTube(
    this.videourl, {
    Key key,
    this.aspectRatio,
    this.autoInitialize = false,
    this.autoPlay = false,
    this.startAt,
    this.looping = false,
    this.cupertinoProgressColors,
    this.materialProgressColors,
    this.placeholder,
    this.showControls = true,
  }) : super(key: key);

  @override
  FluTubeState createState() => FluTubeState();
}

class FluTubeState extends State<FluTube>{
  VideoPlayerController controller;
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  @override
  initState() {
    super.initState();
    _fetchVideoURL(widget.videourl).then((url) {
      setState(() {
        controller = VideoPlayerController.network(url)
          ..addListener(() {
            if(_isPlaying != controller.value.isPlaying)
              setState(() {
                _isPlaying = controller.value.isPlaying;
              });
          });
      });
    });
  }

  @override
  void dispose() {
    if(controller != null)
      controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controller == null ?
    Container() :
    Chewie(
      controller,
      key: widget.key,
      aspectRatio: widget.aspectRatio,
      autoInitialize: widget.autoInitialize,
      autoPlay: widget.autoPlay,
      startAt: widget.startAt,
      looping: widget.looping,
      cupertinoProgressColors: widget.cupertinoProgressColors,
      materialProgressColors: widget.materialProgressColors,
      placeholder: widget.placeholder,
      showControls: widget.showControls,
    );
  }

  Future<String> _fetchVideoURL(String yt) async {
    final response = await http.get(yt);
    Iterable parseAll = _allStringMatches(response.body, RegExp("\"url_encoded_fmt_stream_map\":\"([^\"]*)\""));
    final Iterable<String> parse = _allStringMatches(parseAll.toList()[0], RegExp("url=(.*)"));
    final List<String> urls = parse.toList()[0].split('url=');
    parseAll = _allStringMatches(urls[1], RegExp("([^&,]*)[&,]"));
    String finalUrl = Uri.decodeFull(parseAll.toList()[0]);
    if(finalUrl.indexOf('\\u00') > -1)
      finalUrl = finalUrl.substring(0, finalUrl.indexOf('\\u00'));
    return finalUrl;
  }

  Iterable<String> _allStringMatches(String text, RegExp regExp) => regExp.allMatches(text).map((m) => m.group(0));
}