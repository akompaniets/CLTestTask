//
//  AKRandomUsersListViewController.m
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import "AKRandomUsersListViewController.h"
#import "AKPopupPresentationViewController.h"
#import "AKAppDelegate.h"
#import "AKUserCell.h"
#import "AKRandomUsersListModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AKUser.h"

@interface AKRandomUsersListViewController () <UITableViewDataSource, UITableViewDelegate, AKRandomUsersListModelDelegate>

@property (strong, nonatomic) AKRandomUsersListModel *model;
@property (strong, nonatomic) NSArray *users;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) NSMutableIndexSet *selectedIndexes;

@end

@implementation AKRandomUsersListViewController

+ (NSString *)controllerID {
    return NSStringFromClass([self class]);
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navBar.topItem.title = NSLocalizedString(@"user_list_title", nil);
    self.model = [AKRandomUsersListModel sharedModel];
    self.model.delegate = self;
    self.doneButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block typeof(self) weakSelf = self;
    [self.model fetchNewUserListWithCallback:^(NSArray *newUsers, NSError *error) {
        
        if (error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil)
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        } else {
            weakSelf.users = newUsers;
            [weakSelf.tableView reloadData];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (IBAction)dismissController:(UIBarButtonItem *)sender {
    
    [self dismissSelf];
}

- (IBAction)addUsersToFriendList:(UIBarButtonItem *)sender {
    
    if (self.selectedIndexes && [self.selectedIndexes count] > 0) {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSArray *selectedUsers = [self.users objectsAtIndexes:self.selectedIndexes];
        __weak typeof(self) weakSelf = self;
        [self.model saveSelectedUsers:selectedUsers withCompletionHandler:^{
            
//                [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
                [weakSelf dismissSelf];
            
        }];
        
    } else {
        return;
    }
}

- (void)dismissSelf {
    
    [(AKPopupPresentationViewController *)([[AKAppDelegate sharedDelegate] window].rootViewController) hidePopupViewController];
}


#pragma mark -

- (NSMutableIndexSet *)selectedIndexes {
    
    if (!_selectedIndexes) {
        _selectedIndexes = [[NSMutableIndexSet alloc] init];
    }
    return _selectedIndexes;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *const cellID = [AKUserCell cellIdentifier];
    AKUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[AKUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if ([self.selectedIndexes containsIndex:indexPath.row]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    AKUser *user = self.users[indexPath.row];
    [cell configureCellAtIndexPath:indexPath forUser:user];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger selectedIndex = indexPath.row;
    if ([self.selectedIndexes containsIndex:selectedIndex]) {
        [self.selectedIndexes removeIndex:selectedIndex];
    } else {
        [self.selectedIndexes addIndex:selectedIndex];
    }
    
    if ([self.selectedIndexes count] == 0) {
        self.doneButton.enabled = NO;
    } else {
        self.doneButton.enabled = YES;
    }
    [tableView reloadData];
}

#pragma mark - AKRandomUsersListModelDelegate

- (void)modelDidFinishHandling:(AKRandomUsersListModel *)model {
//    [MBProgressHUD hideHUDForView:self.view animated:NO];
//    [self dismissSelf];
}

#pragma mark - Dealloc

-(void)dealloc {
    NSLog(@"Controller was deallocated");
}

@end
