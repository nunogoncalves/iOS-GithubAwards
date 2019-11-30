use_frameworks!
platform :ios, '10.0'

target 'OctoPodium' do

#    pod 'Kanna', '~> 1.0.6'
    pod 'Kanna', :git => 'https://github.com/tid-kijyun/Kanna.git', branch: 'master'
#    pod 'Locksmith', '2.0.8'
    pod 'Locksmith', '4.0.0'
    pod 'ARSPopover', '~>2.2.1'
    pod 'OHHTTPStubs/Swift', '~>6.1.0'
    pod '1PasswordExtension', '~> 1.8.5'
    pod 'netfox', '~>1.15.0', configurations: ['debug']

    target 'OctoPodiumTests' do
      pod 'Quick', '2.1'
      pod 'Nimble', '~>8.0.1'
      pod 'iOSSnapshotTestCase'
    end
end

target 'OctoPodiumUITests' do

  pod 'iOSSnapshotTestCase'
end
