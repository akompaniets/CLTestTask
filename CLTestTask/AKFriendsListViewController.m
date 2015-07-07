//
//  AKUsersListViewController.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKFriendsListViewController.h"
#import "AKFriendCell.h"
#import "AKFriendsListModel.h"
#import <CoreData/CoreData.h>
#import "AKAppDelegate.h"
#import "AKPopupPresentationViewController.h"
#import "AKRandomUsersListViewController.h"
#import "AKDatabaseManager.h"
#import "AKFriend.h"
#import "AKFriendDetailViewController.h"

@interface AKFriendsListViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityViewVerticalConstraint;
@property (strong, nonatomic) AKFriendsListModel *model;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation AKFriendsListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userHandlingStatusDidChange:)
                                                 name:AKRandomUsersListModelDidChangeUserHandlingStatusNotification
                                               object:nil];
    
    self.title = NSLocalizedString(@"friend_list_title", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.fetchedResultsController.fetchedObjects count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"message", nil)
                                                        message:NSLocalizedString(@"empty_friend_list", nil)
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }    
}


#pragma mark - Getters

- (AKFriendsListModel *)model {
    if (!_model) {
        _model = [AKFriendsListModel new];
    }
    return _model;
}

#pragma mark - Actions

- (IBAction)addNewUser:(UIBarButtonItem *)sender {
    AKPopupPresentationViewController *presentationVC = (AKPopupPresentationViewController *)[[AKAppDelegate sharedDelegate] window].rootViewController;
    AKRandomUsersListViewController *randomUsersListVC = [self.storyboard instantiateViewControllerWithIdentifier:[AKRandomUsersListViewController controllerID]];
    [presentationVC showPopupViewController:randomUsersListVC];
}

- (void)showFriendLoadingActivityView:(BOOL)show {
    if (show) {
        [self.activityIndicator startAnimating];
        self.activityViewVerticalConstraint.constant = 0;
        
    } else {
        [self.activityIndicator stopAnimating];
        self.activityViewVerticalConstraint.constant = 35.0;
        
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)userHandlingStatusDidChange:(NSNotification *)notification {
    NSInteger status = [[[notification object] objectForKey:@"status"] integerValue];
    if (status == DidStartUserHandling) {
        [self showFriendLoadingActivityView:YES];
    } else {
        [self showFriendLoadingActivityView:NO];
    }
    
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FriendDetailSegue]) {
        AKFriendDetailViewController *friendDetailVC = segue.destinationViewController;
        AKFriend *friend = [self.fetchedResultsController fetchedObjects][[self.tableView indexPathForSelectedRow].row];
        friendDetailVC.friend = friend;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.fetchedResultsController sections][section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const cellID = [AKFriendCell cellIdentifier];
    AKFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[AKFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    AKFriend *friend = self.fetchedResultsController.fetchedObjects[indexPath.row];
    [cell configureCellForFriend:friend];
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AKFriend *friend = self.fetchedResultsController.fetchedObjects[indexPath.row];
        [self.model deleteFriend:friend];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Core Data init

-(NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext)
    {
        _managedObjectContext = [[AKDatabaseManager sharedManager] backgroundContext];
    }
    return _managedObjectContext;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AKFriend"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:15];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName"
                                                                   ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFriend == %@", @YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    __weak typeof(self) weakSelf = self;
    [self.fetchedResultsController.managedObjectContext performBlock:^{
        NSError *error = nil;
                if (![weakSelf.fetchedResultsController performFetch:&error])
                {
                    NSLog(@"Fetching error %@, %@", error, [error userInfo]);
                    abort();
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadData];
                    });
                    
                }
    }];
    



    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate: {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView endUpdates];
    });
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:AKRandomUsersListModelDidChangeUserHandlingStatusNotification];
}
@end
