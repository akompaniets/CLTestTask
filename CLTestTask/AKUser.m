//
//  AKUser.m
//  CLTestTask
//
//  Created by Mobindustry on 6/25/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKUser.h"

@implementation AKUser

- (void)setTitle:(NSString *)title {
    _title = [title capitalizedString];
}

- (void)setFirstName:(NSString *)firstName {
    _firstName = [firstName capitalizedString];
}

- (void)setLastName:(NSString *)lastName {
    _lastName = [lastName capitalizedString];
}

@end
