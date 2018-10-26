# FluTube

Flutter plugin that facilitates the embed of YT videos without using the official YT API.

This plugin uses the Youtube Link Deconstructor v3 API and allows you tu embed a Youtube video easily in your Flutter app just by passing it the video URL!

This plugin uses the great plugin [Chewie](https://github.com/brianegan/chewie) to provide a nice material or cupertino video player. And please note this plugin is NOT a replacement for Chewie. Chewie is a great plugin and here we are just using it.
I have updated Chewie with some of the pull requests it had on the original repo as well.

Huge thank you to [@brianegan](https://github.com/brianegan) for developing Chewie.

## Installation

In your `pubspec.yaml` file within your Flutter Project: 

```yaml
dependencies:
  flutube: ^0.1.1
```

## Use it

```dart
import 'package:flutube/flutube.dart';

final flutubePlayer = Flutube(
  '<Youtube URL>',
  aspectRatio: 16 / 9,
  autoPlay: true,
  looping: true,
);
```

## Example

Please run the app in the [`example/`](https://github.com/ja2375/FluTube/tree/master/example) folder to start playing!
