$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'motion-testflight'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'life'
  app.identifier = "com.websembly.#{app.name}"
  app.delegate_class = 'AppDelegate'
  app.version = '1.0.0'
#  app.testflight.sdk = 'vendor/TestFlight'
  app.testflight.api_token = '3406362abaf82556a69d7deb097ff660_NTIyNDM5MjAxMi0wNy0wNiAxNDozOToxOC43MDQzMTM'
  app.testflight.team_token = 'de2ae0bf624e0c20bbecc9a84980e499_MTE2ODY4MjAxMi0wOC0wMyAxNjoxNDo0My41NzM3NTY'
  app.provisioning_profile = './provisioning' #symlink
  app.codesign_certificate = 'iPhone Developer: Thom Parkin (67L9Y9KX66)'
  app.short_version = '0.92' #required to be incremented for AppStore (http://iconoclastlabs.com/cms/blog/posts/updating-a-rubymotion-app-store-submission)
  app.icons = ["#{app.name}.png", "#{app.name}-72.png", "#{app.name}@2x.png"]
  app.device_family = [:iphone, :ipad]
  app.interface_orientations = [:portrait, :landscape_left, :landscape_right] #:portrait_upside_down
  app.info_plist['UIStatusBarHidden'] = true
end
