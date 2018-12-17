//
//  MainViewController.m
//  FreshAir
//
//  Created by mars on 16/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//




#import "HomeKit_MainViewController.h"
#import "HomeKit_DetailViewController.h"
#import "HomeKit_DetailXLinkViewController.h"
#import "HomeKit_SearchDeviceViewController.h"
#import "HomeKit_UnConfigrationViewController.h"
#import "HomeKit_BaseNavigationController.h"
#import "HomeKit_RoomSettingViewController.h"
#import "HomeKit_SelectedViewController.h"
#import "HomeKit_HelpViewController.h"

#import "HomeKit_ConfigServiceViewController.h"

#import "AppDelegate.h"
#import "HomeKit_CommonAPI.h"
#import "HomeKit_HomeBottomBar.h"
#import "HomeKit_MainTableViewCell.h"
#import "HomeKit_ColorManager.h"
#import "NSString+MP.h"
#import "NSObject+ML.h"
#import "UIView+ML.h"

#import "HomeKit_UserService.h"
#import "HomeKit_DeviceService.h"
#import "HomeKit_DeviceResponse.h"
#import "HomeKit_Device.h"

#import "YRDropdownView.h"
#import "RefreshButton.h"

#import "HomeKit_UserService.h"
#import "HomeKit_User.h"
#import "HomeKit_ADService.h"
#import "HomeKit_SplashAD.h"

#import "HomeKit_DevicesRequest.h"
#import "HomeKit_DevicesResponse.h"


#import "YBPopupMenu.h"
#import "JGProgressHUD.h"
#import "DrawCircleProgressButton.h"

#import "HomeKit_WatchInfoOutdoorRequest.h"
#import "HomeKit_AreaPickerViewController.h"
#import "HomeKit_WatchInfoOutdoorResponse.h"
#import "HomeKit_WatchInfoOutdoor.h"
#import "HomeKit_CustomerAreaStationInfo.h"

#import "HomeKit_PMDescriptionView.h"
#import "AuthWechatManager.h"
#import "AppDelegate.h"

#import "HomeKit_BooleanResponse.h"
#import "HomeKit_ArrayServiceResponse.h"
#import "XLinkDevice.h"

#import "AFNetworkReachabilityManager.h"

@interface HomeKit_MainViewController ()
<HomeBottomBarDelegate,
AccessoryManagerDelegate,
YBPopupMenuDelegate,
AreaPickerViewControllerDelegate,
PMDescriptionViewDelegate, HomeKit_MainTableViewCellDelegate>
{
    __weak IBOutlet UIButton *_btnRechable;
    __weak IBOutlet UITextView *_tvlog;
    
    __weak IBOutlet UIView *_viewHeader;
    __weak IBOutlet UIView *_viewBannerBg;
    __weak IBOutlet HomeKit_HomeBottomBar *_homeButton;
    __weak IBOutlet NSLayoutConstraint *_cBottomHeight;
    
    __weak IBOutlet UITableView *_tvDevice;
    __weak IBOutlet UIButton *_btnLocation;
    
    __weak IBOutlet NSLayoutConstraint *_cPinIconLeft;
    __weak IBOutlet NSLayoutConstraint *_cPinIconWidth;
    __weak IBOutlet NSLayoutConstraint *_cLocationNameLeft;
    __weak IBOutlet NSLayoutConstraint *_cLocationNameWidth;
    
    
    __weak IBOutlet RefreshButton *_btnRefresh;
    
    __weak IBOutlet UILabel *_lblPM25Count;
    
    __weak IBOutlet HomeKit_PMDescriptionView *_viewPMDescription;
    __weak IBOutlet NSLayoutConstraint *_cViewPM25DescriptionWidth;
    
    __weak IBOutlet UILabel *_lblDate;
    __weak IBOutlet UILabel *_lblPMDensity;
    
    NSMutableArray *_maDevices;
    CAGradientLayer *_backgroundLayer;
    NSTimer *_timerDevices;
    JGProgressHUD *_HUD;
    BOOL _isDownloading;
    
    HomeKit_AccessoryManager *_manager;
    
    NSArray *_arrControlMenuItem;
    
    //outdoor info
    HomeKit_CustomerAreaStationInfo *_customerAreaStationInfo;
    NSString *_currentCity;
    NSString *_currentArea;
    NSInteger _outdoorValue;
    
    //for check net
    AFNetworkReachabilityStatus _status;
    
    //splash ad
    BOOL _splashADToBeRemoved;
    
    BOOL _checkPermissioning;
    
    BOOL _enabled;
    
    BOOL _richable;
    BOOL _bigLogWindow;
    CGRect _logWindowFrame;
    
    BOOL _hasLogined;
}
//ad for start
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation HomeKit_MainViewController

