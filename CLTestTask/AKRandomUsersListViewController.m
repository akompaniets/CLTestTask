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

@interface AKRandomUsersListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) AKRandomUsersListModel *model;
@property (strong, nonatomic) NSArray *users;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableIndexSet *selectedIndexes;

@end

@implementation AKRandomUsersListViewController

+ (NSString *)controllerID {
    return NSStringFromClass([self class]);
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.model = [AKRandomUsersListModel new];
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block typeof(self) weakSelf = self;
    [self.model fetchNewUserListWithCallback:^(NSArray *newUsers, NSError *error) {
        
        if (error) {
            NSLog(@"Something wrong!");
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
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSArray *selectedUsers = [self.users objectsAtIndexes:self.selectedIndexes];
        if ([self.model saveSelectedUsers:selectedUsers]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismissSelf];
        }
       
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
    NSString *photoPath = [[self.users objectAtIndex:indexPath.row] valueForKeyPath:@"user.picture.thumbnail"];
    NSString *title = [(NSString *)[[self.users objectAtIndex:indexPath.row] valueForKeyPath:@"user.name.title"] capitalizedString];
    NSString *fName = [(NSString *)[[self.users objectAtIndex:indexPath.row] valueForKeyPath:@"user.name.first"] capitalizedString];
    NSString *lName = [(NSString *)[[self.users objectAtIndex:indexPath.row] valueForKeyPath:@"user.name.last"] capitalizedString];
    
    NSString *cellTitle = [NSString stringWithFormat:@"%@.%@ %@", title, fName, lName];
    [cell setupCellForIndexPath:indexPath withPhotoPath:photoPath title:cellTitle];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AKUserCell *cell = (AKUserCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSInteger selectedIndex = indexPath.row;
  
    if ([self.selectedIndexes containsIndex:selectedIndex]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedIndexes removeIndex:selectedIndex];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedIndexes addIndex:selectedIndex];
    }
    NSLog(@"Selected indexes: %@", self.selectedIndexes);
}

-(void)dealloc {
    NSLog(@"Controller was deallocated");
}

@end
