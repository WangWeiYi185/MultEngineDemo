#
# Be sure to run `pod lib lint engine_web.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'engine_web'
  s.version          = '0.1.0'
  s.summary          = 'A short description of engine_web.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/王维一/engine_web'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '王维一' => 'weiyi.wang@ly.com' }
  s.source           = { :git => 'https://github.com/王维一/engine_web.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'


  s.source_files = 'ios_source/classes/**/*'
  s.vendored_frameworks = 'ios_source/frameworks/*.xcframework'
  s.resource_bundles = {
    'engine_web' => ['ios_source/assets/*.{png,yaml,yml,xcassets,json}' , 'assets/json/*.{json}']
  }
  
  # s.resource_bundles = {
  #   'engine_web' => ['engine_web/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
