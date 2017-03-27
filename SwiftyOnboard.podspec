Pod::Spec.new do |s|

  s.name               = "SwiftyOnboard"
  s.version            = "1.0.0"
  s.summary            = "A framework that allows developers to create onboarding experiences."
  s.description        = "A framework that allows developers to create onboarding experiences ahbdhabdh asbdhabd jabsdhas."
  s.homepage           = "https://github.com/juanpablofernandez/SwiftyOnboard"
  s.license            = "MIT"
  s.author             = "Juan Pablo Fernandez"
  s.social_media_url   = "https://github.com/juanpablofernandez"
  s.platform           = :ios, "9.0"
  s.source             = { :git => "https://github.com/juanpablofernandez/SwiftyOnboard.git", :tag => "#{s.version}" }
  s.source_files       = "SwiftyOnboard", "SwiftyOnboard/**/*.{h,m,swift}"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

end
