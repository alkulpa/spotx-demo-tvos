//
//  Copyright © 2015 SpotX, Inc. All rights reserved.
//
import UIKit
import TVMLKit


/**

 SpotXAdDelegate receives Ad lifecycle notifications.
 
 */
protocol SpotXAdDelegate {
  func spotXAdDidStart(_: SpotXAd) -> Void
  func spotXAdDidFinish(_: SpotXAd) -> Void
  func spotXAdDidFail(_: SpotXAd, _: NSError) -> Void
}


/**
 
 SpotXAd is responsible for retreiving and presenting a single SpotX advertisement.

 */
class SpotXAd: NSObject, TVApplicationControllerDelegate {

  /**
   NOTE: Subject to change during pre-release development!!
   */
  static let SDK_URL = NSURL(string: "https://m.spotx.ninja/tvos/v1/app.js")!

  /**
   Test channel id -- will play a SpotX demo video
   */
  static let TEST_CHANNEL = "85394"

  /**
   Publisher Channel ID for this ad.
   */
  let channelId: String

  /**
   Additional parameters to be passed to the ad server.
   */
  var params : [String:String]?

  /**
   SpotXAdDelegate to receive lifecycle notifications.
   */
  var delegate: SpotXAdDelegate?


  private var _controller: TVApplicationController?


  /**
   Initializes a new SpotXAd.

   - parameter channelId: (optional) SpotX publisher channel to retrieve ad for
   - parameter delegate: (optional)
   */
  init(channelId:String = SpotXAd.TEST_CHANNEL, delegate: SpotXAdDelegate? = nil) {
    self.channelId = channelId
    self.delegate = delegate
  }

  /**
   Presents this SpotXAd modally using the given UIViewController.

   - parameter presentingViewController: UIViewController instance to present this ad
   - parameter animated: Whether the presentation should be animated
   */
  func show(presentingViewController: UIViewController, animated: Bool) -> Void {
    let context = TVApplicationControllerContext()
    context.javaScriptApplicationURL = SpotXAd.SDK_URL
    context.launchOptions["channelId"] = self.channelId
    context.launchOptions["params"] = self.params

    _controller = TVApplicationController(context: context, window: nil, delegate: self)

    let viewController: UIViewController = (_controller?.navigationController)!
    presentingViewController.presentViewController(viewController, animated: animated, completion: nil);
  }


  // MARK: - TVApplicationControllerDelegate

  func appController(appController: TVApplicationController, evaluateAppJavaScriptInContext ctx: JSContext) {

    let log: @convention(block) String -> Void = { (msg : String) in
      NSLog(msg)
    }

    // The TVML App needs an exit function to call when Ad playback is complete
    let exit: @convention(block) Void -> Void = {
      appController.stop()
    }
    ctx.setObject(unsafeBitCast(exit, AnyObject.self), forKeyedSubscript: "exit")


#if DEBUG
    // Make console.log messages show up in Xcode debug output
    let console = ctx.objectForKeyedSubscript("console")
    console.setObject(unsafeBitCast(log, AnyObject.self), forKeyedSubscript: "log")
    console.setObject(unsafeBitCast(log, AnyObject.self), forKeyedSubscript: "info")
    console.setObject(unsafeBitCast(log, AnyObject.self), forKeyedSubscript: "debug")
    console.setObject(unsafeBitCast(log, AnyObject.self), forKeyedSubscript: "error")
#endif

  }

  func appController(appController: TVApplicationController, didFinishLaunchingWithOptions options: [String : AnyObject]?) {
    self.delegate?.spotXAdDidStart(self)
  }

  func appController(appController: TVApplicationController, didStopWithOptions options: [String : AnyObject]?) {
    self.delegate?.spotXAdDidFinish(self)
  }

  func appController(appController: TVApplicationController, didFailWithError error: NSError) {
    self.delegate?.spotXAdDidFail(self, error)
  }

}
