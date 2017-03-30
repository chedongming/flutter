// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "AppDelegate.h"

#import <Flutter/Flutter.h>

@implementation AppDelegate
- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  FlutterViewController* controller =
      (FlutterViewController*)self.window.rootViewController;
  FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
      methodChannelWithName:@"battery"
            binaryMessenger:controller];
  [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call,
                                         FlutterResultReceiver result) {
    if ([@"getBatteryLevel" isEqualToString:call.method]) {
      UIDevice* device = UIDevice.currentDevice;
      device.batteryMonitoringEnabled = YES;
      if (device.batteryState == UIDeviceBatteryStateUnknown) {
        result([FlutterError errorWithCode:@"UNAVAILABLE"
                                   message:@"Battery info unavailable"
                                   details:nil]);
      } else {
        result(@((int)(device.batteryLevel * 100)));
      }
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];
  return YES;
}
@end