//
//  AKRandomUsersListModel.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKRandomUsersListModel.h"
#import "AKNetworkManager.h"

@implementation AKRandomUsersListModel

- (void)fetchNewUserListWithCallback:(void(^)(id response, NSError *error))callback {
    AKNetworkManager *manager = [AKNetworkManager new];
    
    [manager fetchRandomUsersWithCallback:^(id usersData, NSError *error) {
        callback(usersData, error);
    }];
    
}

@end
