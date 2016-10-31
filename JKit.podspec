Pod::Spec.new do |s|
s.name         = "JKit"
s.version      = "2.0.4"
s.summary      = "Fast iOS Develope App Kit"
s.description  = <<-DESC
                    JKit 开发时用的工具类
                 DESC
s.homepage     = "https://github.com/GitHubZebra/JKit"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author       = { "陈杰" => "mr_banma@126.com" }
s.platform = :ios

s.ios.deployment_target = '8.0'

s.source       = { :git => "https://github.com/GitHubZebra/JKit.git", :tag => s.version }
s.source_files = "JKit/**/*.{h,m}"
s.exclude_files = "JKit/Tool/JCamera"
s.requires_arc = true

#s.dependency "SVProgressHUD"
#s.dependency "ReactiveCocoa"
#s.dependency "SDWebImage"
#s.dependency "QBImagePickerController"
end
