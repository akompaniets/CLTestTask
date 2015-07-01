//
//  AKDatabaseManager.h
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AKFriend;
@interface AKDatabaseManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *backgroundContext;

+ (instancetype)sharedManager;
- (void)saveUsers:(NSArray *)users withCompletionHandler:(void(^)(NSError *error))completionHandler;
- (void)markFriendAsNonFriend:(AKFriend *)friend;
- (void)updateChangesForFriend:(AKFriend *)friend;

@end
