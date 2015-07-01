//
//  AKDownloadOperation.h
//  CLTestTask
//
//  Created by Andrey Kompaniets on 29.06.15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AKUser;

@interface AKDownloadOperation : NSOperation

@property (strong, nonatomic) NSData *thumbnailData;
@property (strong, nonatomic) NSData *photoData;

- (instancetype)initWithUser:(AKUser *)user;

@end

