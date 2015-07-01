//
//  AKPopupPresentationViewController.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKPopupPresentationViewController.h"

static CGFloat animationDuration = 0.3f;

@interface AKPopupPresentationViewController ()

@property (strong, nonatomic) UIViewController *popupViewController;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSLayoutConstraint *verticalPosConstraint;

@end

@implementation AKPopupPresentationViewController

- (void)showPopupViewController:(UIViewController *)viewController {
    
    self.popupViewController = viewController;
    self.popupViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.popupViewController];
    [self.view addSubview:self.popupViewController.view];
     self.height = self.view.bounds.size.height;
    NSDictionary *viewsDict = @{@"controller" : self.popupViewController.view};
    NSDictionary *metrics = @{@"width" : @(self.view.bounds.size.width),
                              @"heigth" : @(self.height)};
   
    NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[controller(width)]" options:0 metrics:metrics views:viewsDict];
    NSArray *constraintsW = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[controller(heigth)]" options:0 metrics:metrics views:viewsDict];
    NSLayoutConstraint *constraintPOSH = [NSLayoutConstraint constraintWithItem:self.popupViewController.view
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1
                                                                       constant:0];
    self.verticalPosConstraint = [NSLayoutConstraint constraintWithItem:self.popupViewController.view
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:-self.height];
    [self.view addConstraints:constraintsH];
    [self.view addConstraints:constraintsW];
    [self.view addConstraint:constraintPOSH];
    [self.view addConstraint:self.verticalPosConstraint];
    [self.view layoutIfNeeded];
    
    self.verticalPosConstraint.constant = 0;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hidePopupViewController {
    self.verticalPosConstraint.constant = -self.height;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.popupViewController.view removeFromSuperview];
        [self.popupViewController removeFromParentViewController];
        self.popupViewController = nil;
        self.verticalPosConstraint = nil;
    }];
}

@end
