Pod::Spec.new do |s|
  s.name          = 'FwiCoreRX'
  s.version       = '1.0.0'
  s.summary       = 'FwiCoreRX project'
  s.description   = 'Using for iOS project'
  s.homepage      = 'https://google.com.vn'
  s.license       = 'MIT'
  s.author        = 'DungVu'
  s.platform      = :ios, "10.0"
  s.source       = { :path => '.' }
  s.source_files        = 'Sources/FwiCoreRX/*.*'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
end
