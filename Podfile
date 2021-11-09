source 'https://github.com/CocoaPods/Specs.git'

project 'DXCmoviesApp'

install! 'cocoapods', :deterministic_uuids => false

# Common pods used on all targets
def common_pods

    use_frameworks!

    ### Network
    pod 'ReachabilitySwift', '~> 5.0'
    pod 'Moya', '~> 15.0'
    pod 'AlamofireImage', '~> 4'

    ### Gif
    pod 'SwiftyGif'

    ### Helpers
    # Reusable components
    pod 'Reusable', '~> 4.1'
    
    ### Rating with stars
    pod 'Cosmos', '~> 23.0'

    ### ------------ Firebase ------------
    # Analytics without IDFA collection capability, use this pod instead
    #pod 'Firebase/AnalyticsWithoutAdIdSupport'

end


def debug_pods
    # Inspect your iOS application at runtime
    #pod 'Peek', :configurations => ['Debug']
end


######################## iOS ###########################

target 'DXCmoviesApp' do
    # iOS Platform
    platform :ios,  '13.0'

    # --- Common Pods ---
    common_pods

    # --- Debug Pods ---
    debug_pods
end



######################## CONFIGURATION ###########################

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'YES'
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            # ignore all warnings from all pods
            config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
       end
    end
end
