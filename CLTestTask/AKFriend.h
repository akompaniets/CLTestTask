//
//  AKFriend.h
//  CLTestTask
//
//  Created by Andrey Kompaniets on 29.06.15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AKFriend : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * isFriend;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * photoPath;
@property (nonatomic, retain) NSString * sha256;
@property (nonatomic, retain) NSString * thumbnailPath;
@property (nonatomic, retain) NSString * title;

@end