- (IBAction)actionForChangeRichable:(id)sender {
    _richable = !_richable;
    
    if(_richable){
        [_btnRechable setTitle:@"YES" forState:UIControlStateNormal];
    }
    else{
        [_btnRechable setTitle:@"NO" forState:UIControlStateNormal];
    }
    
}

- (void)setLogWindowSize:(UIGestureRecognizer *)pGesture{
    if(_bigLogWindow){
        [UIView animateWithDuration:.5 animations:^{
            _tvlog.frame = _logWindowFrame;
        } completion:^(BOOL finished) {
//            _tvlog
        }];
    }
    else{
        [UIView animateWithDuration:.5 animations:^{
            _tvlog.frame = self.view.bounds;
        } completion:^(BOOL finished) {
//            [_tvlog scrollRectToVisible:CGRectMake(0, _tvlog.contentSize.height-15, _tvlog.contentSize.width, 10) animated:YES];
        }];
    }
    _bigLogWindow = !_bigLogWindow;
}


#pragma mark - life cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _tvlog.hidden = !kIsDebug;
    _tvlog.text = @"";
    _richable = YES;
    _btnRechable.hidden = !kIsDebug;
    _bigLogWindow = NO;
    _logWindowFrame = _tvlog.frame;
    [_tvlog addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setLogWindowSize:)]];
    
    
    [_btnRechable setTitle:@"YES" forState:UIControlStateNormal];
    
    [self initController];
    [self addReachabilityManager];
    
}

- (void)initController
{
    [_homeButton hiddenLoginButton:YES];
    if([[NSUserDefaults standardUserDefaults] valueForKey:kWechatUserJsonKey]){
        HomeKit_User *user = nil;
        NSString *oID = [HomeKit_UserService sharedInstance].user.openid;
        
//        [_homeButton hiddenLoginButton:YES];
//        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:kWechatUserJsonKey];
        if(oID == nil){
            user = [[HomeKit_User alloc] initWithJSON:[[NSUserDefaults standardUserDefaults] valueForKey:kWechatUserJsonKey]];
            
            [user addInformationProfileWithJSON:[[NSUserDefaults standardUserDefaults] valueForKey:kWechatUserJsonKey]];
            [HomeKit_UserService sharedInstance].user = user;
        }
        else{
            user = [HomeKit_UserService sharedInstance].user;
        }
        
        
        if(_hasLogined == NO){
            
            
            [[HomeKit_DeviceService sharedInstance] loginWithOpenId:user.openid
                                                            unionId:user.unionid
                                                           nickName:user.nickname
                                                         headimgurl:user.headimgurl
                                                    completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                        HomeKit_BooleanResponse *res = (HomeKit_BooleanResponse *)pServiceResponse;
                                                        _hasLogined = res.responseResult;
                                                    }];
        }
        
        //        getAllDevices
        [[HomeKit_DeviceService sharedInstance] getAllDevicesWithUID:user.unionid openID:user.openid completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
//            HomeKit_ArrayServiceResponse *response = (HomeKit_ArrayServiceResponse *)pServiceResponse;
            
        }];
    }
    
    _homeButton.delegate = self;
    _viewPMDescription.delegate = self;
    _tvDevice.backgroundColor = [[HomeKit_ColorManager sharedInstance] mainBgLightGray];
    _viewHeader.backgroundColor = [[HomeKit_ColorManager sharedInstance] mainBgLightGray];
    
    _viewBannerBg.backgroundColor = [[HomeKit_ColorManager sharedInstance] colorTopBarAndBanner];
    _tvDevice.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initUI];
    
    
    
    [HomeKit_DeviceService sharedInstance].vcMain = self;
    
    //check splash ad
    
    if(![HomeKit_ADService sharedInstance].luanchAdverShown && [[HomeKit_ADService sharedInstance] checkSplashAD]){
        [self addSplash];
    }
    else{
        [[HomeKit_ADService sharedInstance] retrieveSplashAdvertisementWithDetailDeviceType:[self screenType] completionBlock:^(HomeKit_SplashAD *result, HttpStatusType httpStatusType) {}];
    }
    
    [HomeKit_ADService sharedInstance].luanchAdverShown = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _manager = [HomeKit_AccessoryManager sharedInstance];
    _manager.delegate = self;
    
    
    [self refresh];
    [self startFetch];
    
}

