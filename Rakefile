$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'life'
  app.identifier = "com.websembly.#{app.name}"
  app.delegate_class = 'AppDelegate'
  app.version = '0.9'
  app.short_version = '0.9' #required to be incremented for AppStore (http://iconoclastlabs.com/cms/blog/posts/updating-a-rubymotion-app-store-submission)
  app.icons = ["#{app.name}.png", "#{app.name}-72.png", "#{app.name}@2x.png"]
  app.device_family = [:iphone, :ipad]
  app.interface_orientations = [:portrait, :landscape_left, :landscape_right] #:portrait_upside_down
  app.vendor_project('vendor/Tapstream.framework', :static,
        :products => ['Tapstream'],
        :headers_dir => 'Headers')
end
