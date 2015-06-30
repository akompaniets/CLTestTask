//
//  AKDownloadOperation.h
//  CLTestTask
//
//  Created by Andrey Kompaniets on 29.06.15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <Foundation/Foundation.h>
//typedef void(^completionBlock)(NSData *thumbnailData, NSData *photoData);
@protocol AKDownloadOperationDelegate;

@interface AKDownloadOperation : NSOperation

@property (weak, nonatomic) id<AKDownloadOperationDelegate>delegate;
@property (strong, nonatomic) NSData *thumbnailData;
@property (strong, nonatomic) NSData *photoData
;
- (instancetype)initWithThumbnailURL:(NSString *)thumbnailURL photoURL:(NSString *)photoURL delegate:(id<AKDownloadOperationDelegate>)delegate;

@end

@protocol AKDownloadOperationDelegate <NSObject>

- (void)downloadOperationDidFinish:(AKDownloadOperation *)operation;

@end
