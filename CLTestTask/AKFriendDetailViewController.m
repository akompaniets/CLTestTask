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

@property (strong, nonatomic) NSString *tempUserName;
@property (strong, nonatomic) NSString *tempEmail;
@property (strong, nonatomic) NSString *tempPhone;

@end

@implementation AKFriendDetailViewController
{
//    CGFloat keyboargHeght;
    CGFloat screenHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    screenHeight = self.view.frame.size.height;
    self.userPhoto.image = [self.model fetchImageForFilePath:self.friend.photoPath];
    self.userNameField.text = [NSString stringWithFormat:@"%@.%@ %@", self.friend.title, self.friend.firstName, self.friend.lastName];
    self.emailField.text = self.friend.email;
    self.phoneField.text = self.friend.phone;
    
    [self addTargetForTextField:self.userNameField];
    [self addTargetForTextField:self.emailField];
    [self addTargetForTextField:self.phoneField];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];
    UIFont *buttomFont = [UIFont systemFontOfSize:17.0];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 60.0f, 30.0f)];
    [backButton setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    backButton.titleLabel.font = buttomFont;
    [backButton setTitleColor:NormalButtonColor forState:UIControlStateNormal];
    [backButton setTitleColor:HighlightedButtonColor forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(cancelChanges:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 60.0f, 30.0f)];
    [doneButton setTitle:NSLocalizedString(@"done", nil) forState:UIControlStateNormal];
    doneButton.titleLabel.font = buttomFont;
    [doneButton setTitleColor:NormalButtonColor forState:UIControlStateNormal];
    [doneButton setTitleColor:HighlightedButtonColor forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(saveUserChanging:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = doneButtonItem;

}

- (void)saveUserChanging:(UIBarButtonItem *)sender {
    NSArray *temp = [self.tempUserName componentsSeparatedByString:@"."];
    NSString *separetesString = [temp lastObject];
    NSArray *temp2 = [separetesString componentsSeparatedByString:@" "];
    if (self.tempUserName) {
        self.friend.title = [temp firstObject];
        self.friend.firstName = [temp2 firstObject];
        self.friend.lastName = [temp2 lastObject];
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

- (AKFriendDetailModel *)model {
    if (!_model) {
        _model = [AKFriendDetailModel new];
    }
    return _model;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)animateConstraint {
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void) textFieldDidChange:(UITextField *)textField {
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
