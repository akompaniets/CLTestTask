//
//  AKUserCell.h
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKUser;
@interface AKUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;

+ (NSString *)cellIdentifier;
- (void)configureCellAtIndexPath:(NSIndexPath *)indexPath forUser:(AKUser *)user;

@end
