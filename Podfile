source 'https://github.com/CocoaPods/Specs.git'

platform :ios, :deployment_target => '7.0'

inhibit_all_warnings!

xcodeproj 'Wikipedia'

# Networking / Parsing
pod 'AFNetworking/NSURLConnection', '~> 2.5'
pod 'hpple', '~> 0.2'
pod 'Mantle'

# Objective-C Extensions
pod 'libextobjc/EXTScope', '~> 0.4.1'

# Utilities
pod 'BlocksKit/Core', '~> 2.2'
pod 'BlocksKit/UIKit', '~> 2.2'
pod 'libextobjc/EXTScope', '~> 0.4.1'

# UI
pod 'Masonry', '~> 0.6'

# Diagnostics
pod 'HockeySDK', '3.6.2'
pod 'CocoaLumberjack', '~> 2.0.0'

target 'WikipediaUnitTests', :exclusive => false do
  pod 'OCMockito', '~> 1.4'
  pod 'OCHamcrest', '~> 4.1'
end
