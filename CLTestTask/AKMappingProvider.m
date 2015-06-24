//
//  AKMappingProvider.m
//  CLTestTask
//
//  Created by Mobindustry on 6/24/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKMappingProvider.h"

@implementation AKMappingProvider

+ (FEMManagedObjectMapping *)friendMapping {
    return [FEMManagedObjectMapping mappingForEntityName:@"AKFriend" configuration:^(FEMManagedObjectMapping *sender) {
        [sender addAttributesFromDictionary:@{@"firstName" : @"first",
                                             @"lastName" : @"last",
                                             @"phone" : @"phone",
                                             @"email" : @"email",
                                             @"friend" : @(YES),
                                             @"sha256" : @"sha256",
                                             @"title" : @"title",
                                             @"thumbnail" : @"thumbnail",
                                             @"photoPath" : @"large"}];
                                              
    }];
}

@end
