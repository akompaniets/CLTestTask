//
//  AKAlertView.m
//  CLTestTask
//
//  Created by Mobindustry on 6/23/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKAlertView.h"


@implementation AKAlertView

+ (void)showAlertwithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

@end
