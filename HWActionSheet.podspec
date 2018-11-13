Pod::Spec.new do |s|
s.name         = 'HWActionSheet'
s.version      = '1.0.2'
s.summary      = 'A custom actionSheet of iOS.'
s.homepage     = 'https://github.com/loveway/HWActionSheet'
s.license      = 'MIT'
s.authors      = {'HenryCheng' => 'clearloveway@gmail.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/loveway/HWActionSheet.git', :tag => s.version}
s.source_files = 'HWActionSheet/*.{h,m}'
s.requires_arc = true
end