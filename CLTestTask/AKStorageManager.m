//
//  AKStorageManager.m
//  CLTestTask
//
//  Created by Mobindustry on 6/26/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKStorageManager.h"

@implementation AKStorageManager

+ (instancetype)sharedManager {
   static AKStorageManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AKStorageManager alloc] init];
    });
    return manager;
}

+ (BOOL)saveImage:(UIImage *)image {
   
    NSData *imageData = [NSData data];
    return YES;
}
@end
