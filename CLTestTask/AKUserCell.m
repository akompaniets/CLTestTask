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

@end

@implementation AKUserCell

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellwithPhotoPath:(NSString *)path title:(NSString *)title {
    self.userName.text = title;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.userLogo.image = [UIImage imageWithData:imageData];
        });
    });
}

@end
