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

@interface AKRandomUsersListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) AKRandomUsersListModel *model;
@property (copy, nonatomic) NSMutableArray *users;

@end

@implementation AKRandomUsersListViewController

+ (NSString *)controllerID {
    return NSStringFromClass([self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [AKRandomUsersListModel new];
    __block typeof(self) weakSelf = self;
    [self.model fetchNewUserListWithCallback:^(id response, NSError *error) {
        if (error) {
            NSLog(@"Something wrong!");
        } else {
            weakSelf.users = [response objectForKey:@"results"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissController:(UIBarButtonItem *)sender {
    [(AKPopupPresentationViewController *)([[AKAppDelegate sharedDelegate] window].rootViewController) hidePopupViewController];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const cellID = [AKUserCell cellIdentifier];
    AKUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[AKUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
//    NSString *logoPath = [
    
    return cell;
}


#pragma mark - UITableViewDelegate

@end
