#
#  Be sure to run `pod spec lint SWLogger.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = 'SWLogger'
  s.version      = '0.1.1'
  s.summary      = 'A simple, functional Swift Logger'
    s.platform = :ios
    s.ios.deployment_target = '9.0'

  s.description  = <<-DESC
This cocoapod facilitates some common things required in modern logging frameworks.
                   DESC

  s.homepage     = 'http://github.com/parrotbait/SWLogger'
  s.source = { :git => 'https://github.com/parrotbait/SWLogger.git', :tag => s.version.to_s}
  s.source_files  = 'SWLogger/*.{swift}'

  s.license      = 'MIT'

  s.author             = { 'Eddie Long' => 'parrotbait@gmail.com' }

end
