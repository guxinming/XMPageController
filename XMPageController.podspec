#
#  Be sure to run `pod spec lint XMPageControl.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "XMPageControl"
  s.version      = "1.0.2"
  s.summary      = "this a page controller"
  s.license      = "MIT"
  s.homepage     = "https://github.com/guxinming/XMPageController.git"
  s.author        = { "liliangming" => "liliangming@58ganji.com" }
  s.ios.deployment_target = '6.0'
  s.source       = { :git => "https://github.com/guxinming/XMPageController.git", :tag => s.version }
  s.source_files  = "XMPageController/XMPageController/XMPageController/*.{h,m}"
  s.frameworks    = 'Foundation', 'CoreGraphics', 'UIKit'
  s.requires_arc = true

end
