//
//  SearchDeviceViewController.m
//  FreshAir
//
//  Created by mars on 27/11/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_SearchDeviceViewController.h"
#import "HomeKit_RoomSettingViewController.h"
#import "YRDropdownView.h"
#import "HomeKit_AccessoryManager.h"
#import <HomeKit/HomeKit.h>
#import "HomeKit_CommonAPI.h"

@interface HomeKit_SearchDeviceViewController ()<UITableViewDelegate, UITableViewDataSource, RoomSettingViewControllerDelegate>
{
    __weak IBOutlet UITableView *_tv;
    __weak IBOutlet UIActivityIndicatorView *_aiv;
    __weak IBOutlet UIView *viewAlert;
    
    HomeKit_AccessoryManager *_manager;
    NSMutableArray *_maNewDvice;
    HMAccessory *_acc;
    NSInteger _currentSelected;
}
@end

@implementation HomeKit_SearchDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tv.hidden = YES;
    _tv.dataSource = self;
    _tv.delegate = self;
    _currentSelected = -1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"查询新设备";
//    [self setStatusBarBackgroundColor:[UIColor redColor]];
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self setBackButtonWithImage];
    _manager = [HomeKit_AccessoryManager sharedInstance];
    _maNewDvice = [NSMutableArray array];
    
    [self performSelector:@selector(searchNewDevice) withObject:nil afterDelay:2];
//    [self changeStatsBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self preferredStatusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

-(void)changeStatsBar {
    [self setNeedsStatusBarAppearanceUpdate];
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)goToBack {
    [_manager stopSearchAccessory];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:^{
        _currentSelected = -1;
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

- (void)searchNewDevice
{
    
    [_manager searchAccessoryWithCompletionBlock:^(HMAccessory *result) {
        __block BOOL exist = NO;
        [_maNewDvice enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HMAccessory *ac = result;
            if([ac.name isEqualToString:result.name]){
                exist = YES;
                *stop = YES;
            }
        }];
        
        if(!exist){
            [_maNewDvice addObject:result];
        }
        
        _tv.hidden = NO;
        viewAlert.hidden = YES;
        [_tv reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _maNewDvice.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        
    }
    
    HMAccessory *device = (HMAccessory *)[_maNewDvice objectAtIndex:indexPath.row];
    cell.textLabel.text = device.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_currentSelected != -1){
        [self showDropdownViewWithMessage:@"处理中..."];
        return;
    }
    _currentSelected = indexPath.row;
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)cell.accessoryView;
    
    [activity startAnimating];
    MLWeakSelf weakSelf = self;
    HMAccessory *device = [_maNewDvice objectAtIndex:indexPath.row];
    [_manager addAccessory:device completionHandler:^(NSError * _Nullable error) {
        [weakSelf alertWithResult:error == nil device:device];
        [activity stopAnimating];
        _currentSelected = -1;
        
    }];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertWithResult:(BOOL)pResult device:(HMAccessory *)pDevice
{
    if(pResult){
        [_maNewDvice removeObject:pDevice];
        [_tv reloadData];
        _acc = pDevice;
    }
    
    if(!pResult){
        [self showDropdownViewWithMessage:@"设备添加失败，请重试！" ];
        
        [_maNewDvice removeAllObjects];
        
        [_tv reloadData];
        [self performSelector:@selector(searchNewDevice) withObject:nil afterDelay:2];
    }
    
    if(pResult){
        HomeKit_RoomSettingViewController *vcRoomSetting = (HomeKit_RoomSettingViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"RoomSettingViewController"];
        vcRoomSetting.enterType = EnterTypeAddNewDevice;
//        vcRoomSetting.currentRoom = _acc.room;
        vcRoomSetting.delegate = self;
        [self.navigationController pushViewController:vcRoomSetting animated:YES];
    }
}

- (void)showDropdownViewWithMessage:(NSString *)pMessage
{
    
    [YRDropdownView showDropdownInView:self.navigationController.view
                                 title:@"Warning"
                                detail:pMessage
                                 image:[UIImage imageNamed:@"dropdown-alert"]
                              animated:YES hideAfter:2];
}

- (void)selectedRoom:(HMRoom *_Nullable)pRoom
{
    if(pRoom){
        [_manager.currentHome assignAccessory:_acc toRoom:pRoom completionHandler:^(NSError * _Nullable error) {
            if(error){
                [self showDropdownViewWithMessage:@"分配房间错误，请重试！"];
            }
            else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    
}

@end
