//
//  Copyright © 2015 SpotX, Inc. All rights reserved.
//


// NOTE: Subject to change after prerelease development
var SPOTX_SDK = 'https://m.spotx.ninja/tvos/v1/sdk.js';

var BASE_URL = '';

App.onLaunch = function(options) {
  var resources = [
    SPOTX_SDK,
    `${options.BASE_URL}/Demo.xml.js`
  ];

  evaluateScripts(resources, function() {
    menu();
  });
};


function menu() {
  var parser = new DOMParser();
  var alert = parser.parseFromString(Demo, 'application/xml');
  var channelId = alert.getElementById('channelId');
  var button = alert.getElementById('play');
  button.addEventListener('select', function() {
    loadAd(channelId.textContent);
  });
  navigationDocument.pushDocument(alert);
}


function loadAd(channelId) {
  var AD_EVENTS = ['loaded', 'started', 'complete', 'error'];

  var ad = new SpotX.Ad(channelId);
  ad.useHTTPS = false;
  ad.autoplay = true;
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