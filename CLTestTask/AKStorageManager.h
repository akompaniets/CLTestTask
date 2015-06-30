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
+ (void)saveImageData:(NSData *)imageData withName:(NSString *)name;
+ (NSData *)loadImageDataForFileName:(NSString *)fileName;

@end
