//
//  AKAlertView.h
//  CLTestTask
//
//  Created by Mobindustry on 6/23/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AKAlertView : UIView

+ (void)showAlertwithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate;
+ (void)showAlertInView:(UIView *)view withTitle:(NSString *)title message:(NSString *)message severity:(AKAlertViewSeverity)severity;
@end
