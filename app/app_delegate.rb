class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launch_options)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @window.backgroundColor = UIColor.grayColor
    @window.rootViewController = MainViewController.alloc.init

    # take up the whole screen
    @window.rootViewController.wantsFullScreenLayout = true

    # show the window
    @window.makeKeyAndVisible

    # dim the status bar
    application.setStatusBarStyle(UIStatusBarStyleBlackTranslucent)

    # return true to indicate this AppDelegate responded to this method
    true
  end
end
