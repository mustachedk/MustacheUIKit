Pod::Spec.new do |s|
  s.name             = 'MustacheUIKit'
  s.version          = '0.1.1'
  s.summary          = 'Helper methods used at Mustache when creating new apps.'
  s.homepage         = 'https://github.com/mustachedk/MustacheUIKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tommy Sadiq Hinrichsen' => 'th@mustache.dk' }
  s.source           = { :git => 'https://github.com/mustachedk/MustacheUIKit.git', :tag => s.version.to_s }
  s.swift_version = '5.0'

  s.ios.deployment_target = '11.0'

  s.source_files = 'MustacheUIKit/Classes/**/*', 'MustacheUIKit/Extensions/**/*'

  s.frameworks = 'UIKit'

end
