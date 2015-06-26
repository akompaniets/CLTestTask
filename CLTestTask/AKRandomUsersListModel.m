//
//  AKRandomUsersListModel.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKRandomUsersListModel.h"
#import "AKNetworkManager.h"
#import "AKDatabaseManager.h"
#import "AKMappingProvider.h"
#import "AKUser.h"
#import <FEMObjectDeserializer.h>

@implementation AKRandomUsersListModel

- (void)fetchNewUserListWithCallback:(void(^)(NSArray *newUsers, NSError *error))callback {
    AKNetworkManager *manager = [AKNetworkManager new];
    
    [manager fetchRandomUsersWithCallback:^(id usersData, NSError *error) {
        NSArray *tempUsersArray = [usersData objectForKey:@"results"];
        NSMutableArray *users = [NSMutableArray array];
        for (NSDictionary *currentUser in tempUsersArray) {
            AKUser *user = [FEMObjectDeserializer deserializeObjectExternalRepresentation:currentUser usingMapping:[AKMappingProvider userMapping]];
            [users addObject:user];
        }
        callback(users, error);
    }];
    
}

- (BOOL)saveSelectedUsers:(NSArray *)selectedUsers {
    

    __block BOOL retValue;
    [[AKDatabaseManager sharedManager] saveUsers:selectedUsers
                           withCompletionHandler:^(NSError *error) {
                               if (error) {
                                   retValue = NO;
                               } else {
                                   retValue = YES;
                               }
                           }];
    return retValue;
    
}

- (void)saveSelectedUsers:(NSArray *)selectedUsers withCompletionHandler:(void(^)(NSError *error))completionHandler {
    
}



@end
