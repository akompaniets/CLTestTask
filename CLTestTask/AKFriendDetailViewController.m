//
//  AKUserDetailViewController.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKFriendDetailViewController.h"
#import "AKFriend.h"
#import "AKFriendDetailModel.h"
#import "AKStorageManager.h"

static CGFloat keyboardHeight = 253.0;
static CGFloat defaultConstraintConstant = 25.0;

@interface AKFriendDetailViewController () <UITextFieldDelegate>

@property (strong, nonatomic) AKFriendDetailModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacingConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic)UIBarButtonItem *doneButton;

@property (strong, nonatomic) NSString *tempUserName;
@property (strong, nonatomic) NSString *tempEmail;
@property (strong, nonatomic) NSString *tempPhone;

@end

@implementation AKFriendDetailViewController
{
    CGFloat screenHeight;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    screenHeight = self.view.frame.size.height;
    self.userPhoto.image = [self.model loadImageWithFileName:self.friend.photoName];
    self.userNameField.text = [NSString stringWithFormat:@"%@.%@ %@", self.friend.title, self.friend.firstName, self.friend.lastName];
    self.emailField.text = self.friend.email;
    self.phoneField.text = self.friend.phone;
    
    [self addTargetForTextField:self.userNameField];
    [self addTargetForTextField:self.emailField];
    [self addTargetForTextField:self.phoneField];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(cancelChanges:)];
    self.navigationItem.leftBarButtonItem = cancelButton;

    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                    target:self
                                                                    action:@selector(saveUserChanging:)];
    UIFont *doneButtonFont = [UIFont systemFontOfSize:18.0];
    [self.doneButton setTitleTextAttributes:@{NSFontAttributeName : doneButtonFont,
                                              NSForegroundColorAttributeName : NormalButtonColor}
                                   forState:UIControlStateNormal];
    [self.doneButton setTitleTextAttributes:@{NSFontAttributeName : doneButtonFont,
                                              NSForegroundColorAttributeName : DisabledButtonColor}
                                   forState:UIControlStateDisabled];
    [self.doneButton setTitleTextAttributes:@{NSFontAttributeName : doneButtonFont,
                                              NSForegroundColorAttributeName : HighlightedButtonColor}
                                   forState:UIControlStateHighlighted];
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
    self.doneButton.enabled = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Actions

- (void)saveUserChanging:(UIBarButtonItem *)sender {
    NSArray *tempComponents = [self.tempUserName componentsSeparatedByString:@"."];
    NSString *separetedString = [tempComponents lastObject];
    NSArray *components = [separetedString componentsSeparatedByString:@" "];
    if (self.tempUserName) {
        self.friend.title = [tempComponents firstObject];
        self.friend.firstName = [components firstObject];
        self.friend.lastName = [components lastObject];
    }
    if (self.tempEmail) {
        self.friend.email = self.friend.email;
    }
    if (self.tempPhone) {
        self.friend.phone = self.tempPhone;
    }
    [self.model commitChangesForFriend:self.friend];
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)cancelChanges:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addTargetForTextField:(UITextField *)textField
{
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)hideKeyboard {
    [self.userNameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    self.verticalSpacingConstraint.constant = defaultConstraintConstant;
    [self animateConstraint];
}

- (void)animateConstraint {
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    self.doneButton.enabled = YES;
    switch (textField.tag)
    {
        case 100:
            self.tempUserName = textField.text;
            break;
        case 101:
            self.tempEmail = textField.text;
            break;
        case 102:
            self.tempPhone = textField.text;
            break;
            
        default:
            break;
    }
}


#pragma mark - Getters

- (AKFriendDetailModel *)model {
    if (!_model) {
        _model = [AKFriendDetailModel new];
    }
    return _model;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat keyboardPosition = screenHeight - keyboardHeight;
    CGFloat textFieldPosition = textField.frame.origin.y;
    CGFloat delta = textFieldPosition - keyboardPosition;
    if (delta > 0.0) {
        CGFloat constrintValue = delta + 35.0;
        self.verticalSpacingConstraint.constant -= constrintValue;
        [self animateConstraint];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag != 102) {
        UIResponder* nextResponder = [textField.superview viewWithTag:(textField.tag + 1)];
        if (nextResponder) {
            [nextResponder becomeFirstResponder];
        }
    } else {
        if (screenHeight <= 568.0) {
            self.verticalSpacingConstraint.constant = defaultConstraintConstant;
            [self animateConstraint];
        }
        [textField resignFirstResponder];
    }
    
    return YES;
}

@end
