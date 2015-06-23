//
//  AKNetworkManager.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKNetworkManager.h"

@interface AKNetworkManager () <NSURLSessionTaskDelegate>

@end

@implementation AKNetworkManager

+ (instancetype)sharedManager {
    static AKNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AKNetworkManager new];
    });
    
    return manager;
}

- (void)fetchRandomUsersWithCallback:(void(^)(id usersData, NSError *error))callback {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            callback(nil, error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            callback(responseObject, nil);
        }
    }];
    [dataTask resume];
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"Session - %@ did finish task: %@", session, task);
}

@end
