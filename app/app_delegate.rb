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

    # UIApplicationExitsOnSuspend specifies that the app should be terminated rather than moved to the background when it is quit.

    # return true to indicate this AppDelegate responded to this method
    true

  end

  def info_controller
    @info_controller ||= InfoController.alloc.init
  end

   #   Most state transitions are accompanied by a corresponding call to the methods of your app delegate object. These methods are your chance to respond to state changes in an appropriate way. These methods are listed below, along with a summary of how you might use them.

   #application:didFinishLaunchingWithOptions:—This is your app’s first chance to execute code at launch time.

   #applicationDidBecomeActive:—This is your app’s chance to prepare to run as the foreground app.
  def applicationDidBecomeActive(application)
    #You should use this method to restart any tasks that were paused (or not yet started) while the application was inactive.
    @window.rootViewController.load_world
  end

    #applicationWillResignActive:—Lets you know that your app is transitioning away from being the foreground app. Use this method to put your app into a quiescent state.
  def applicationWillResignActive(application)
    # This method is called to let your application know that it is about to move from the active to inactive state.
    @window.rootViewController.save_world 
  end

    #applicationDidEnterBackground:—Lets you know that your app is now running in the background and may be suspended at any time.
  def applicationDidEnterBackground(application)
    # You should use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  end

    # applicationWillEnterForeground:—Lets you know that your app is moving out of the background and back into the foreground, but that it is not yet active.
  def applicationWillEnterForeground(application)
    # You can use this method to undo many of the changes you made to your application upon entering the background. The call to this method is invariably followed by a call to the applicationDidBecomeActive: method, which then moves the application from the inactive to the active state.
  end

    # applicationWillTerminate:—Lets you know that your app is being terminated. This method is not called if your app is suspended.
  def applicationWillTerminate(application)
    # This method lets your application know that it is about to be terminated and purged from memory entirely. Your implementation of this method has approximately five seconds to perform any tasks and return. If the method does not return before time expires, the system may kill the process altogether.
  end

  def applicationSignificantTimeChange(application)
    # Examples of significant time changes include the arrival of midnight, an update of the time by a carrier, and the change to daylight savings time. The delegate can implement this method to adjust any object of the application that displays time or is sensitive to time changes.
  end


end
