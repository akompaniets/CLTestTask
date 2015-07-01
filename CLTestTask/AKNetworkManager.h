//
//  AKNetworkManager.h
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface AKNetworkManager : AFHTTPRequestOperationManager

@property (strong, nonatomic) AFNetworkReachabilityManager *reachability;

+ (instancetype)sharedManager;
- (void)fetchRandomUsersWithCallback:(void(^)(id usersData, NSError *error))callback;

@end
