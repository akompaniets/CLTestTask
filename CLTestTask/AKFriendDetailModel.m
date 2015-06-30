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

@implementation AKFriendDetailModel

- (void)commitChangesForFriend:(AKFriend *)friend {
    [[AKDatabaseManager sharedManager] updateChangesForFriend:friend];
}

- (UIImage *)fetchImageForFilePath:(NSString *)path {
    NSData *imageData = [AKStorageManager loadImageDataForFileName:path];
    UIImage *image = [UIImage imageWithData:imageData];
    
    return image;
}

@end
