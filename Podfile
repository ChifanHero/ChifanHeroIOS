source 'https://github.com/CocoaPods/Specs.git'
# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'Lightning' do

pod 'Alamofire', '~> 3.5.0'
pod 'Kingfisher', '~> 2.6.0'
pod 'Flurry-iOS-SDK/FlurrySDK', '~> 7.1.1'
pod 'SlideMenuControllerSwift', '~> 2.3.0'
pod 'GooglePlaces'
pod 'SKPhotoBrowser', '~> 3.1.3'

end

target 'LightningTests' do

end

target 'LightningUITests' do

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
