//
//  AKUsersListModel.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKFriendsListModel.h"
#import "AKFriend.h"
#import "AKDatabaseManager.h"

@interface AKFriendsListModel()

@end

@implementation AKFriendsListModel

- (void)deleteFriend:(AKFriend *)friend {
    [[AKDatabaseManager sharedManager] markFriendAsNonFriend:friend];
}

@end
