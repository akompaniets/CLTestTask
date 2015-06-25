//
//  AKUserCell.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKUserCell.h"
#import "AKUser.h"

@interface AKUserCell()

@property (strong, nonatomic) NSCache *imageCache;

@end

@implementation AKUserCell

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

-(NSCache *)imageCache {
    if (!_imageCache) {
        _imageCache = [NSCache new];
    }
    return _imageCache;
}

- (void)configureCellAtIndexPath:(NSIndexPath *)indexPath forUser:(AKUser *)user {
    self.userName.text = [NSString stringWithFormat:@"%@.%@ %@", user.title, user.firstName, user.lastName];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *imageKey = [NSString stringWithFormat:@"cell%ld", indexPath.row];
    UIImage *cachedImage = [self.imageCache objectForKey:imageKey];
    if (cachedImage) {
        self.userImage.image = cachedImage;
    } else {
        self.userImage.image = [UIImage imageNamed:@"didntLoad"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.thumbnailUrl]];
            UIImage *image = [UIImage imageWithData:imageData];
            if (image) {
                [self.imageCache setObject:image forKey:imageKey];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.userImage.image = image;
                });
            }
        });
    }
    
}

@end
