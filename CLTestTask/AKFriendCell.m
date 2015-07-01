//
//  AKFriendCell.m
//  CLTestTask
//
//  Created by Mobindustry on 6/25/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKFriendCell.h"
#import "AKFriend.h"
#import "AKStorageManager.h"

@implementation AKFriendCell

//@synthesize imageCache = _imageCache;

- (void)configureCellForFriend:(AKFriend *)friend {

    self.userName.text = [NSString stringWithFormat:@"%@.%@ %@", friend.title, friend.firstName, friend.lastName];
    self.userName.font = CustomFont;
    if (![self.imageCache objectForKey:friend.sha256]) {
        self.userImage.image = [UIImage imageNamed:@"didntLoad"];
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imagedata = [AKStorageManager loadImageDataForFileName:friend.thumbnailName];
        UIImage *image = [UIImage imageWithData:imagedata];
        
        if (image) {
            [weakSelf.imageCache setObject:image forKey:friend.sha256];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.userImage.image = image;
            });
        }
    });
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (NSCache *)imageCache {

    return [super imageCache];
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

@end
