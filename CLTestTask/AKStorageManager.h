//
//  AKStorageManager.h
//  CLTestTask
//
//  Created by Mobindustry on 6/26/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AKStorageManager : NSObject

+ (instancetype)sharedManager;
+ (BOOL)saveImage:(UIImage *)image;
+ (UIImage *)loadImageForPath:(NSString *)filePath;

@end
