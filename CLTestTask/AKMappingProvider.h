//
//  AKMappingProvider.h
//  CLTestTask
//
//  Created by Mobindustry on 6/24/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FEMManagedObjectMapping.h>
#import <FEMObjectMapping.h>

@interface AKMappingProvider : NSObject

+ (FEMManagedObjectMapping *)friendMapping;
+ (FEMObjectMapping *)userMapping;

@end
