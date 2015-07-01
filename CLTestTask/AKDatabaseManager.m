//
//  AKDatabaseManager.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKDatabaseManager.h"
#import "AKMappingProvider.h"
#import "AKFriend.h"
#import "AKUser.h"
#import <FEMManagedObjectDeserializer.h>

@interface AKDatabaseManager()

@property (strong, nonatomic) NSManagedObjectContext *writerContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation AKDatabaseManager

#pragma mark - Core Data stack

@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)sharedManager {
    static AKDatabaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AKDatabaseManager new];
    });
    
    return manager;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CLTestTask" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSManagedObjectContext *)mainContext {
    if (!_mainContext) {
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainContext.parentContext = self.writerContext;
    }
    return _mainContext;
}

- (NSManagedObjectContext *)writerContext {
    if (!_writerContext) {
        _writerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (!coordinator) {
            return nil;
        }
        _writerContext.persistentStoreCoordinator = coordinator;
    }
    
    return _writerContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CLTestTask.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Actions

- (void)markFriendAsNonFriend:(AKFriend *)friend {

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AKFriend"];
    request.predicate = [NSPredicate predicateWithFormat:@"sha256 == %@", friend.sha256];
    request.resultType = NSManagedObjectResultType;
    
    AKFriend *fetchedFriend = [self.mainContext executeFetchRequest:request error:nil].firstObject;
    fetchedFriend.isFriend = @(NO);
//    [self.mainContext refreshObject:fetchedFriend mergeChanges:YES];
//        NSEntityDescription *desc = [NSEntityDescription entityForName:@"AKFriend" inManagedObjectContext:self.mainContext];
//        NSBatchUpdateRequest *request = [[NSBatchUpdateRequest alloc] initWithEntity:desc];
//        request.predicate = [NSPredicate predicateWithFormat:@"sha256 == %@", friend.sha256];
//        request.propertiesToUpdate = @{@"isFriend" : @(NO)};
//        request.resultType = NSUpdatedObjectIDsResultType;
//        NSError *requestError;
//        NSBatchUpdateResult *result = (NSBatchUpdateResult *)[self.writerContext executeRequest:request error:&requestError];
//        
//        NSArray *resultObjects = result.result;
//        for (NSManagedObjectID *fetchedObject in resultObjects) {
//            NSManagedObject *ob = [self.mainContext objectRegisteredForID:fetchedObject];
//            if (ob) {
//                [self.mainContext refreshObject:ob mergeChanges:YES];
//            }
//            
//        }
//#if DEBUG
//        NSLog(@"Update for row: %@\n Error: %@", friend.sha256, [requestError localizedDescription]);
//#endif
        [self saveContextWithCallback:nil];
//    });
}

- (void)saveUsers:(NSArray *)users withCompletionHandler:(void(^)(NSError *error))completionHandler {
    
    for (AKUser *currentUser in users) {
        if ([self checkUserForExisting:currentUser]) {
            continue;
        }
        AKFriend *friend = [NSEntityDescription insertNewObjectForEntityForName:@"AKFriend" inManagedObjectContext:self.mainContext];
        
        friend.title = currentUser.title;
        friend.firstName = currentUser.firstName;
        friend.lastName = currentUser.lastName;
        friend.sha256 = currentUser.sha256;
        friend.email = currentUser.email;
        friend.phone = currentUser.phone;
        friend.thumbnailPath = currentUser.thumbnailUrl;
        friend.photoPath = currentUser.photoUrl;
        friend.isFriend = @(YES);
    }
    
    [self saveContextWithCallback:^(NSError *error) {
        if (completionHandler) {
            completionHandler(error);
        }
    }];

}

- (BOOL)checkUserForExisting:(AKUser *)user {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AKFriend"];
    request.predicate = [NSPredicate predicateWithFormat:@"sha256 == %@", user.sha256];
    request.resultType = NSCountResultType;
    NSInteger matches = 0;
    matches = [[self.mainContext executeFetchRequest:request error:nil].firstObject integerValue];
    if (matches > 0) {
        return YES;
    }
    return NO;

}

- (void)updateChangesForFriend:(AKFriend *)friend {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AKFriend"];
    request.predicate = [NSPredicate predicateWithFormat:@"sha256 == %@", friend.sha256];
    request.resultType = NSManagedObjectResultType;
    
    AKFriend *fetchedFriend = [self.mainContext executeFetchRequest:request error:nil].firstObject;
    fetchedFriend.firstName = friend.firstName;
    fetchedFriend.lastName = friend.lastName;
    fetchedFriend.email = friend.email;
    fetchedFriend.phone = friend.phone;

    [self saveContextWithCallback:nil];
    
}

#pragma mark - Core Data Saving

- (void)saveContextWithCallback:(void(^)(NSError *error))callback {
     __weak typeof(self) weakSelf = self;
  
        [self.mainContext performBlockAndWait:^{
            NSError *error = nil;
            if ([weakSelf.mainContext save:&error])
            {
#if DEBUG
                NSLog(@"%@", error ? [error localizedDescription] : @"Main Context Saved!");
#endif
            }
        }];
    
    __block NSError *error = nil;

    [self.writerContext performBlockAndWait:^{
        
        if ([weakSelf.writerContext save:&error])
        {
#if DEBUG
            NSLog(@"%@", error ? [error localizedDescription] : @"Writer Context Saved!");
#endif
        };
    }];
    if (callback) {
        callback(error);
    }
}

@end
