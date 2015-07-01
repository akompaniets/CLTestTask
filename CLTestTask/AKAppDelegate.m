//
//  AppDelegate.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKAppDelegate.h"
#import "AKStorageManager.h"

@implementation AKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

+ (instancetype)sharedDelegate {
    return [UIApplication sharedApplication].delegate;
}

@end
