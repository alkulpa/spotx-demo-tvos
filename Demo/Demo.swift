//
//  Copyright © 2015 SpotX, Inc. All rights reserved.
//

import UIKit

class Demo: UIViewController, SpotXAdDelegate {

  @IBOutlet weak var channelID : UITextField!

  var ad: SpotXAd?

  @IBAction func playAd(sender: AnyObject) {
    if let channelId = self.channelID.text {
      ad = SpotXAd(channelId: channelId, delegate: self)
      ad?.show(self, animated: true)
    }
  }

  // MARK: - SpotXAdDelegate

  func spotXAdDidStart(_: SpotXAd) {
    NSLog("SpotX Ad Started")
  }

  func spotXAdDidFinish(_: SpotXAd) {
    NSLog("SpotX Ad Finished")
    self.dismissViewControllerAnimated(false, completion: nil)
    ad = nil
  }

  func spotXAdDidFail(_: SpotXAd, _ error: NSError) {
    NSLog("SpotX Ad Failed: \(error.localizedDescription)")
    self.dismissViewControllerAnimated(false, completion: nil)
    ad = nil
  }

}
