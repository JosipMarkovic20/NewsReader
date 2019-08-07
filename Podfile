 platform :ios, '10.0'

target 'NewsFactory' do
  use_frameworks!

pod 'Kingfisher'
pod 'Alamofire'
pod 'RealmSwift'
pod 'RxSwift'
pod 'RxCocoa'

def testing_pods
    pod 'Quick'
    pod 'Nimble'
    pod 'Cuckoo'
    pod 'RxTest'
end

target 'NewsFactoryTests' do
    inherit! :search_paths
    testing_pods
end


end


