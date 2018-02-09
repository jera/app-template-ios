# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'LoginTemplate' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    # Pods for LoginTemplate
    
    #Layout
    pod 'TPKeyboardAvoiding', '~> 1.3'
    pod 'Cartography', '~> 3'
    pod 'Material', '~> 2'
    
    #Utilities
    pod 'R.swift'
    pod 'SwiftLint'
    
    #Reactive
    pod 'RxSwift', '~> 4'
    pod 'RxCocoa', '~> 4'
    pod 'RxGesture', '~> 1.2'
    
    #Mapper
    pod 'Moya-ObjectMapper/RxSwift'
    
    #ObjC
    pod 'FBSDKLoginKit', '~> 4.23'
    pod 'Google/SignIn'
    pod 'NSStringMask', '~> 1.2'
    
    swift4 = ['Material', 'Cartography', 'R.swift', 'RxSwift', 'RxCocoa', 'RxGesture', 'Moya-ObjectMapper/RxSwift']
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            swift_version = nil
            
            if swift4.include?(target.name)
                swift_version = '4.0'
                else
                swift_version = '3.2'
            end
            
            if swift_version
                target.build_configurations.each do |config|
                    config.build_settings['SWIFT_VERSION'] = swift_version
                    config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ''
                end
            end
        end
    end
end
