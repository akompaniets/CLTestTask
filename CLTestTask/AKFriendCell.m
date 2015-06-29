//
//  AKFriendCell.m
//  CLTestTask
//
//  Created by Mobindustry on 6/25/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKFriendCell.h"
#import "AKFriend.h"

@implementation AKFriendCell

- (void)configureCellForFriend:(AKFriend *)friend {
    
    self.userName.text = [NSString stringWithFormat:@"%@.%@ %@", friend.title, friend.firstName, friend.lastName];
    self.userName.font = CustomFont;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

@end
