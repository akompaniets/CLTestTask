//
//  AppDelegate.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKAppDelegate.h"

@interface AKAppDelegate ()

@end

@implementation AKAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [self setupAppearance];
    return YES;
}

+ (instancetype)sharedDelegate {
    return [UIApplication sharedApplication].delegate;
}

- (void)setupAppearance
{
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
//    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
//                                                           CUSTOM_FONT, NSFontAttributeName, nil]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
}

@end
