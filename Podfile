use_frameworks!

def testing_pods
    pod 'Quick', git: "https://github.com/Quick/Quick", branch: "swift-3.0"
    pod 'Nimble', git: "https://github.com/Quick/Nimble"
end

target 'OctoPodium' do
    pod 'Google/Analytics'
#    pod 'Kanna', '~> 1.0.6'
#    pod 'Kanna', '~> 2.0.0'
    pod 'Kanna', :git => 'https://github.com/tid-kijyun/Kanna.git', branch: 'swift3.0'
#    pod 'Locksmith', '2.0.8'
    pod 'Locksmith'
    pod 'SDWebImage', '~>3.8'
    pod 'ARSPopover', '~> 2.0'
end

target 'OctoPodiumTests' do
  testing_pods
end

target 'OctoPodiumUITests' do
  testing_pods
end
