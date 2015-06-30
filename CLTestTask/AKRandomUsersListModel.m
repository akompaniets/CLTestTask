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

@interface AKRandomUsersListModel() <AKDownloadOperationDelegate>

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
        callback(users, error);
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

- (void)saveSelectedUsers:(NSArray *)selectedUsers withCompletionHandler:(void(^)(NSError *error))completionHandler {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkStatusDidChange:)
                                                 name:AKNetworkManagerReachabilityStatusDidChangeNotification
                                               object:nil];
    for (AKUser *user in selectedUsers) {
       
        [self.downloadQueue addOperationWithBlock:^{
            NSData *photo = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.photoUrl]];
            NSData *thumbnail = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.thumbnailUrl]];

            NSString *photoName = [NSString stringWithFormat:@"photo_%@", user.sha256];
            NSString *thumbnailName = [NSString stringWithFormat:@"thumbnail_%@", user.sha256];
            
            [AKStorageManager saveImageData:photo withName:photoName];
            [AKStorageManager saveImageData:thumbnail withName:thumbnailName];
            
            user.photoUrl = photoName;
            user.thumbnailUrl = thumbnailName;
            [[AKDatabaseManager sharedManager] saveUsers:@[user]
                                   withCompletionHandler:^(NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
//                                           completionHandler(error);
                                       });
                                       
                                   }];
//            [weakSelf.processedUsers addObject:user];
        }];
    }
//    [self.downloadQueue waitUntilAllOperationsAreFinished];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil);
        });

    
    weakSelf.processedUsers = nil;
    });
}

#pragma mark - AKDownloadOperationDelegate

- (void)downloadOperationDidFinish:(AKDownloadOperation *)operation {
    NSLog(@"Operation did finish: %@", operation);
//    NSLog(@"Photo data: %@", operation.photoData);
}

#pragma mark - dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:AKNetworkManagerReachabilityStatusDidChangeNotification];
}
@end
