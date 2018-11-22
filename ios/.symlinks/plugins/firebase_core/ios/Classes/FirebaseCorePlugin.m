// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FirebaseCorePlugin.h"

#import <Firebase/Firebase.h>

@interface FIROptions (FLTFirebaseCorePlugin)
@property(readonly, nonatomic) NSDictionary *dictionary;
@end

@implementation FIROptions (FLTFirebaseCorePlugin)
- (NSDictionary *)flutterDictionary {
  return @{
    @"googleAppID" : self.googleAppID ?: [NSNull null],
    @"bundleID" : self.bundleID ?: [NSNull null],
    @"GCMSenderID" : self.GCMSenderID ?: [NSNull null],
    @"APIKey" : self.APIKey ?: [NSNull null],
    @"clientID" : self.clientID ?: [NSNull null],
    @"trackingID" : self.trackingID ?: [NSNull null],
    @"projectID" : self.projectID ?: [NSNull null],
    @"androidClientID" : self.androidClientID ?: [NSNull null],
    @"databaseUrl" : self.databaseURL ?: [NSNull null],
    @"storageBucket" : self.storageBucket ?: [NSNull null],
    @"deepLinkURLScheme" : self.deepLinkURLScheme ?: [NSNull null],
  };
}
@end

@implementation FIRApp (FLTFirebaseCorePlugin)
- (NSDictionary *)flutterDictionary {
  return @{
    @"name" : self.name,
    @"options" : self.options.flutterDictionary,
  };
}
@end

@implementation FLTFirebaseCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"plugins.flutter.io/firebase_core"
                                  binaryMessenger:[registrar messenger]];
  FLTFirebaseCorePlugin *instance = [[FLTFirebaseCorePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if ([@"FirebaseApp#configure" isEqualToString:call.method]) {
    NSString *name = call.arguments[@"name"];
    NSDictionary *optionsDictionary = call.arguments[@"options"];
    FIROptions *options =
        [[FIROptions alloc] initWithGoogleAppID:optionsDictionary[@"googleAppID"]
                                    GCMSenderID:optionsDictionary[@"GCMSenderID"]];
    if (![optionsDictionary[@"bundleID"] isEqual:[NSNull null]])
      options.bundleID = optionsDictionary[@"bundleID"];
    if (![optionsDictionary[@"APIKey"] isEqual:[NSNull null]])
      options.APIKey = optionsDictionary[@"APIKey"];
    if (![optionsDictionary[@"clientID"] isEqual:[NSNull null]])
      options.clientID = optionsDictionary[@"clientID"];
    if (![optionsDictionary[@"trackingID"] isEqual:[NSNull null]])
      options.trackingID = optionsDictionary[@"trackingID"];
    if (![optionsDictionary[@"projectID"] isEqual:[NSNull null]])
      options.projectID = optionsDictionary[@"projectID"];
    if (![optionsDictionary[@"androidClientID"] isEqual:[NSNull null]])
      options.androidClientID = optionsDictionary[@"androidClientID"];
    if (![optionsDictionary[@"databaseURL"] isEqual:[NSNull null]])
      options.databaseURL = optionsDictionary[@"databaseURL"];
    if (![optionsDictionary[@"storageBucket"] isEqual:[NSNull null]])
      options.storageBucket = optionsDictionary[@"storageBucket"];
    if (![optionsDictionary[@"deepLinkURLScheme"] isEqual:[NSNull null]])
      options.deepLinkURLScheme = optionsDictionary[@"deepLinkURLScheme"];
    [FIRApp configureWithName:name options:options];
    result(nil);
  } else if ([@"FirebaseApp#allApps" isEqualToString:call.method]) {
    NSDictionary<NSString *, FIRApp *> *allApps = [FIRApp allApps];
    NSMutableArray *appsList = [NSMutableArray array];
    for (NSString *name in allApps) {
      FIRApp *app = allApps[name];
      [appsList addObject:app.flutterDictionary];
    }
    result(appsList.count > 0 ? appsList : nil);
  } else if ([@"FirebaseApp#appNamed" isEqualToString:call.method]) {
    NSString *name = call.arguments;
    FIRApp *app = [FIRApp appNamed:name];
    result(app.flutterDictionary);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
