//
//  BaseTableViewController.m
//  FreshAir
//
//  Created by mars on 2018/4/5.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_BaseTableViewController.h"

@interface HomeKit_BaseTableViewController ()

@end

@implementation HomeKit_BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

- (void)setTitle:(NSString *)pTitle
{
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 80, 40)];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.text = pTitle;
    
    self.navigationItem.titleView = lblTitle;
    
}

@end
