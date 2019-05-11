use_frameworks!
platform :ios, '10.0'

def testing_pods
    pod 'Quick', '2.1'
    pod 'Nimble', '~>8.0.1'
end

target 'OctoPodium' do
    pod 'Google/Analytics'
#    pod 'Kanna', '~> 1.0.6'
    pod 'Kanna', :git => 'https://github.com/tid-kijyun/Kanna.git', branch: 'master'
#    pod 'Locksmith', '2.0.8'
    pod 'Locksmith', '4.0.0'
    pod 'Nuke', '~> 7.6'
    pod 'ARSPopover', '~>2.2.1'
    pod 'OHHTTPStubs/Swift', '~>6.1.0'

    target 'OctoPodiumTests' do
      testing_pods
      pod 'iOSSnapshotTestCase'
    end
end

target 'OctoPodiumUITests' do

  pod 'iOSSnapshotTestCase'
end
