Pod::Spec.new do |s|
  s.name         = "UIImage+FlashSpriteSheet"
  s.version      = "0.1.0"
  s.summary      = "UIImage+FlashSpriteSheet"
  s.homepage     = "https://github.com/noughts/UIImage+FlashSpriteSheet"
  s.author       = { "noughts" => "noughts@gmail.com" }
  s.source       = { :git => "https://github.com/noughts/UIImage+FlashSpriteSheet.git" }
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.platform = :ios
  s.requires_arc = true
  s.source_files = 'UIImage+FlashSpriteSheet/**/*.{h,m}'
end
