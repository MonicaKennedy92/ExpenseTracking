# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ExpenseInfo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
   use_frameworks!
    pod 'GoogleSignIn'
    pod 'Firebase/Core'
    pod 'Firebase/Invites'
    pod 'Firebase/MLVision'
    pod 'Firebase/MLVisionBarcodeModel'
    pod 'Firebase/MLVisionLabelModel'
    pod 'Firebase/MLVisionTextModel'
    pod 'Firebase/MLModelInterpreter'
    pod 'DatePickerDialog'
    pod 'LLSwitch'
    pod 'VegaScrollFlowLayout'
    pod 'GooglePlaces'
    pod 'GooglePlacePicker'
    pod 'GoogleMaps'
    pod 'WSTagsField'
    pod 'XHRealTimeBlur'
    pod 'pop'
    pod 'FastScroll'
    pod 'RKPieChart'
    post_install do |installer|
        installer.pods_project.build_configurations.each do |config|
            config.build_settings.delete('CODE_SIGNING_ALLOWED')
            config.build_settings.delete('CODE_SIGNING_REQUIRED')
        end
    end


  # Pods for ExpenseInfo

  target 'ExpenseInfoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ExpenseInfoUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
