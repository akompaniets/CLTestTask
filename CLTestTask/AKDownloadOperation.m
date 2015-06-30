//
//  AKDownloadOperation.m
//  CLTestTask
//
//  Created by Andrey Kompaniets on 29.06.15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKDownloadOperation.h"

@interface AKDownloadOperation()

@property (strong, nonatomic) NSString *thumbnailURL;
@property (strong, nonatomic) NSString *photoURL;


@end

@implementation AKDownloadOperation

- (instancetype)initWithThumbnailURL:(NSString *)thumbnailURL photoURL:(NSString *)photoURL delegate:(id<AKDownloadOperationDelegate>)delegate {
    self = [super init];
    if (self) {
        self.thumbnailURL = thumbnailURL;
        self.photoURL = photoURL;
        if (delegate) {
            self.delegate = delegate;
        }
    }
    return self;
}

- (void)main {
    @autoreleasepool {
        self.thumbnailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbnailURL]];
        
        self.photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.photoURL]];
        
        if ([self.delegate respondsToSelector:@selector(downloadOperationDidFinish:)]) {
            [self.delegate downloadOperationDidFinish:self];
        }
    }
}

@end