#pragma mark - init UI
- (void)initUI{
    _btnLocation.enabled = NO;
    if(self.comeFrom == ComeFromRoom){
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.title = self.room.name;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        if(_manager.currentHome){
            _btnLocation.enabled = YES;
            self.title = _manager.currentHome.name;
            [self FetchLocation];
            
            if([_manager checkCurrrentUserIsAdmin]){
                _cBottomHeight.constant = 44;
                _homeButton.hidden = NO;
                _arrControlMenuItem = @[@"房间设置", @"邀请用户"];
            }
            else{
                _cBottomHeight.constant = 0;
                _homeButton.hidden = YES;
                _arrControlMenuItem = @[@"房间设置"];
            }
        }
        else{
            self.title = @"";
        }
        

    }
}

#pragma mark - actions


- (IBAction)actionForLeftMenu:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)actionForRightItem:(id)sender {
    
    if(_manager.homeManager.homes.count == 0){
        MLWeakSelf weakSelf = self;
        _checkPermissioning = YES;
        [_manager checkPermissionStatusWithCompletionHandler:^(BOOL hasPermission) {
            _checkPermissioning = NO;
            if(!hasPermission){
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法设置"
                                                                                         message:@"请在iPhone的“设置-隐私-HomeKit”选项中，允许空气堡访问。" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
                return;
            }
            
            [_manager addHomeWithName:@"我的家" completionHandler:^(NSError * _Nullable error) {
                if(!error || error.code == 32){
                    [weakSelf setupCurrentHome];
                }
            }];
            
            
        }];
        
    }
    else{
        CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
        
        CGPoint point = CGPointMake(self.view.bounds.size.width - 30, StatusRect.size.height == 44?84:64);
        [YBPopupMenu showAtPoint:point titles:_arrControlMenuItem icons:nil menuWidth:120 delegate:self];
    }
    
    
}

- (IBAction)actionForPickArea:(id)sender {
    
    HomeKit_AreaPickerViewController *vcAreaPicker = (HomeKit_AreaPickerViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"AreaPickerViewController"];
    vcAreaPicker.delegate = self;
    vcAreaPicker.city = _currentCity;
    vcAreaPicker.area = _currentArea;
    vcAreaPicker.homeID = [_manager.currentHome.uniqueIdentifier UUIDString].length == 0 ? kDefaultHomeID : [_manager.currentHome.uniqueIdentifier UUIDString];
    vcAreaPicker.customerAreaStationInfo = _customerAreaStationInfo;
    
    [self.navigationController pushViewController:vcAreaPicker animated:YES];
}

#pragma mark - HomeKit_MainTableViewCellDelegate
- (void)loginWithDeviceSerial:(NSString *)pSerial
{
    NSLog(@"...............................serial : %@", pSerial);
    [[AuthWechatManager shareInstance] auth: self];
    
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    NSLog(@"点击了 %@ 选项",_arrControlMenuItem[index]);
    if(!_manager.currentHome){
        [self showDropdownViewWithMessage:@"请创建或选择一个Home"];
        return;
    }
    if(index == 0){
        HomeKit_RoomSettingViewController *vcRoomSetting = (HomeKit_RoomSettingViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"RoomSettingViewController"];
        vcRoomSetting.enterType = EnterTypeManager;
        
        NSMutableArray *maAC = [NSMutableArray array];
        [_maDevices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *mdDevice = obj;
            HMAccessory *ac = [mdDevice objectForKey:kPurifier];
            [maAC addObject:ac];
        }];
        
        vcRoomSetting.maDevices = maAC;
        [self.navigationController pushViewController:vcRoomSetting animated:YES];
    }
    if(index == 1){
        
        [_manager.currentHome manageUsersWithCompletionHandler:^(NSError * _Nullable error) {
            if(error)
            [self showDropdownViewWithMessage:[NSString stringWithFormat:@"%@ %@", error.localizedDescription, error.localizedFailureReason]];
        }];

    }
    
}

- (void)setupCurrentHome{
     _manager.currentHome = _manager.homeManager.homes[0];
    [self refresh];
    
    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    
    CGPoint point = CGPointMake(self.view.bounds.size.width - 30, StatusRect.size.height == 44?84:64);
    [YBPopupMenu showAtPoint:point titles:_arrControlMenuItem icons:nil menuWidth:120 delegate:self];
}

