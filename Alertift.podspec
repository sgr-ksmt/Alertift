Pod::Spec.new do |s|
  s.name             = "Alertift"
  s.version          = "1.3"
  s.summary          = "UIAlertControlelr wrapper for Swift."
  s.homepage         = "https://github.com/sgr-ksmt/Alertift"
  # s.screenshots     = ""
  s.license          = 'MIT'
  s.author           = { "Suguru Kishimoto" => "melodydance.k.s@gmail.com" }
  s.source           = { :git => "https://github.com/sgr-ksmt/Alertift.git", :tag => s.version.to_s }
  s.platform         = :ios, '9.0'
  s.requires_arc     = true
  s.source_files     = "Sources/**/*"
end
