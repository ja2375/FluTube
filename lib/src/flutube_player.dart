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

  /// Whether or not to show the video thumbnail when the video did not start playing.
  final bool showThumb;

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
    this.showThumb = true,
  }) : super(key: key);

  @override
  FluTubeState createState() => FluTubeState();
}

class FluTubeState extends State<FluTube>{
  VideoPlayerController controller;
  bool isPlaying = false;
  bool _needsShowThumb = true;

  @override
  initState() {
    super.initState();
    _fetchVideoURL(widget.videourl).then((url) {
      setState(() {
        controller = VideoPlayerController.network(url)
          ..addListener(() {
            if(isPlaying != controller.value.isPlaying){
              setState(() {
                isPlaying = controller.value.isPlaying;
              });
            }
          });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.showThumb && !isPlaying && _needsShowThumb){
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.network(
                  _videoThumbURL(widget.videourl),
                  fit: BoxFit.cover,
                ),
                Center(
                  child: ClipOval(
                    child: Container(
                      color: Colors.white,
                      child: IconButton(
                        iconSize: 50.0,
                        color: Colors.black,
                        icon: Icon(
                          Icons.play_arrow,
                        ),
                        onPressed: () {
                          setState(() {
                            controller.play();
                            _needsShowThumb = false;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return controller != null ? WillPopScope(
        onWillPop: () {
          controller.dispose();
        },
        child: Chewie(
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
        ),
      ) : Center(
        child: CircularProgressIndicator(),
      );
    }
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

  String _videoThumbURL(String yt) {
    String id = yt.substring(yt.indexOf('v=') + 2);
    if(id.contains('&'))
      id = id.substring(0, id.indexOf('&'));
    return "http://img.youtube.com/vi/${id}/0.jpg";
  }
}
