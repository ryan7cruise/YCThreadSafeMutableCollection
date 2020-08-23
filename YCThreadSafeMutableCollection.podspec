#
# Be sure to run `pod lib lint YCThreadSafeMutableCollection.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YCThreadSafeMutableCollection'
  s.version          = '0.1.0'
  s.summary          = 'Thread-safe mutable array, dictionary and set.'

  s.homepage         = 'https://github.com/ryan7cruise/YCThreadSafeMutableCollection'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Yuchen Peng' => 'yuchenpeng826@hotmail.com' }
  s.source           = { :git => 'https://github.com/ryan7cruise/YCThreadSafeMutableCollection.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'YCThreadSafeMutableCollection/Classes/**/*'
  
end
