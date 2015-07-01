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
#import "AKStorageManager.h"

@interface AKRandomUsersListModel() 

@property (strong, nonatomic) NSOperationQueue *downloadQueue;
@property (copy, nonatomic) NSMutableArray *processedUsers;

@end

@implementation AKRandomUsersListModel

+ (instancetype)sharedModel {
    static AKRandomUsersListModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [AKRandomUsersListModel new];
    });
    return model;
}

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
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(users, error);
        });
    }];
}

- (NSMutableArray *)processedUsers {
    if (!_processedUsers) {
        _processedUsers = [NSMutableArray array];
    }
    return _processedUsers;
}

- (NSOperationQueue *)downloadQueue {
    if (!_downloadQueue) {
        _downloadQueue = [NSOperationQueue new];
        _downloadQueue.name = @"Download Queue";
        _downloadQueue.maxConcurrentOperationCount = 1;
    }
    return _downloadQueue;
}

- (void)networkStatusDidChange:(NSNotification *)notification {
    NSInteger status = [[[notification object] objectForKey:@"status"] integerValue];
    if (status == 0) {
        if (!self.downloadQueue.isSuspended) {
            [self.downloadQueue setSuspended:YES];
            NSLog(@"Download queue on pause.");
        }
    } else {
        [self.downloadQueue setSuspended:NO];
        NSLog(@"Download queue on resume.");
    }
}

- (void)saveSelectedUsers:(NSArray *)selectedUsers withCompletionHandler:(void(^)())completionHandler {

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(networkStatusDidChange:)
                                                     name:AKNetworkManagerReachabilityStatusDidChangeNotification
                                                   object:nil];
        for (AKUser *user in selectedUsers) {
            AKDownloadOperation *operation = [[AKDownloadOperation alloc] initWithUser:user];
            operation.name = user.sha256;
            [self.downloadQueue addOperation:operation];
        }
        
        [self.downloadQueue addObserver:self forKeyPath:@"operations" options:0 context:NULL];

    });
    [[NSNotificationCenter defaultCenter] postNotificationName:AKRandomUsersListModelDidChangeUserHandlingStatusNotification
                                                        object:@{@"status" : @(DidStartUserHandling)}];
    completionHandler();
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (object == self.downloadQueue && [keyPath isEqualToString:@"operations"]) {
        if ([self.downloadQueue.operations count] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:AKRandomUsersListModelDidChangeUserHandlingStatusNotification
                                                                object:@{@"status" : @(DidFinishUserHandling)}];
#if DEBUG
                NSLog(@"queue has completed");
#endif
            });
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:AKNetworkManagerReachabilityStatusDidChangeNotification];
}
@end
