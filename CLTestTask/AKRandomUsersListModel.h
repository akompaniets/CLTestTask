//
//  AKRandomUsersListModel.h
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AKRandomUsersListModelDelegate;

@interface AKRandomUsersListModel : NSObject

@property (weak, nonatomic) id<AKRandomUsersListModelDelegate>delegate;

+ (instancetype)sharedModel;
- (void)fetchNewUserListWithCallback:(void(^)(NSArray *newUsers, NSError *error))callback;
- (void)saveSelectedUsers:(NSArray *)selectedUsers withCompletionHandler:(void(^)())completionHandler;

@end

@protocol AKRandomUsersListModelDelegate <NSObject>

@optional
- (void)modelDidFinishHandling:(AKRandomUsersListModel *)model;

@end
