//
//  AKMappingProvider.m
//  CLTestTask
//
//  Created by Mobindustry on 6/24/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKMappingProvider.h"
#import "AKUser.h"

@implementation AKMappingProvider

+ (FEMObjectMapping *)userMapping {
    return [FEMObjectMapping mappingForClass:[AKUser class] configuration:^(FEMObjectMapping *mapping) {
        [mapping addAttributeWithProperty:@"title" keyPath:@"user.name.title"];
        [mapping addAttributeWithProperty:@"firstName" keyPath:@"user.name.first"];
        [mapping addAttributeWithProperty:@"lastName" keyPath:@"user.name.last"];
        [mapping addAttributeWithProperty:@"phone" keyPath:@"user.phone"];
        [mapping addAttributeWithProperty:@"email" keyPath:@"user.email"];
        [mapping addAttributeWithProperty:@"sha256" keyPath:@"user.sha256"];
        [mapping addAttributeWithProperty:@"thumbnailUrl" keyPath:@"user.picture.thumbnail"];
        [mapping addAttributeWithProperty:@"photoUrl" keyPath:@"user.picture.medium"];
    }];
}

@end