- (void)setupToAddNewDevice{
    _manager.currentHome = _manager.homeManager.homes[0];
    [self refresh];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [_manager.currentHome addAndSetupAccessoriesWithCompletionHandler:^(NSError * _Nullable error) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

#pragma mark - HomeBottomBar delegate
- (void)ActionWithType:(ActionTo)pActionType
{
    MLWeakSelf weakSelf = self;
    switch (pActionType) {
        case ActionToContactToUS:
        {
            
            if (@available(iOS 11, *)) {
                if(_checkPermissioning){
                    return;
                }
                
                if(_manager.homeManager.homes.count == 0){
                    
                    _checkPermissioning = YES;
                    [_manager checkPermissionStatusWithCompletionHandler:^(BOOL hasPermission) {
                        _checkPermissioning = NO;
                        if(!hasPermission){
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法添加"
                                                                                                     message:@"请在iPhone的“设置-隐私-HomeKit”选项中，允许空气堡访问。" preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
                            [alertController addAction:cancelAction];
                            [self presentViewController:alertController animated:YES completion:nil];
                            
                            return;
                        }
                        
                        [_manager addHomeWithName:@"我的家" completionHandler:^(NSError * _Nullable error) {
                            if(!error || error.code == 32){
                                [weakSelf setupToAddNewDevice];
                            }
                        }];
                        
                        
                    }];
                    
                }
                else{
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                    [_manager.currentHome addAndSetupAccessoriesWithCompletionHandler:^(NSError * _Nullable error) {
                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                        if(error == nil){
                            [weakSelf enableNotificationForHome];
                        }
                        
                    }];
                }
            }
            else{
                [self showDropdownViewWithMessage:@"添加设备需要iOS11及以上版本支持"];
                return;
            }
            
            
            break;
        }
        case ActionToSetToWIFI:
        {
            if(![[NSUserDefaults standardUserDefaults] valueForKey:kWechatUserJsonKey]){
                [[AuthWechatManager shareInstance] auth: self];
            }
            break;
        }
        case ActionToShare:
        {
            HomeKit_HelpViewController *vcHelp = (HomeKit_HelpViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"HelpViewController"];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vcHelp];
            
            [self presentViewController:nc animated:YES completion:^{}];
            NSLog(@"ActionToShare");
            
            break;
        }
    }
}

- (void)addDeviceToHomeWithAccessory:(HMAccessory *)pAccessory
{
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _maDevices.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HomeKit_MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell"];
    
    if (!cell) {
        cell = (HomeKit_MainTableViewCell *)[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainTableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.mainTableViewCellDelegate = self;
    HMAccessory *accessory = (HMAccessory *)[[_maDevices objectAtIndex:indexPath.row] objectForKey:kPurifier];
    
    NSMutableDictionary *device = [_maDevices objectAtIndex:indexPath.row];
    
    NSString *deviceName = [NSString stringWithFormat:@"%@%@",[[device objectForKey:kPurifierName] ml_stringValue],accessory.reachable?@"":@""];
    cell.lblDeviceName.text = deviceName;
    cell.owner = [_manager checkCurrrentUserIsAdmin];
    
    cell.vcMain = self;
    HMCharacteristic *chaSerial = (HMCharacteristic *)[device objectForKey:kPurifierSerialNumber];
    NSString *serialNumber = [chaSerial.value ml_stringValue];
    
    //for serial is empty
    if(serialNumber && ![[NSUserDefaults standardUserDefaults] valueForKey:deviceName]){
        [[NSUserDefaults standardUserDefaults] setValue:serialNumber forKey:deviceName];
    }
    if([[NSUserDefaults standardUserDefaults] valueForKey:deviceName] && !serialNumber){
        serialNumber = [[NSUserDefaults standardUserDefaults] valueForKey:deviceName];
    }
    
    
    cell.serialNumber = serialNumber;//[@"AIRBURG-NEX360A-8F1F" isEqualToString:deviceName]? @"0403201804200101":serialNumber; //@"0403201804200101";//serialNumber;//
    cell.reachable = accessory.reachable;
    cell.mdDevice = device;
    
    
    
     
     NSString *log = [NSString stringWithFormat:@"%@ \n reachable: %@; \n serial: %@", deviceName, cell.reachable?@"True":@"False", serialNumber];
     
     kDebugLog(log);
     
     if(kIsDebug){
     _tvlog.text = [NSString stringWithFormat:@"%@ \n-------------------------------------\n %@", _tvlog.text, log];
     if([HomeKit_UserService sharedInstance].user){
     _tvlog.text = [NSString stringWithFormat:@"%@ \n OpenID: %@ \n UnionID:%@", _tvlog.text, [HomeKit_UserService sharedInstance].user.openid, [HomeKit_UserService sharedInstance].user.unionid];
     }
     [_tvlog scrollRectToVisible:CGRectMake(0, _tvlog.contentSize.height-15, _tvlog.contentSize.width, 10) animated:YES];
     
     
     }
    
    
    [cell updateDeviceWithNetworkStatus:_status
                              reachable:cell.reachable
                                 serial:serialNumber
                          homeKitDevice:device];
    
    [cell hiddenCloudWithOwner:cell.owner];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HomeKit_MainTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell.lblOfflineAlert.hidden){
        return;
    }
    
    if(!cell.deviceIsOnLine){
        return;
    }
    
    if(cell.fromHomeKit){
        HomeKit_DetailViewController *vcDetail = (HomeKit_DetailViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"DetailViewController"];
        vcDetail.device = [_maDevices objectAtIndex:indexPath.row];
        vcDetail.city = _currentCity;
        vcDetail.outdoorValue = _outdoorValue;
        [HomeKit_UserService sharedInstance].city = _currentCity;
        [self.navigationController pushViewController:vcDetail animated:YES];
        
        
    }
    else{
        if(!cell.XLinkDevice){
            return;
        }
        HomeKit_DetailXLinkViewController *vcDetailXLink = (HomeKit_DetailXLinkViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"HomeKit_DetailXLinkViewController"];
        vcDetailXLink.XLinkDevice = cell.XLinkDevice;
        vcDetailXLink.city = _currentCity;
        vcDetailXLink.outdoorValue = _outdoorValue;
        [HomeKit_UserService sharedInstance].city = _currentCity;
        [self.navigationController pushViewController:vcDetailXLink animated:YES];
    }
    
//    [self stopAutoFetch];
    
}

#pragma mark - fetch location
- (void)FetchLocation
{
    NSDictionary *dicLocalLocation = [[HomeKit_DeviceService sharedInstance] fetchLocalSavedLocationWithHomeID:[_manager.currentHome.uniqueIdentifier UUIDString].length == 0 ? kDefaultHomeID : [_manager.currentHome.uniqueIdentifier UUIDString]];
    
    if(CheckNilAndNull(dicLocalLocation) || [dicLocalLocation[kCityNameKey] ml_stringValue].length == 0){
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate fetchLocationWithCompletionBlock:^(NSString *pAddress, LocationAccessErrorType error) {
            
            switch (error) {
                case LocationAccessErrorTypeNormall:
                {
                    pAddress = [pAddress stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                    [_btnLocation setTitle:pAddress forState:UIControlStateNormal];
                    [self resetLocationButtonWithTitle:pAddress];
                    HomeKit_WatchInfoOutdoorRequest *outdoor = [[HomeKit_WatchInfoOutdoorRequest alloc] initWithCityName:[pAddress stringByReplacingOccurrencesOfString:@"市" withString:@""] stationCode:@"" stationName:@""];
                    
                    [[HomeKit_DeviceService sharedInstance] saveLocationWithCityName:outdoor.cityName
                                                                 stationName:@""
                                                                 stationCode:@""
                                                                      homeID:[_manager.currentHome.uniqueIdentifier UUIDString].length == 0 ? kDefaultHomeID : [_manager.currentHome.uniqueIdentifier UUIDString]];
                    
                    [self updateOutdoorInfoWithWatchInfoOutdoorRequest:outdoor];
                    
                    break;
                }
                default:
                {
                    _cPinIconLeft.constant = 0;
                    _cPinIconWidth.constant = 0;
                    _cLocationNameLeft.constant = 0;
                    _cLocationNameWidth.constant = 0;
                    [self showDropdownViewWithLocationAccessErrorType:error];
                    break;
                }
            }
        }];
    }
    else{
        NSMutableString *pAddress = [NSMutableString string];
        if([dicLocalLocation[kCityNameKey] ml_stringValue].length != 0){
            [pAddress appendString:[dicLocalLocation[kCityNameKey] ml_stringValue]];
        }
        if([dicLocalLocation[kStationNameKey] ml_stringValue].length != 0){
            [pAddress appendString:@" "];
            [pAddress appendString:[dicLocalLocation[kStationNameKey] ml_stringValue]];
        }
        [_btnLocation setTitle:pAddress forState:UIControlStateNormal];
        [self resetLocationButtonWithTitle:pAddress];
        
        
        HomeKit_WatchInfoOutdoorRequest *outdoor = [[HomeKit_WatchInfoOutdoorRequest alloc] initWithCityName:[dicLocalLocation[kCityNameKey] ml_stringValue] stationCode:[dicLocalLocation[kStationCodeKey] ml_stringValue] stationName:[dicLocalLocation[kStationNameKey] ml_stringValue]];
        [self updateOutdoorInfoWithWatchInfoOutdoorRequest:outdoor];
    }
    
}

- (void)resetLocationButtonWithTitle:(NSString *)pTitle
{
    
    NSInteger width = [pTitle mp_widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14] height:20] + 5;
    if(width > 160){
        width = 160;
    }
    _cLocationNameWidth.constant = width;
}

- (void)updateOutdoorInfoWithWatchInfoOutdoorRequest:(HomeKit_WatchInfoOutdoorRequest *)pRequest
{
    MLWeakSelf weakSelf = self;
    [HomeKit_UserService sharedInstance].city = pRequest.cityName;
    [[HomeKit_DeviceService sharedInstance] searchOutdoorPMInfoWithRequest:pRequest completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
        HomeKit_WatchInfoOutdoorResponse *response = (HomeKit_WatchInfoOutdoorResponse *)pServiceResponse;
        response.watchInfoOutdoor.deviceArea = pRequest.cityName;
        response.watchInfoOutdoor.positionName = pRequest.stationName;
        
        [weakSelf handleCompletionForWatchInfoOutdoorWithServiceResponse:(HomeKit_WatchInfoOutdoorResponse *)pServiceResponse];
    }];
}

