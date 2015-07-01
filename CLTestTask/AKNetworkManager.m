//
//  AKNetworkManager.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKNetworkManager.h"

@interface AKNetworkManager ()


@end

@implementation AKNetworkManager

+ (instancetype)sharedManager {
    static AKNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AKNetworkManager new];
        manager.reachability = [AFNetworkReachabilityManager sharedManager];
        [manager.reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
           
            [[NSNotificationCenter defaultCenter] postNotificationName:AKNetworkManagerReachabilityStatusDidChangeNotification object:@{@"status" : @(status)}];
           
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        }];
        [manager.reachability startMonitoring];
    });
    
    return manager;
}

- (void)fetchRandomUsersWithCallback:(void(^)(id usersData, NSError *error))callback {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                                    NSLog(@"JSON: %@", responseObject);
                                                    callback(responseObject,nil);
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                    NSLog(@"Error: %@", error);
                                                    callback(nil,error);
                                            }];
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];
//    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//    
//        if (error) {
//            NSLog(@"Error: %@", error);
//            callback(nil, error);
//        } else {
////            NSLog(@"%@ %@", response, responseObject);
//            callback(responseObject, nil);
//        }
//        [dataTask cancel];
//    }];
//    [dataTask resume];
}

@end
