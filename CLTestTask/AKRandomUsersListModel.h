//
//  AKRandomUsersListModel.h
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKRandomUsersListModel : NSObject

- (void)fetchNewUserListWithCallback:(void(^)(id response, NSError *error))callback;

@end
