//
//  Copyright © 2015 SpotX, Inc. All rights reserved.
//

import UIKit
import TVMLKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var controller : TVApplicationController?

  lazy var window : UIWindow? = {
    let window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window.rootViewController = UIViewController()
    window.makeKeyAndVisible()
    return window
  }()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

    let menu = UIAlertController(title: "Select Application Type", message: "app type", preferredStyle: .Alert)

    menu.addAction(UIAlertAction(title: "Native", style: .Default, handler: { (_) -> Void in
      self.launchNativeApp()
    }))

    menu.addAction(UIAlertAction(title: "TVML", style: .Default, handler: { (_) -> Void in
      self.launchTVMLApp()
    }))

    self.window?.rootViewController?.presentViewController(menu, animated: false, completion: nil)

    return true
  }

  func launchNativeApp() {
    let storyboard = UIStoryboard(name: "Demo", bundle: nil)
    let viewController = storyboard.instantiateInitialViewController();
    window?.rootViewController = viewController
  }

  func launchTVMLApp() {
    let url = NSBundle.mainBundle().URLForResource("Demo", withExtension: "js")!
    let baseURL = url.URLByDeletingLastPathComponent?.absoluteString

    let context = TVApplicationControllerContext()
    context.javaScriptApplicationURL = url
    context.launchOptions["BASE_URL"] = baseURL
    self.controller = TVApplicationController(context: context, window: self.window, delegate: nil)
  }
 
}

