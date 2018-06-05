#
# Be sure to run `pod lib lint BrickBatView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
	s.name             = 'BrickBatView'
	s.version          = '1.1.0'
	s.summary          = 'BrickBatView'
	
	s.description      = <<-DESC
	BrickBatView is a simple create alertView.
	DESC
	
	s.homepage         = 'https://github.com/zerojian/BrickBatView'
	s.license          = { :type => 'MIT', :file => 'LICENSE' }
	s.author           = { 'ZeroJian' => 'zj17223412@outlook.com' }
	s.source           = { :git => 'https://github.com/ZeroJian/BrickBatView.git', :tag => s.version.to_s }
	
	s.ios.deployment_target = '8.0'
	s.swift_version = '4.0'
	
	s.source_files = 'BrickBatView/Classes/**/*'
	
	s.dependency 'SnapKit'
end