- (void)handleCompletionForWatchInfoOutdoorWithServiceResponse:(HomeKit_WatchInfoOutdoorResponse *)pWatchInfoOutdoorResponse
{
    NSInteger pm = pWatchInfoOutdoorResponse.watchInfoOutdoor.aqi;
    
    
    
    NSMutableAttributedString *masPM25 = [[NSMutableAttributedString alloc] init];
    [masPM25 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %ld", (long)pm] attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size:48]}]];
    [masPM25 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"AQI" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size:18]}]];
    
    
    
    _outdoorValue = pWatchInfoOutdoorResponse.watchInfoOutdoor.value;
    NSString *airQuality = [[HomeKit_DeviceService sharedInstance] airQualityDescriptionWithValue:pm];
    if(pWatchInfoOutdoorResponse.watchInfoOutdoor == nil){
//        _lblPMDensity.text = [NSString stringWithFormat:@"PM2.5: %@ μg/m³", @"--"];
//        _lblPM25Count.text = @"--";
//        airQuality = @"--";
    }
    else{
        _lblPMDensity.text = [NSString stringWithFormat:@"PM2.5: %ld μg/m³", (long)_outdoorValue];
        _lblPM25Count.attributedText = masPM25;
    }
    
    
    
    //date
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM月dd日"];
    NSString *stringDate = [df stringFromDate:[NSDate date]];
    _lblDate.text = stringDate;
    
    //give property to vcAreaPicker
    HomeKit_CustomerAreaStationInfo *watchInfoOutdoor = [pWatchInfoOutdoorResponse.watchInfoOutdoor toCustomerAreaStationInfo];
    _customerAreaStationInfo = watchInfoOutdoor;
    _currentCity = _customerAreaStationInfo.area;
    _currentArea = _customerAreaStationInfo.positionName;
    
    [_viewPMDescription updatePMDescriptionWithPMValue:pm description:airQuality];

}



