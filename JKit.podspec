Pod::Spec.new do |s|
s.name         = "JKit"
s.version      = "1.1.3"
s.summary      = "Fast iOS Develope App Kit"
s.description  = <<-DESC
JKit 平时用的工具类
Fast iOS Develope App Kit
DESC
s.homepage     = "https://github.com/GitHubZebra/JKit"
s.license      = "MIT"
s.author       = { "陈杰" => "mr_banma@126.com" }
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/GitHubZebra/JKit.git", :tag => s.version }
s.source_files = "JKit/**/*.{h,m}"
s.requires_arc = true
end
