//
//  AKUserCell.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKUserCell.h"

@interface AKUserCell()

@property (weak, nonatomic) IBOutlet UIImageView *userLogo;
@property (weak, nonatomic) IBOutlet UILabel *userName;
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

- (void)setupCellForIndexPath:(NSIndexPath *)indexPath withPhotoPath:(NSString *)path title:(NSString *)title {
    self.userName.text = title;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *imageKey = [NSString stringWithFormat:@"cell%ld", indexPath.row];
    UIImage *cachedImage = [self.imageCache objectForKey:imageKey];
    if (cachedImage) {
        self.userLogo.image = cachedImage;
    } else {
        self.userLogo.image = [UIImage imageNamed:@"didntLoad"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
            UIImage *image = [UIImage imageWithData:imageData];
            if (image) {
                [self.imageCache setObject:image forKey:imageKey];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.userLogo.image = image;
                });
            }
            
        });
    }
}

@end
