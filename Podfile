platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'
target 'PrincessGuide' do
  pod 'SnapKit'
  pod 'FMDB'
  pod 'SwiftyJSON'
  pod 'DynamicColor'
  pod 'Kingfisher'
  pod 'KingfisherWebP'
  pod 'TTGTagCollectionView'
  pod 'AcknowList'
  pod 'ReachabilitySwift'
  pod 'Alamofire'
  pod 'lz4'
  pod 'MJRefresh'
  pod 'Timepiece'
  pod 'Tabman'
  pod 'Eureka'
  pod 'ImageViewer', :git => 'https://github.com/superk589/ImageViewer.git'
#  pod 'SwiftyStoreKit'
  pod 'BrotliKit'
  pod 'Cache', :git => 'https://github.com/Igor-Palaguta/Cache', :branch => 'Update-MD5'
  pod 'DHSmartScreenshot'
  pod 'Reusable'
  pod 'R.swift'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if Gem::Version.new('9.0') > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
  end
end
