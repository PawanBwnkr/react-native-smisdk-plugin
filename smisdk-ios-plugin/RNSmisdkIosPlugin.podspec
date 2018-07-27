
Pod::Spec.new do |s|
  s.name         = "RNSmisdkIosPlugin"
  s.version      = "1.0.0"
  s.summary      = "RNSmisdkIosPlugin"
  s.description  = <<-DESC
                  RNSmisdkIosPlugin
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNSmisdkIosPlugin.git", :tag => "master" }
  s.source_files  = "RNSmisdkIosPlugin/**/*.{h,m}"
  s.requires_arc = true
  s.dependency 'SmiSdk', :git => 'https://bitbucket.org/datami/ios-podspec.git'

  s.dependency "React"
  #s.dependency "others"

end

  