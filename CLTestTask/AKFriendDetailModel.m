//
//  AKUserDetailModel.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKFriendDetailModel.h"
#import "AKDatabaseManager.h"

@implementation AKFriendDetailModel

- (void)commitChangesForFriend:(AKFriend *)friend {
    [[AKDatabaseManager sharedManager] updateChangesForFriend:friend];
}

@end
