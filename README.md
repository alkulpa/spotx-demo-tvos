SpotX tvOS Integration
=========================

Monetize your tvOS app with SpotX!

## Prerequisites

  * Xcode 7.1 beta (pre-release)
  * SpotX publisher account
  	* [Apply to become a SpotX Publisher](http://www.spotxchange.com/publishers/apply-to-become-a-spotx-publisher/)


## Presenting an Ad in a Native App

  1. Include SpotXAd.swift in your project. Don't worry, there are no additional dependencies.
  2. Instantiate a SpotXAd instance with your publisher channel ID and any additional parameters you wish to collect.
  3. Attach an implementation of the SpotXAdDelegate protocol, if you are interested in Ad lifecycle events.
  4. Present the Ad by calling SpotXAd.show().
 
 
```swift
static let CHANNEL_ID = "85394"
  
func playAd() {
	self.ad = SpotXAd(channelId: channelId, delegate: self)
	self.ad?.show(self, animated: true)
}
```


## Presenting an Ad in a TVML App

  1. Load the SpotX SDK. Don't worry, there are no additional dependencies.
  2. Instantiate a SpotX.Ad instance with your publisher channel ID.
  3. Add any additional parameters you wish to collect.
  4. Add event listeners, if you are interested in Ad lifecycle events.
  4. Present the Ad by calling SpotXAd.startLoading().
 
 
```javascript
// NOTE: Subject to change after prerelease development
var SPOTX_SDK = 'https://m.spotx.ninja/tvos/v1/sdk.js';

var CHANNEL_ID = "85394"

App.onLaunch = function(options) {
  evaluateScripts([SPOTX_SDK], function() {
    playAd();
  });
};

function playAd() {
  var AD_EVENTS = ['loaded', 'started', 'complete', 'error'];

  var ad = new SpotX.Ad(CHANNEL_ID);
  ad.params = {
    custom_1: 'custom-param'
  };

  AD_EVENTS.forEach(function(event) {
    ad.addEventListener(event, function() {
      console.log('Received event: ' + event);
    });
  });

  ad.startLoading();
}
```