Pod::Spec.new do |s|
  s.name          = "FwiCore"
  s.version       = "1.0.0"
  s.summary       = "FwiCore project"
  s.description   = "Using for iOS project"
  s.homepage      = "https://google.com.vn"
  s.license       = "MIT"
  s.author        = "DungVu"
  s.platform      = :ios, "10.0"
  s.source       = { :path => '.' }
  s.source_files        = "Sources/FwiCore/*.*"
  s.dependency = 'Alamofire'
  s.dependency = 'CocoaLumberjack'
  s.subspec 'FwiCoreRX' do |df|
       df.source_files = "Sources/FwiCoreRX/*.*"
       df.dependency = 'RxSwift'
       df.dependency = 'RxCocoa'
  end
end