#pragma mark - loading...
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self calculateFrameWithOffY:_tvDevice.contentOffset.y];
}

- (void)calculateFrameWithOffY:(CGFloat)offy {
    
    if(offy > 0){
        return;
    }
    
    CGFloat upDistance = fabs(offy);
    
    if(upDistance < 50){
        return;
    }
    
    if(!_btnRefresh.rotating){
        float angle = 0;
        [_btnRefresh rotateWithAngle:angle];
        
        if (upDistance <= 100) {
            angle = (upDistance*M_PI*2 / 100) * 0.1;
            [_btnRefresh rotateWithAngle:angle];
            
        } else {
            [self refresh];
        }
        
    }
    
}


- (IBAction)actionForRefresh:(id)sender {
    [_btnRefresh rotate];
    [self refresh];
}

- (void)refresh
{
    [_btnRefresh start];
    [_manager getHomesNotify];
    [_tvDevice reloadData];
}

#pragma mark - auto refresh
- (void)startFetch
{
    if(!_timerDevices)
    _timerDevices = [NSTimer scheduledTimerWithTimeInterval:kTimerInteval
                                                     target:self
                                                   selector:@selector(refresh)
                                                   userInfo:nil
                                                    repeats:YES];
}
- (void)stopAutoFetch
{
    if (_timerDevices != nil) {
        [_timerDevices invalidate];
        _timerDevices = nil;
    }

    _isDownloading = NO;
}

