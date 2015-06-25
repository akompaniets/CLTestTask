//
//  AKFriendCell.h
//  CLTestTask
//
//  Created by Mobindustry on 6/25/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKUserCell.h"

@class AKFriend;
@interface AKFriendCell : AKUserCell

- (void)configureCellForFriend:(AKFriend *)friend;

@end
