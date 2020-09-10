Pod::Spec.new do |s|
  s.name             = 'MustacheUIKit'
  s.version          = '1.3.1'
  s.summary          = 'Helper methods used at Mustache when creating new apps.'
  s.homepage         = 'https://github.com/mustachedk/MustacheUIKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tommy Sadiq Hinrichsen' => 'th@mustache.dk' }
  s.source           = { :git => 'https://github.com/mustachedk/MustacheUIKit.git', :tag => s.version.to_s }
  s.swift_version = '5.1'

  s.ios.deployment_target = '11.0'

  s.source_files = 'Sources/MustacheUIKit/Classes/**/*', 'Sources/MustacheUIKit/Extensions/**/*'

  s.frameworks = 'UIKit'

  s.ios.resource_bundle = { 'MustacheUIKit' => 'MustacheUIKit/Assets/*.xcassets' }

  s.dependency 'MustacheFoundation'
  s.dependency 'Kingfisher'

end
