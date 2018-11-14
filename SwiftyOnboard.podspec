Pod::Spec.new do |s|

  s.name                  = "SwiftyOnboard"
  s.version               = "1.3.8"
  s.summary               = "A framework that allows developers to create onboarding experiences."
  s.description           = <<-DESC
SwiftyOnboard makes it easy to add onboarding to any iOS application. SwiftyOnboard handles all of the logic behind the pagination of views, which allows you to quickly add a highly customizable onboarding to your app, all in a lightweight framework.
                            DESC
  s.homepage              = "https://github.com/juanpablofernandez/SwiftyOnboard"
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = "Juan Pablo Fernandez"
  s.social_media_url      = "https://github.com/juanpablofernandez"
  s.ios.deployment_target = '9.0'
  s.source                = { :git => "https://github.com/juanpablofernandez/SwiftyOnboard.git", :tag => "#{s.version}" }
  s.source_files          = "SwiftyOnboard", "SwiftyOnboard/**/*.{swift}"

end
