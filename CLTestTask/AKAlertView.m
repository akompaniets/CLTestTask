//
//  AKAlertView.m
//  CLTestTask
//
//  Created by Mobindustry on 6/23/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKAlertView.h"

@interface AKAlertView()

@property (strong, nonatomic) NSLayoutConstraint *alertViewVerticalConstraint;

@end


@implementation AKAlertView

+ (void)showAlertwithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

+ (void)showAlertInView:(UIView *)view withTitle:(NSString *)title message:(NSString *)message severity:(AKAlertViewSeverity)severity {
    
    AKAlertView *alertView = [[AKAlertView alloc] init];
    alertView.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    UIButton *cancelButton = [[UIButton alloc] init];
    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDict = @{@"alertView" : alertView,
                                @"titleLabel" : titleLabel,
                                @"messageLabel" : messageLabel,
                                @"cancelButton" : cancelButton};
    NSDictionary *metrics = @{@"alertViewhorizontalSpacing" : @(40),
                              @"titleLabelHorizontalSpacing" : @(10),
                              @"subViewHeight" : @(30),
                              @"alertViewHeight" : @(150)};
    
    [view addSubview:alertView];
    [alertView addSubview:titleLabel];
    [alertView addSubview:messageLabel];
    [alertView addSubview:cancelButton];
    CGFloat verticalPos = view.frame.size.height/2;
    NSArray *alertViewWidht = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-alertViewhorizontalSpacing-[alertView]-alertViewhorizontalSpacing-|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:viewsDict];
    NSArray *alertViewHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[alertView(alertViewHeight)]"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:viewsDict];
    alertView.alertViewVerticalConstraint = [NSLayoutConstraint constraintWithItem:alertView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:view
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1
                                                                          constant:-verticalPos];
    [view addConstraints:alertViewWidht];
    [view addConstraints:alertViewHeight];
    [view addConstraint:alertView.alertViewVerticalConstraint];

    NSArray *titleLabelWigth = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelHorizontalSpacing-[titleLabel]-titleLabelHorizontalSpacing-|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:viewsDict];
    NSArray *titleLabelVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-titleLabelHorizontalSpacing-[titleLabel(subViewHeight)]"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:viewsDict];
    [alertView addConstraints:titleLabelWigth];
    [alertView addConstraints:titleLabelVertical];
    
    NSLayoutConstraint *cancelButtonLeading = [NSLayoutConstraint constraintWithItem:cancelButton
                                                                           attribute:NSLayoutAttributeLeading
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:titleLabel
                                                                           attribute:NSLayoutAttributeLeading
                                                                          multiplier:1
                                                                            constant:0];
    
    NSLayoutConstraint *cancelButtonTrailing = [NSLayoutConstraint constraintWithItem:cancelButton
                                                                            attribute:NSLayoutAttributeTrailing
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:titleLabel
                                                                            attribute:NSLayoutAttributeTrailing
                                                                           multiplier:1
                                                                             constant:0];
    NSArray *cancelButtonVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelButton(subViewHeight)]-titleLabelHorizontalSpacing-|"
                                                                            options:0
                                                                            metrics:metrics
                                                                              views:viewsDict];
    
    [alertView addConstraint:cancelButtonLeading];
    [alertView addConstraint:cancelButtonTrailing];
    [alertView addConstraints:cancelButtonVertical];
    
    
    
    
    NSLayoutConstraint *messageLabelLeading = [NSLayoutConstraint constraintWithItem:messageLabel
                                                                           attribute:NSLayoutAttributeLeading
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:titleLabel
                                                                           attribute:NSLayoutAttributeLeading
                                                                          multiplier:1
                                                                            constant:0];
    
    NSLayoutConstraint *messageLabelTrailing = [NSLayoutConstraint constraintWithItem:messageLabel
                                                                            attribute:NSLayoutAttributeTrailing
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:titleLabel
                                                                            attribute:NSLayoutAttributeTrailing
                                                                           multiplier:1
                                                                             constant:0];
    NSArray *messageLabelVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-titleLabelHorizontalSpacing-[messageLabel]-titleLabelHorizontalSpacing-[cancelButton]"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:viewsDict];
    
    [alertView addConstraint:messageLabelLeading];
    [alertView addConstraint:messageLabelTrailing];
    [alertView addConstraints:messageLabelVertical];
    
    
    [view layoutIfNeeded];
    
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    messageLabel.text = message;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 4;
    messageLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [cancelButton setTitle:@"OK" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

  
    
    alertView.layer.cornerRadius = 5.0f;
   
    switch (severity) {
        case AKAlertViewSeverityError: {
            alertView.backgroundColor = ErrorColor;
        }
            break;
            
        case AKAlertViewSeverityWarning: {
            alertView.backgroundColor = WarningColor;
        }
            break;
            
        case AKAlertViewSeveritySuccess: {
            alertView.backgroundColor = SuccessColor;
        }
            break;
            
        default:
            break;
    }
    
    alertView.alertViewVerticalConstraint.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [view layoutIfNeeded];
    }];
    

    
}

@end
