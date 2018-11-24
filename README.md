# FluTube

Embed Youtube videos in your flutter apps just by passing in the video URL!

PLASE NOTE: Embedding copyrighted videos is actually not possible. Please use [flutter_youtube](https://pub.dartlang.org/packages/flutter_youtube) instead.

This plugin uses an in-built API so the official YT API is not used here and therefore you don't need any API keys.

This plugin also uses the great plugin [Chewie](https://github.com/brianegan/chewie) to provide a nice material or cupertino video player. And please note this plugin is NOT a replacement for Chewie. Chewie is a great plugin and here we are just using it.
I have updated Chewie with some of the pull requests it had on the original repo as well.

Huge thank you to [@brianegan](https://github.com/brianegan) for developing Chewie.

## Demo

![Demo](https://github.com/ja2375/FluTube/raw/master/example/Screenshot.jpg)

## Installation

In your `pubspec.yaml` file within your Flutter Project: 

```yaml
dependencies:
  flutube: ^0.2.0
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
