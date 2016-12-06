# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'emeraldHail' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for emeraldHail
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'SDWebImage', '~>3.8'
  pod 'GoogleSignIn'
  pod 'IQKeyboardManagerSwift'
  pod 'Fusuma', :git => 'https://github.com/pruthvikar/Fusuma.git', :commit => '503865a'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
