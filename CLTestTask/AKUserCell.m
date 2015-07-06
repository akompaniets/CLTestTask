//
//  AKUserCell.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKUserCell.h"
#import "AKUser.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface AKUserCell()

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
    self.userName.font = CustomFont;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.userImage setImageWithURL:[NSURL URLWithString:user.thumbnailUrl]
                   placeholderImage:[UIImage imageNamed:PlaceholderImage]];
}

@end