#pragma mark - PMDescriptionViewDelegate
- (void)updateConstraint:(float)pWidth
{
    _cViewPM25DescriptionWidth.constant = pWidth;
}

#pragma mark - AreaPickerViewControllerDelegate
- (void)updateLocation:(HomeKit_CustomerAreaStationInfo *)pCustomerAreaStationInfo
{
    [self FetchLocation];
}

#pragma mark - AccessoriesManager Delegate
- (void)accessoryManagerUpdateDevices:(NSMutableArray *_Nullable)pDevices
{
    [_btnRefresh stop];
    
    
    _maDevices = pDevices;
    
    NSMutableArray *maTmp = [NSMutableArray array];
    if(self.comeFrom == ComeFromRoom){
        [_maDevices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HMAccessory *accessory = [obj objectForKey:kPurifier];
            
            if([[accessory.room.uniqueIdentifier UUIDString] isEqualToString:[self.room.uniqueIdentifier UUIDString]]){
                [maTmp addObject:obj];
            }
        }];
        _maDevices = maTmp;
    }
    
    if(_enabled == NO){
        
        [self enableNotificationForHome];
        
    }
    
    [_tvDevice reloadData];
    
    [self initUI];
}

- (void)enableNotificationForHome
{
    [_maDevices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *mdAccessory = obj;
        [_manager enableNotificationWithDevice:mdAccessory];
        _enabled = YES;
    }];
}

#pragma mark - accessory manager delegate
- (void)accessoryDidUpdateStatus:(HMAccessory *_Nullable)pAccessory
{
   
}

- (void)accessory:(HMAccessory *_Nullable)pAccessory didAdded:(NSError *_Nullable)pError;
{
    
    if(pError){
        if(_HUD != nil){
            [_HUD dismiss];
            _HUD = nil;
        }
        [self showDropdownViewWithMessage:@"添加设备错误，请重试！"];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        return;
    }
    
    if(pAccessory){
        [self performSelector:@selector(openSetToServices:) withObject:pAccessory afterDelay:3];
    }
    else{
        if(_HUD != nil){
            [_HUD dismiss];
            _HUD = nil;
        }
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (void)openSetToServices:(HMAccessory *_Nullable)pAccessory
{
    
    [HomeKit_DeviceService sharedInstance].indexRoom = 0;
    [HomeKit_DeviceService sharedInstance].indexService = 0;
    
    __block NSMutableArray *maService = [NSMutableArray array];
    [pAccessory.services enumerateObjectsUsingBlock:^(HMService * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HMService *service = obj;
        if(service.isUserInteractive && ![service.name isEqualToString:@"屏幕亮度"]){
            [maService addObject:service];
        }
    }];
    [HomeKit_DeviceService sharedInstance].services = maService;
    
    HMHome *home = [HomeKit_AccessoryManager sharedInstance].currentHome;
    [HomeKit_DeviceService sharedInstance].rooms = [NSMutableArray arrayWithArray:home.rooms];
    [[HomeKit_DeviceService sharedInstance].rooms insertObject:kDefaultRoomName atIndex:0];
    
    HomeKit_ConfigServiceViewController *vcConfigService = (HomeKit_ConfigServiceViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"ConfigServiceViewController"];
    vcConfigService.accessory = pAccessory;
    vcConfigService.selected = 0;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vcConfigService];
    [self.navigationController presentViewController:nc animated:YES completion:^{
        
        if(_HUD != nil){
            [_HUD dismiss];
            _HUD = nil;
        }
        
        
        
    }];
}

#pragma mark - check upgrade for devices
- (void)checkUpgradeForDevice
{
    
    if(![HomeKit_DeviceService sharedInstance].maDidCheckedUpgrade){
        [HomeKit_DeviceService sharedInstance].maDidCheckedUpgrade = [NSMutableArray array];
    }
    
    if(![[HomeKit_DeviceService sharedInstance].maDidCheckedUpgrade containsObject:[_manager.currentHome.uniqueIdentifier UUIDString]]){
        [[HomeKit_DeviceService sharedInstance].maDidCheckedUpgrade addObject:[_manager.currentHome.uniqueIdentifier UUIDString]];
    }
    else{
        return;
    }
    
    for(NSDictionary *dic in _maDevices){
        HMCharacteristic *cha = [dic objectForKey:kPurifieStartUpgrade];
        if(cha){
            [_manager updateCharacteristic:cha value:1 completionHandler:^(NSError * _Nullable error) {
                
            }];
        }
    }
    
}

#pragma mark - public methods
- (void)readValue
{
    [[HomeKit_AccessoryManager sharedInstance] readValueWithAccessories:_maDevices];
    [[HomeKit_DeviceStatusRoler sharedInstance] cleanDevices];
    [self refresh];
    [self startFetch];
}

/**
 实时检查当前网络状态
 */
- (void)addReachabilityManager {
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afNetworkStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];//这个可以放在需要侦听的页面
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"网络不通：%@",@(status) );
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"网络通过WIFI连接：%@",@(status));
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"网络通过无线连接：%@",@(status) );
                break;
            }
            default:
                break;
        }
        _status = status;
        [self enableNotificationForHome];
    }];
    
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
}


