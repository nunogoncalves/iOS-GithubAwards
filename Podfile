use_frameworks!

def testing_pods
    pod 'Quick', '1.2.0'
    pod 'Nimble'
end

target 'OctoPodium' do
    pod 'Google/Analytics'
#    pod 'Kanna', '~> 1.0.6'
    pod 'Kanna', :git => 'https://github.com/tid-kijyun/Kanna.git', branch: 'feature/v4.0.0'
#    pod 'Locksmith', '2.0.8'
    pod 'Locksmith', '4.0.0'
    pod 'SDWebImage', '~>4.2.2'
    pod 'ARSPopover', '~> 2.2.1'
end

target 'OctoPodiumTests' do
  testing_pods
end

target 'OctoPodiumUITests' do
  testing_pods
end
