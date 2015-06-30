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

+ (NSString *)documentDirectoryPath {
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *documentsDirectory = [directoryURL path];
    return documentsDirectory;
}

+ (void)saveImageData:(NSData *)imageData withName:(NSString *)name {
    NSString *documentPath = [self documentDirectoryPath];
    NSString *filePath = [documentPath stringByAppendingPathComponent:name];
    
    NSError *error;
    [imageData writeToFile:filePath options:NSDataWritingAtomic error:&error];
    if (error) {
#if BEBUG
        NSLog(@"Error writing: %@", [error localizedDescription]);
#endif
    }
}

+ (NSData *)loadImageDataForFileName:(NSString *)fileName; {
    NSString *documentDirectory = [self documentDirectoryPath];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    NSData *fileData;

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        fileData = [[NSData alloc] initWithContentsOfFile:filePath];
    }
    
    return fileData;
}

@end
