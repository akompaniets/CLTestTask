//
//  AKDownloadOperation.m
//  CLTestTask
//
//  Created by Andrey Kompaniets on 29.06.15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKDownloadOperation.h"
#import "AKUser.h"
#import "AKStorageManager.h"
#import "AKDatabaseManager.h"

@interface AKDownloadOperation()

@property (strong, nonatomic) NSString *thumbnailURL;
@property (strong, nonatomic) NSString *photoURL;
@property (strong, nonatomic) AKUser *user;


@end

@implementation AKDownloadOperation
- (instancetype)initWithUser:(AKUser *)user {
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)main {
    @autoreleasepool {
        
        NSData *photo = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.user.photoUrl]];
        NSData *thumbnail = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.user.thumbnailUrl]];
        
        NSString *photoName = [NSString stringWithFormat:@"photo_%@", self.user.sha256];
        NSString *thumbnailName = [NSString stringWithFormat:@"thumbnail_%@", self.user.sha256];
        
        [AKStorageManager saveImageData:photo withName:photoName];
        [AKStorageManager saveImageData:thumbnail withName:thumbnailName];
        
        self.user.photoName = photoName;
        self.user.thumbnailName = thumbnailName;
        
        [[AKDatabaseManager sharedManager] saveUsers:@[self.user]
                               withCompletionHandler:nil];
        
    }
}

@end
