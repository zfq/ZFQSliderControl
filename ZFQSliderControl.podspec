Pod::Spec.new do |s|

	s.name = "ZFQSliderControl"
	s.version  = "1.0"
	s.description = <<-DESC
					this is description
					DESC
	s.summary = "This have nothing useful just for test"
	s.source = { :git => "https://github.com/zfq/ZFQSliderControl" }
	
	s.homepage     = "https://github.com/zfq/ZFQSliderControl"
	s.license      = "MIT"
	s.author       = { "zhaofuqiang" => "1586687169zfq@gmail.com" }
				
	s.platform     = :ios
	s.platform     = :ios, "7.0"
	s.requires_arc = true
	s.source_files = 'ZFQSliderControl/','字体大小控件/字体大小控件/ZFQSliderControl/*.{h,m}'
	
end
