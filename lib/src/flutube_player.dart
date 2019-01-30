import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
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

  /// Allow screen to sleep
  final bool allowScreenSleep;

  /// Show mute icon
  final bool allowMuting;

  /// Show fullscreen button.
  final bool allowFullScreen;

  /// Device orientation when leaving fullscreen.
  final List<DeviceOrientation> deviceOrientationAnterFullscreen;

  /// System overlays when exiting fullscreen.
  final List<SystemUiOverlay> systemOverlaysAfterFullscreen;

  /// The placeholder is displayed underneath the Video before it is initialized
  /// or played.
  final Widget placeholder;

  /// Play video directly in fullscreen
  final bool fullscreenByDefault;

  /// Whether or not to show the video thumbnail when the video did not start playing.
  final bool showThumb;

  /// Video events

  /// Video start
  final VoidCallback onVideoStart;

  /// Video end
  final VoidCallback onVideoEnd;

  FluTube(
    this.videourl, {
    Key key,
    this.aspectRatio,
    this.autoInitialize = false,
    this.autoPlay = false,
    this.startAt,
    this.looping = false,
    this.placeholder,
    this.showControls = true,
    this.fullscreenByDefault = false,
    this.showThumb = true,
    this.allowMuting = true,
    this.allowScreenSleep = false,
    this.allowFullScreen = true,
    this.deviceOrientationAnterFullscreen,
    this.systemOverlaysAfterFullscreen,
    this.onVideoStart,
    this.onVideoEnd,
  }) : super(key: key);

  @override
  FluTubeState createState() => FluTubeState();
}

class FluTubeState extends State<FluTube>{
  VideoPlayerController videoController;
  ChewieController chewieController;
  bool isPlaying = false;
  bool _needsShowThumb;

  @override
  initState() {
    super.initState();
    _needsShowThumb = !widget.autoPlay;
    _fetchVideoURL(widget.videourl).then((url) {
      setState(() {
        videoController = VideoPlayerController.network(url)
          ..addListener(() {
            if(isPlaying != videoController.value.isPlaying){
              setState(() {
                isPlaying = videoController.value.isPlaying;
              });
            }
          })
          ..addListener(() {
            // Video end callback
            if(videoController.value.initialized && !widget.looping){
              if(videoController.value.position >= videoController.value.duration){
                if(isPlaying){
                  chewieController.pause();
                  chewieController.seekTo(Duration());
                }
                if(widget.onVideoEnd != null)
                  widget.onVideoEnd();
                if(widget.showThumb){
                  setState(() {
                    _needsShowThumb = true;
                  });
                }
              }
            }
          });

        // Video start callback
        if(widget.onVideoStart != null) {
          videoController.addListener(() {
            if(videoController.value.initialized && isPlaying)
              widget.onVideoStart();
          });
        }

        chewieController = ChewieController(
          videoPlayerController: videoController,
          aspectRatio: widget.aspectRatio,
          autoInitialize: widget.autoInitialize,
          autoPlay: widget.autoPlay,
          startAt: widget.startAt,
          looping: widget.looping,
          placeholder: widget.placeholder,
          showControls: widget.showControls,
          fullScreenByDefault: widget.fullscreenByDefault,
          allowFullScreen: widget.allowFullScreen,
          deviceOrientationsAfterFullScreen: widget.deviceOrientationAnterFullscreen,
          systemOverlaysAfterFullScreen: widget.systemOverlaysAfterFullscreen,
          allowedScreenSleep: widget.allowScreenSleep,
          allowMuting: widget.allowMuting
        );
      });
    });
  }

  @override
  void didUpdateWidget(FluTube oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(oldWidget.videourl != widget.videourl){
      videoController.dispose();
      chewieController.dispose();
      _fetchVideoURL(widget.videourl).then((newURL) {
        videoController = VideoPlayerController.network(newURL)
          ..addListener(() {
            if(isPlaying != videoController.value.isPlaying){
              setState(() {
                isPlaying = videoController.value.isPlaying;
              });
            }
          })
          ..addListener(() {
            // Video end callback
            if(videoController.value.initialized && !widget.looping){
              if(videoController.value.position >= videoController.value.duration){
                if(isPlaying){
                  chewieController.pause();
                  chewieController.seekTo(Duration());
                }
                if(widget.onVideoEnd != null)
                  widget.onVideoEnd();
                if(widget.showThumb){
                  setState(() {
                    _needsShowThumb = true;
                  });
                }
              }
            }
          });

        // Video start callback
        if(widget.onVideoStart != null) {
          videoController.addListener(() {
            if(videoController.value.initialized && isPlaying)
              widget.onVideoStart();
          });
        }

        chewieController = ChewieController(
          videoPlayerController: videoController,
          aspectRatio: widget.aspectRatio,
          autoPlay: true,
        );
      });
    }
  }

  @override
  void dispose() {
    videoController.dispose();
    chewieController.dispose();
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
      return chewieController != null ? Chewie(
        key: widget.key,
        controller: chewieController,
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
    return finalUrl;
  }

  Iterable<String> _allStringMatches(String text, RegExp regExp) => regExp.allMatches(text).map((m) => m.group(0));

  String _videoThumbURL(String yt) {
    String id = yt.substring(yt.indexOf('v=') + 2);
    if(id.contains('&'))
      id = id.substring(0, id.indexOf('&'));
    return "http://img.youtube.com/vi/$id/0.jpg";
  }
}
