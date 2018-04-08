use_frameworks!
platform :ios, '10.0'

def testing_pods
    pod 'Quick', '1.2.0'
    pod 'Nimble'
end

target 'OctoPodium' do
    pod 'Google/Analytics'
#    pod 'Kanna', '~> 1.0.6'
    pod 'Kanna', :git => 'https://github.com/tid-kijyun/Kanna.git', branch: 'master'
#    pod 'Locksmith', '2.0.8'
    pod 'Locksmith', '4.0.0'
    pod 'SDWebImage', '~>4.2.2'
    pod 'ARSPopover', '~> 2.2.1'

    target 'OctoPodiumTests' do
      testing_pods
      pod 'iOSSnapshotTestCase', git: 'https://github.com/nunogoncalves/ios-snapshot-test-case.git', branch: 'flexible-names'
    end
end

target 'OctoPodiumUITests' do

  pod 'iOSSnapshotTestCase', git: 'https://github.com/nunogoncalves/ios-snapshot-test-case.git', branch: 'flexible-names'
end
