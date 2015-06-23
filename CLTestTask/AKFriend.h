//
//  AKFriend.h
//  CLTestTask
//
//  Created by Mobindustry on 6/23/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AKFriend : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain, getter=isFriend) NSNumber * friend;
@property (nonatomic, retain) NSString * sha256;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * photoPath;

@end
