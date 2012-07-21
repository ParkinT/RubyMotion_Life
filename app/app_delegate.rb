class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launch_options)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @window.backgroundColor = UIColor.lightGrayColor
    @window.rootViewController = MainViewController.alloc.init

    # take up the whole screen
    @window.rootViewController.wantsFullScreenLayout = true

    # show the window
    @window.makeKeyAndVisible

    application.setStatusBarHidden(true, withAnimation:UIStatusBarAnimationSlide)

#    Tapstream.setAccountName:"websembly", developerSecret:"xYv9OHVETuKs5aJyADmtjg"
    # return true to indicate this AppDelegate responded to this method
    true
  end

  def info_controller
    @info_controller ||= InfoController.alloc.init
  end

end
