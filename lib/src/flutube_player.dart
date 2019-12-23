import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutube/custom_chewie/custom_chewie_player.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class FluTube extends StatefulWidget {
  /// Youtube video URL(s)
  final String _videourl;

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

  /// The placeholder is displayed underneath the Video before it is initialized
  /// or played.
  final Widget placeholder;

  /// Whether or not to show the video thumbnail when the video did not start playing.
  final bool showThumb;

  /// Video events

  /// Video start
  final VoidCallback onVideoStart;

  /// Video end
  final VoidCallback onVideoEnd;

  FluTube(
    this._videourl, {
    Key key,
    this.aspectRatio,
    this.autoInitialize = false,
    this.autoPlay = false,
    this.startAt,
    this.looping = false,
    this.placeholder,
    this.showControls = true,
    this.showThumb = true,
    this.onVideoStart,
    this.onVideoEnd,
  });

  @override
  FluTubeState createState() => FluTubeState();
}

class FluTubeState extends State<FluTube>{
  VideoPlayerController videoController;
  bool isPlaying = false;
  bool _needsShowThumb;

  @override
  initState() {
    super.initState();
    _needsShowThumb = !widget.autoPlay;
    _initialize(widget._videourl);
  }

  _initialize(String _url) {
    _fetchVideoURL(_url).then((url) {
      videoController = VideoPlayerController.network(url)
        ..addListener(_playingListener)
        ..addListener(_endListener);

      // Video start callback
      if(widget.onVideoStart != null) {
        videoController.addListener(_startListener);
      }
    });
  }

  _playingListener() {
    if(isPlaying != videoController.value.isPlaying){
      setState(() {
        isPlaying = videoController.value.isPlaying;
      });
    }
  }

  _startListener() {
    if(videoController.value.initialized && isPlaying)
      widget.onVideoStart();
  }

  _endListener() {
    // Video end callback
    if(videoController != null) {
      if(videoController.value.initialized && !videoController.value.isBuffering) {
        if(videoController.value.position >= videoController.value.duration){
          if(isPlaying){
            videoController.pause();
            videoController.seekTo(Duration());
          }
          if(widget.onVideoEnd != null)
            widget.onVideoEnd();
          if(widget.showThumb) {
            setState(() {
              _needsShowThumb = true;
            });
          }
        }
      }
    }
  }

  @override
  void dispose() {
    if (videoController != null) videoController.dispose();
    super.dispose();
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
                  _videoThumbURL(widget._videourl),
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
                            videoController.play();
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
      return videoController != null ? Chewie(
        videoController,
        aspectRatio: widget.aspectRatio,
        autoInitialize: widget.autoInitialize,
        autoPlay: widget.autoPlay,
        startAt: widget.startAt,
        looping: widget.looping,
        placeholder: widget.placeholder,
        showControls: widget.showControls,
      ) : AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Center(
          child: CircularProgressIndicator(),
        ),
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
    print(finalUrl);
    return finalUrl;
  }

  Iterable<String> _allStringMatches(String text, RegExp regExp) => regExp.allMatches(text).map((m) => m.group(0));

  String _videoThumbURL(String yt) {
    String id = _getVideoIdFromUrl(yt);
    return "http://img.youtube.com/vi/$id/0.jpg";
  }
  
  String _getVideoIdFromUrl(String url) {
      // For matching https://youtu.be/<VIDEOID>
      RegExp regExp1 = new RegExp(r"youtu\.be\/([^#\&\?]{11})", caseSensitive: false, multiLine: false);
      // For matching https://www.youtube.com/watch?v=<VIDEOID>
      RegExp regExp2 = new RegExp(r"\?v=([^#\&\?]{11})", caseSensitive: false, multiLine: false);
      // For matching https://www.youtube.com/watch?x=yz&v=<VIDEOID>
      RegExp regExp3 = new RegExp(r"\&v=([^#\&\?]{11})", caseSensitive: false, multiLine: false);
      // For matching https://www.youtube.com/embed/<VIDEOID>
      RegExp regExp4 = new RegExp(r"embed\/([^#\&\?]{11})", caseSensitive: false, multiLine: false);
      // For matching https://www.youtube.com/v/<VIDEOID>
      RegExp regExp5 = new RegExp(r"\/v\/([^#\&\?]{11})", caseSensitive: false, multiLine: false);

      String matchedString;

      if(regExp1.hasMatch(url)) {
        matchedString = regExp1.firstMatch(url).group(0);
      }
      else if(regExp2.hasMatch(url)) {
        matchedString = regExp2.firstMatch(url).group(0);
      }
      else if(regExp3.hasMatch(url)) {
        matchedString = regExp3.firstMatch(url).group(0);
      }
      else if(regExp4.hasMatch(url)) {
        matchedString = regExp4.firstMatch(url).group(0);
      }
      else if(regExp5.hasMatch(url)) {
        matchedString = regExp5.firstMatch(url).group(0);
      }

      return matchedString != null ? matchedString.substring(matchedString.length - 11) : null;
    }
}
