#
#  Be sure to run `pod spec lint HKScrollingNavAndTabBar.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "HKScrollingNavAndTabBar"
  s.version      = "1.0.0"
  s.summary      = "An easy to use library that manages hiding and showing of navigation bar, tab bar or toolbar when user scrolls."

  s.description  = <<-DESC
An easy to use library that manages hiding and showing of navigation bar, tab bar or toolbar when user scrolls.
More detail you can see source:https://github.com/HustHank/HKScrollingNavAndTabBar.
                    DESC

  s.homepage     = "https://github.com/HustHank/HKScrollingNavAndTabBar#note"
  s.license      = "MIT"
  s.author             = { "" => "huangkai1128@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/HustHank/HKScrollingNavAndTabBar.git", :tag => "#{s.version}" }
  s.source_files  = "HKScrollingNavAndTabBar", "HKScrollingNavAndTabBar/*.{h,m}"

end
