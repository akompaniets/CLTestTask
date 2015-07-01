//
//  AKUserDetailModel.h
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AKFriend;
@interface AKFriendDetailModel : NSObject

- (void)commitChangesForFriend:(AKFriend *)friend;
- (UIImage *)loadImageWithFileName:(NSString *)filename;

@end
