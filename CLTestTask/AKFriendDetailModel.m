//
//  AKUserDetailModel.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKFriendDetailModel.h"
#import "AKDatabaseManager.h"
#import "AKStorageManager.h"
#import "AKNetworkManager.h"
#import "AKFriend.h"

@implementation AKFriendDetailModel

- (void)commitChangesForFriend:(AKFriend *)friend {
    [[AKDatabaseManager sharedManager] updateChangesForFriend:friend];
}

- (UIImage *)loadImageWithFileName:(NSString *)filename {
    NSData *imageData = [AKStorageManager loadImageDataForFileName:filename];
    UIImage *image = [UIImage imageWithData:imageData];
    
    return image ? image : nil;
}

- (void)reloadPhotoForFriend:(AKFriend *)friend withCompletionHandler:(void(^)(UIImage *image))completionHandler {
    
    NSOperationQueue *updateFriendQueue = [[NSOperationQueue alloc] init];
    updateFriendQueue.name = @"DownloadPhoto Queue";
    updateFriendQueue.maxConcurrentOperationCount = 1;
    if ([[AKNetworkManager sharedManager] reachability].isReachable) {
        [updateFriendQueue addOperationWithBlock:^{
            NSData *photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:friend.photoURL]];
            NSData *thumbnailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:friend.thumbnailURL]];
            UIImage *photo = [UIImage imageWithData:photoData];
            AKFriend *updatedFriend = friend;
            NSString *photoName = [NSString stringWithFormat:@"photo_%@", friend.sha256];
            NSString *thumbnailName = [NSString stringWithFormat:@"thumbnail_%@", friend.sha256];
            
            [AKStorageManager saveImageData:photoData withName:photoName];
            [AKStorageManager saveImageData:thumbnailData withName:thumbnailName];
            
            updatedFriend.photoName = photoName;
            updatedFriend.thumbnailName = thumbnailName;
            
            [[AKDatabaseManager sharedManager] updateChangesForFriend:updatedFriend];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(photo);
            });
        }];
    } else {
        completionHandler(nil);
    }
}


@end
