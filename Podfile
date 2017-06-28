# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def firebase_pod
    pod 'Firebase/Database'
    pod 'Firebase/Auth'
    pod 'Firebase/Storage'
    pod 'GoogleSignIn'
end

def facebook_pod
    pod 'Bolts'
    pod 'FBSDKCoreKit'
    pod 'FBSDKLoginKit'
end

def indoorAtlas_pod
    pod 'IndoorAtlas'
    pod 'SVProgressHUD', :git => 'https://github.com/SVProgressHUD/SVProgressHUD.git'
end


target 'IndoorNavigation' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FirebaseLogin
  firebase_pod
  
  # Pods for Facebook Connect
  facebook_pod
  
  indoorAtlas_pod

  target 'IndoorNavigationTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'IndoorNavigationUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
