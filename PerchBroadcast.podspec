#
# Be sure to run `pod lib lint PerchBroadcast.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "PerchBroadcast"
  s.version          = "0.1.0"
  s.summary          = "Lightweight iOS SDK for broadcasting live video with django-broadcast."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
  						Easily broadcast one-to-many video and audio streams
  					 	in conjunction with django-broadcast. Developed for use
  					 	with the Perch iOS app. 

  					 	https://perchlive.com
                       DESC

  s.homepage         = "https://github.com/PerchLive/PerchBroadcast-iOS-SDK"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { "Chris Ballinger" => "chrisballinger@gmail.com" }
  s.source           = { :git => "https://github.com/PerchLive/PerchBroadcast-iOS-SDK.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.resource_bundles = {
    'PerchBroadcast' => ['PerchBroadcast/Assets/*.png']
  }

  s.source_files        = 'PerchBroadcast/Classes/**/*', 
                          'FFmpeg/ffmpeg-ios-static-libs/include/**/*.h'
  s.public_header_files = 'FFmpeg/ffmpeg-ios-static-libs/include/**/*.h'
  s.header_mappings_dir = 'FFmpeg/ffmpeg-ios-static-libs/include'
  s.vendored_libraries  = 'FFmpeg/ffmpeg-ios-static-libs/lib/*.a'
  s.libraries           = 'avcodec', 'avdevice', 'avfilter', 'avformat', 'avutil',
                          'swresample', 'swscale', 'iconv', 'z', 'bz2'
end