#pragma mark - splash image adver
- (void)addSplash
{
    [HomeKit_ADService sharedInstance].luanchAdverShown = YES;
    self.imageView.alpha = 0;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:self.imageView];
    [UIView animateWithDuration:0 animations:^{
        self.imageView.alpha = 1;
    }];
    
    CGFloat y = iPhone4S? 20.0:(iPhone5S? 22:(iPhone6? 25:28));
    CGFloat width = iPhone4S? 30.0:(iPhone5S? 35:(iPhone6? 37:40));
    
    DrawCircleProgressButton *drawCircleView = [[DrawCircleProgressButton alloc] initWithFrame:CGRectMake(Screen_width - y - 30, y, width, width)];
    drawCircleView.lineWidth = 2;
    [drawCircleView setTitle:@"跳过" forState:UIControlStateNormal];
    [drawCircleView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    drawCircleView.titleLabel.font = [UIFont systemFontOfSize:14];
    drawCircleView.tag = 990;
    [drawCircleView addTarget:self action:@selector(removeProgress) forControlEvents:UIControlEventTouchUpInside];
    
    //回调
    __weak HomeKit_MainViewController *weakSelf = self;
    [drawCircleView startAnimationDuration:3 withBlock:^{
        [weakSelf removeProgress];
    }];
    
    [appDelegate.window addSubview:drawCircleView];
    
}

- (void)removeProgress
{
    _splashADToBeRemoved = YES;
    self.imageView.transform = CGAffineTransformMakeScale(1, 1);
    self.imageView.alpha = 1;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[appDelegate.window viewWithTag:990] removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.alpha = 0.01;
        self.imageView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        [self.imageView removeFromSuperview];
    }];
    
    [[HomeKit_ADService sharedInstance] retrieveSplashAdvertisementWithDetailDeviceType:[self screenType] completionBlock:^(HomeKit_SplashAD *result, HttpStatusType httpStatusType) {}];
}

- (iOSScreenType)screenType
{
    
    iOSScreenType result = iOSScreenType4S;
    
    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        result = iOSScreenTypePad;
    }
    else if(StatusRect.size.height == 44){
        result = iOSScreenTypeX;
    }
    else if(iPhone4S){
        result = iOSScreenType4S;
    }
    else if(iPhone5S){
        result = iOSScreenType5;
    }
    else if(iPhone6){
        result = iOSScreenType47;
    }
    else{
        result = iOSScreenTypePlus;
    }
    
    return result;
}

- (UIImageView *)imageView
{
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
        HomeKit_SplashAD *splashAD = [[HomeKit_ADService sharedInstance] checkSplashAD];
        UIImage *img = [UIImage imageWithContentsOfFile:DocumentsPath(splashAD.key)];
        _imageView.image = img;
        
        if(splashAD.link){
            _imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *grTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkToAd)];
            [_imageView addGestureRecognizer:grTap];
        }
    }
    return _imageView;
}

- (void)linkToAd
{
    
    HomeKit_SplashAD *splashAD = [[HomeKit_ADService sharedInstance] checkSplashAD];
    [[UIApplication sharedApplication] openURL:splashAD.link];
}

- (void)checkFlashADStatus
{
    if(!_splashADToBeRemoved){
        [self removeProgress];
    }
}

@end
