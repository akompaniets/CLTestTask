//
//  AKNetworkManager.h
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFURLSessionManager.h>

@interface AKNetworkManager : AFURLSessionManager

+ (instancetype)sharedManager;
- (void)fetchRandomUsersWithCallback:(void(^)(id usersData, NSError *error))callback;


@end
