# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Budget_Caddie' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.1' #set your minimum version your all pods will set to mininum 13.1 version :-)
      end
    end
  end
  # Pods for Budget_Caddie

 pod 'Alamofire', '= 5.0.0-rc.2'
 pod 'AlamofireObjectMapper'
 pod 'SDWebImage'
 pod 'TPKeyboardAvoidingSwift'
 pod 'Toast-Swift'
 pod 'DatePicker', '~> 1.3.0'
 pod 'SwiftMessages'
 pod 'PMAlertController'
 pod 'SOTabBar'
 pod 'JXSegmentedView'
 pod 'DropDown'
 pod 'Plaid'
 pod 'CountryPickerView'
 pod 'SwiftCharts', '~> 0.6.5'
 pod 'AWSS3'
 pod 'WXImageCompress'
 pod 'SDWebImage'
 pod 'FirebaseAuth'
 pod 'RMQClient'
 pod 'NVActivityIndicatorView'
end
