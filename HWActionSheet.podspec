Pod::Spec.new do |s|
  s.name         = 'HWActionSheet'
  s.summary      = 'A custom actionSheet of iOS components.'
  s.version      = '1.0.0'
  s.license      = 'MIT'
  s.authors      = { 'HenryCheng' => 'clearloveway@gmail.com' }
  s.social_media_url = 'http://clearloveway.com'
  s.homepage     = 'https://github.com/loveway/HWActionSheet'
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/loveway/HWActionSheet', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = 'HWActionSheetDemo/HWActionSheet/*.{h,m}'
 
  s.frameworks = 'UIKit'

end