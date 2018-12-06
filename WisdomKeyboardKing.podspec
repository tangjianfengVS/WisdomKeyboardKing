

Pod::Spec.new do |s|
  s.name         = "WisdomKeyboardKing"
  s.version      = "0.4.3"
  s.summary      = "A short description of WisdomKeyboardKing."
  s.description  = "Keyboard housekeeper A short description of WisdomKeyboardKing"

  s.homepage     = "https://github.com/tangjianfengVS/WisdomKeyboardKing"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "tangjianfeng" => "497609288@qq.com" }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/tangjianfengVS/WisdomKeyboardKing.git", :tag => s.version }

  s.source_files  = "WisdomKeyboardKing/WisdomKeyboardKing/WisdomKeyboardKing/*.swift"
end
