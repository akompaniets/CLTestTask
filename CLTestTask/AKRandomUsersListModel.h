//
//  AKRandomUsersListModel.h
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKRandomUsersListModel : NSObject

+ (instancetype)sharedModel;
- (void)fetchNewUserListWithCallback:(void(^)(NSArray *newUsers, NSError *error))callback;
- (void)saveSelectedUsers:(NSArray *)selectedUsers withCompletionHandler:(void(^)())completionHandler;

@end
