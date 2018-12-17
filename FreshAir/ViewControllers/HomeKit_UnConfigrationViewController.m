//
//  UnConfigrationViewController.m
//  FreshAir
//
//  Created by mars on 28/11/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_UnConfigrationViewController.h"

#import <ExternalAccessory/ExternalAccessory.h>

@interface HomeKit_UnConfigrationViewController ()<UITableViewDelegate, UITableViewDataSource, EAWiFiUnconfiguredAccessoryBrowserDelegate>
{
    __weak IBOutlet UITableView *_tv;
    __weak IBOutlet UIActivityIndicatorView *_aiv;
    __weak IBOutlet UIView *viewAlert;
    
    NSMutableArray *_maUnconfigrationDvice;
    EAWiFiUnconfiguredAccessoryBrowser *_browser;
}
@end

@implementation HomeKit_UnConfigrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tv.hidden = YES;
    _tv.dataSource = self;
    _tv.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"未配置WIFI设备";
    [self setBackButtonWithImage];
    
    if (_browser == nil) {
        _browser = [[EAWiFiUnconfiguredAccessoryBrowser alloc] initWithDelegate:self queue:nil];
        _browser.delegate = self;
    }
    
    _maUnconfigrationDvice = [NSMutableArray array];
    
    [self performSelector:@selector(searchUnconfigrationDevice) withObject:nil afterDelay:2];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goToBack {
    [_browser stopSearchingForUnconfiguredAccessories];
    _browser = nil;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setBackButtonWithImage {
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(goToBack)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //修复navigationController侧滑关闭失效的问题
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)searchUnconfigrationDevice
{
    [_browser startSearchingForUnconfiguredAccessoriesMatchingPredicate:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _maUnconfigrationDvice.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    EAWiFiUnconfiguredAccessory *device = (EAWiFiUnconfiguredAccessory *)[_maUnconfigrationDvice objectAtIndex:indexPath.row];
    cell.textLabel.text = device.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MLWeakSelf weakSelf = self;
    EAWiFiUnconfiguredAccessory *device = [_maUnconfigrationDvice objectAtIndex:indexPath.row];
    [_browser configureAccessory:device withConfigurationUIOnViewController:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - EAWiFiUnconfiguredAccessoryBrowserDelegate methods

- (void)accessoryBrowser:(EAWiFiUnconfiguredAccessoryBrowser *)browser didUpdateState:(EAWiFiUnconfiguredAccessoryBrowserState)state
{
    //    NSSet<EAWiFiUnconfiguredAccessory *> *acs = browser.unconfiguredAccessories;
    NSLog(@"didUpdateState %ld", (long)state);
    //    [self reloadTable];
}

- (void)accessoryBrowser:(EAWiFiUnconfiguredAccessoryBrowser *)browser didFindUnconfiguredAccessories:(NSSet<EAWiFiUnconfiguredAccessory *> *)accessories
{
//    EAWiFiUnconfiguredAccessory *ea = [accessories anyObject];
    //    ea setc
    NSLog(@"didFindUnconfiguredAccessories");
    [_maUnconfigrationDvice removeAllObjects];
    
    [accessories enumerateObjectsUsingBlock:^(EAWiFiUnconfiguredAccessory * _Nonnull obj, BOOL * _Nonnull stop) {
        [_maUnconfigrationDvice addObject:obj];
    }];
    
    _tv.hidden = NO;
    viewAlert.hidden = YES;
    [_tv reloadData];
    
}

- (void)accessoryBrowser:(EAWiFiUnconfiguredAccessoryBrowser *)browser didRemoveUnconfiguredAccessories:(NSSet<EAWiFiUnconfiguredAccessory *> *)accessories
{
    EAWiFiUnconfiguredAccessory *ea = [accessories anyObject];
    NSLog(@"didRemoveUnconfiguredAccessories");
    
}

- (void)accessoryBrowser:(EAWiFiUnconfiguredAccessoryBrowser *)browser didFinishConfiguringAccessory:(EAWiFiUnconfiguredAccessory *)accessory withStatus:(EAWiFiUnconfiguredAccessoryConfigurationStatus)status
{
    NSLog(@"didFinishConfiguringAccessory");
    if(status == EAWiFiUnconfiguredAccessoryConfigurationStatusSuccess){
        [_maUnconfigrationDvice removeObject:accessory];
        [_tv reloadData];
    }
    
}

@end
