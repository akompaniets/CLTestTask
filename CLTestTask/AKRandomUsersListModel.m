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
#import "AKDownloadOperation.h"

@implementation AKRandomUsersListModel

- (void)fetchNewUserListWithCallback:(void(^)(NSArray *newUsers, NSError *error))callback {
    AKNetworkManager *manager = [AKNetworkManager sharedManager];
    
    [manager fetchRandomUsersWithCallback:^(id usersData, NSError *error) {
        NSArray *tempUsersArray = [usersData objectForKey:@"results"];
        NSMutableArray *users = [NSMutableArray array];
        for (NSDictionary *currentUser in tempUsersArray) {
            FEMObjectMapping *userMapping = [AKMappingProvider userMapping];
            AKUser *user = [FEMObjectDeserializer deserializeObjectExternalRepresentation:currentUser usingMapping:userMapping];
            [users addObject:user];
        }
        callback(users, error);
    }];
    
}

- (BOOL)saveSelectedUsers:(NSArray *)selectedUsers {
    
   
    return YES;
}

- (void)networkStatusDidChange:(NSNotification *)notification {
    
}

- (void)saveSelectedUsers:(NSArray *)selectedUsers withCompletionHandler:(void(^)(NSError *error))completionHandler {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(networkStatusDidChange:)
//                                                 name:AKNetworkManagerReachabilityStatusDidChangeNotification
//                                               object:nil];
    
    NSOperationQueue *downloadQueue = [[NSOperationQueue alloc] init];
    downloadQueue.name = @"Download Queue";
    for (AKUser *user in selectedUsers) {
        
    }

    [[AKDatabaseManager sharedManager] saveUsers:selectedUsers
                           withCompletionHandler:^(NSError *error) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   completionHandler(error);
                               });
                               
                           }];
    

}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:AKNetworkManagerReachabilityStatusDidChangeNotification];
}
@end
