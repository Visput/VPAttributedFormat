Pod::Spec.new do |s|
s.name         =  'VPAttributedFormat'
s.version      =  '1.0.0'
s.license      =  { :type => 'MIT', :file => 'LICENSE' }
s.homepage     =  'https://github.com/Visput/VPAttributedFormat'
s.authors      =  { 'Visput' => 'uladzimir.papko@gmail.com' }
s.summary      =  'VPAttributedFormat project represents category: NSAttributedString+VPAttributedFormat.'

# Source Info
s.platform     =  :ios, '6.0'
s.source       =  { :git => 'https://github.com/Visput/VPAttributedFormat', :tag => "v#{s.version}" }
s.source_files =  'VPAttributedFormat/**/*.{h,m}'

s.requires_arc = true

end