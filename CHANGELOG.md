## 0.7.0

* Updated to work with Chewie ^0.9.0

## 0.6.2

* Fix copy-paste issue

## 0.6.1

* Fix minor bugs

## 0.6.0

* Fixed bugs and added example on hos to implement a playlist

## 0.5.2

* Fixed Stack overflow on videoEnd callback.

## 0.5.1

* Fixed `autoPlay` not working due to video thumbnail
* Added `fullscreenByDefault` property

## 0.5.0

* Added `onVideoStart` and `onVideoEnd` (extremely useful) callbacks

## 0.4.3-4

* Revert 0.4.2 as it was not working

## 0.4.1-2

* Changed dispose approach trying to fix some errors derived from video disposal

## 0.4.0

* Added thumbnail to videos (thumbnail loads directly from YT). You can control whether you want to display the original video thumbnail with the `showThumb` property. The default value is `true`.

## 0.3.1

* Fix bugs
* You can now access the inner video controller via `GlobalKey<FlutubeState>`

## 0.3.0

* Updated Chewie to 0.8.0
* Removed unnecessary code
* Fixed bugs

## 0.2.0

* Fix [#2](https://github.com/ja2375/FluTube/issues/2)
* Fixed a potential bug that made videos don't stop playing when route was deactivated

## 0.1.2

* Fixed a bug which made `autoStart` property not work without setting `autoInitialize` to true.

## 0.1.1

* Updated http dependency to allow installation on all Flutter channels.

## 0.1.0

* Added in-plugin API. The plugin does not depend anymore on the YT Link Deconstructor hosted on HerokuApp.

## 0.0.1

* Initial release.
