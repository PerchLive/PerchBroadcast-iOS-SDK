# [PerchBroadcast iOS SDK](https://github.com/PerchLive/PerchBroadcast-iOS-SDK)

[![CI Status](https://img.shields.io/travis/PerchLive/PerchBroadcast-iOS-SDK.svg?style=flat)](https://travis-ci.org/PerchLive/PerchBroadcast-iOS-SDK)
[![Version](https://img.shields.io/cocoapods/v/PerchBroadcast.svg?style=flat)](http://cocoapods.org/pods/PerchBroadcast)
[![License](https://img.shields.io/cocoapods/l/PerchBroadcast.svg?style=flat)](http://cocoapods.org/pods/PerchBroadcast)
[![Platform](https://img.shields.io/cocoapods/p/PerchBroadcast.svg?style=flat)](http://cocoapods.org/pods/PerchBroadcast)

[PerchBroadcast](https://github.com/PerchLive/PerchBroadcast-iOS-SDK) is a lightweight iOS SDK for broadcasting live video, designed to be used in conjunction with [django-broadcast](https://github.com/PerchLive/django-broadcast). This SDK is used within the [Perch](https://www.perchlive.com) iOS app, and we've tried to make it as generic and modular as possible to provide for future flexibility.

## How It Works

The lowest cost way to provide for one-to-many live broadcasts involves creating full HLS streams directly on the phone (via FFmpeg), and uploading the `.ts` segments and refreshing manifest `.m3u8` as soon as they become available.

The client SDK makes no assumptions about where you're storing the data, it just communicates with a server implementing the `django-broadcast` REST API to negotiate an upload location and associated credentials.

Initially we will only be supporting the AWS S3 storage backend in this SDK, and in `django-broadcast`, but we will leave it modular so other developers can add backends like HTTP, FTP, RTMP, WebRTC, as they see fit. *Please contact us if you are interested in alternative storage backends!*

Below is the general flow (ignoring authentication):

### API

* Client app initializes SDK with the `django-broadcast` API endpoint URL.
* Client app calls the SDK's `startStream` method.
* SDK makes a POST request to the `/stream/start` endpoint of your `django-broadcast` server.
* The `/stream/start` endpoint's JSON response is serialized into two native Swift objects, `Stream` and `Endpoint`.
* `Stream` contains any applicable metadata about the stream that has just been started.
* `Endpoint` contains any authorization credentials and location information for where to upload video data. For example for the AWS S3 storage backend, this could be a federated AWS token, bucket name, and a path.
* When the broadcast is over, client SDK calls `/stream/stop` to indicate that the stream is no longer live.

### AV Data

* Raw video and audio frames are captured from camera/ microphone.
* The raw video frames are fed to the `VideoToolbox.framework` hardware H.264 encoder API.
* The raw audio frames are fed to the `AVFoundation.framework` hardware AAC encoder API.
* The raw H.264 NAL units and AAC frames are fed to FFmpeg's `libavformat` muxer API.
* For HLS outputs we will use `libavformat`'s HLS mode as our muxer, and use a directory watcher to upload the `.ts` files as they are finalized, as well as continually update the `.m3u8` manifest.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* iOS 8+
* CocoaPods
* Xcode 7.1+

## Installation

PerchBroadcast is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PerchBroadcast"
```

## Author

* [Chris Ballinger](https://github.com/chrisballinger)

## License

PerchBroadcast is available under the Apache 2.0 license.

```
Copyright 2015 Perch Innovations, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```