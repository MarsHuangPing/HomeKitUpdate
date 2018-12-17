//
//  DeviceListViewController.m
//  FreshAir
//
//  Created by mars on 12/12/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_DeviceListViewController.h"


#import "HomeKit_DetailViewController.h"
#import "HomeKit_SearchDeviceViewController.h"
#import "HomeKit_UnConfigrationViewController.h"
#import "HomeKit_BaseNavigationController.h"
#import "HomeKit_RoomSettingViewController.h"
#import "HomeKit_DetailXLinkViewController.h"

#import "AppDelegate.h"
#import "HomeKit_CommonAPI.h"
#import "HomeKit_HomeBottomBar.h"
#import "HomeKit_MainTableViewCell.h"
#import "HomeKit_ColorManager.h"
#import "NSString+MP.h"
#import "NSObject+ML.h"

#import "HomeKit_DeviceService.h"
#import "HomeKit_DeviceResponse.h"
#import "HomeKit_Device.h"

#import "YRDropdownView.h"
#import "RefreshButton.h"

#import "HomeKit_UserService.h"
#import "HomeKit_User.h"

#import "HomeKit_DevicesRequest.h"
#import "HomeKit_DevicesResponse.h"

#import "HomeKit_PMDescriptionView.h"
#import "YBPopupMenu.h"

#import "HomeKit_WatchInfoOutdoorRequest.h"
#import "HomeKit_AreaPickerViewController.h"
#import "HomeKit_WatchInfoOutdoorResponse.h"
#import "HomeKit_WatchInfoOutdoor.h"
#import "HomeKit_CustomerAreaStationInfo.h"

#import "HomeKit_PMDescriptionView.h"

#import "HomeKit_DeviceStatusRoler.h"

@interface HomeKit_DeviceListViewController ()<AccessoryManagerDelegate, UITableViewDelegate, UITableViewDataSource, PMDescriptionViewDelegate, AreaPickerViewControllerDelegate>
{
    __weak IBOutlet UIView *_viewHeader;
    __weak IBOutlet UIView *_viewBannerBg;
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
    BOOL _isDownloading;
    
    HomeKit_AccessoryManager *_manager;
    
    //outdoor info
    HomeKit_CustomerAreaStationInfo *_customerAreaStationInfo;
    NSString *_currentCity;
    NSString *_currentArea;
    NSInteger _outdoorValue;
}
@end

@implementation HomeKit_DeviceListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _viewPMDescription.delegate = self;
    
    _tvDevice.backgroundColor = [[HomeKit_ColorManager sharedInstance] mainBgLightGray];
    _viewHeader.backgroundColor = [[HomeKit_ColorManager sharedInstance] mainBgLightGray];
    
    _viewBannerBg.backgroundColor = [[HomeKit_ColorManager sharedInstance] colorTopBarAndBanner];
    _tvDevice.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self refresh];
    
    
    [self initUI];
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _manager = [HomeKit_AccessoryManager sharedInstance];
    _manager.delegate = self;
    
    [self FetchLocation];
    
    [self refresh];
    [self startFetch];
}

#pragma mark - init UI
- (void)initUI{
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.title = self.room.name.length == 0 ? kDefaultRoomName:self.room.name;
}

#pragma mark - actions
- (IBAction)actionForPickArea:(id)sender {
    
    HomeKit_AreaPickerViewController *vcAreaPicker = (HomeKit_AreaPickerViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"AreaPickerViewController"];
    vcAreaPicker.delegate = self;
    vcAreaPicker.city = _currentCity;
    vcAreaPicker.area = _currentArea;
    vcAreaPicker.customerAreaStationInfo = _customerAreaStationInfo;
    vcAreaPicker.homeID = [_manager.currentHome.uniqueIdentifier UUIDString];
    [self.navigationController pushViewController:vcAreaPicker animated:YES];
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

#pragma mark - HomeBottomBar delegate
- (void)ActionWithType:(ActionTo)pActionType
{
    switch (pActionType) {
        case ActionToContactToUS:
        {
            
            NSLog(@"ActionToContactToUS");
            
            
            HomeKit_SearchDeviceViewController *vcSearch = (HomeKit_SearchDeviceViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"SearchDeviceViewController"];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vcSearch];
            
            [self presentViewController:nc animated:YES completion:^{}];
            break;
        }
        case ActionToSetToWIFI:
        {
            HomeKit_UnConfigrationViewController *vcUnconfigration = (HomeKit_UnConfigrationViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"UnConfigrationViewController"];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vcUnconfigration];
            
            [self presentViewController:nc animated:YES completion:^{}];
            //UnConfigrationViewController
            NSLog(@"ActionToSetToWIFI");
            break;
        }
        case ActionToShare:
        {
            NSLog(@"ActionToShare");
            
            break;
        }
    }
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
    
    
//    HomeKit_MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell"];
//
//    if (!cell) {
//        cell = (HomeKit_MainTableViewCell *)[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainTableViewCell"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//
//    HMAccessory *accessory = (HMAccessory *)[[_maDevices objectAtIndex:indexPath.row] objectForKey:kPurifier];
//
//    NSMutableDictionary *device = [_maDevices objectAtIndex:indexPath.row];
//
//    cell.lblDeviceName.text = [NSString stringWithFormat:@"%@%@",[[device objectForKey:kPurifierName] ml_stringValue],accessory.reachable?@"":@""];
//
//
//    if(!accessory.reachable){
//
//        cell.lblOfflineAlert.hidden = NO;
//        cell.lblOfflineAlert.text = @"设备离线";
//
//        cell.pm25Value = 0;
//
//        cell.lblHot.text = @"-";
//
//        cell.lblPMUnit.hidden = YES;
//        cell.lblPMValue.hidden = YES;
//
//
//        cell.lblHumidityValue.text =@"-";
//        cell.lblCo2Value.text = @"-";
//        cell.lblTemperatureValue.text = @"-°";
//        cell.lblWindQuantityValue.text = [NSString stringWithFormat:@"%@%@", @"-", @"%"];
//        cell.lblEnviromentIndex.text = [NSString stringWithFormat:@"%@ 环境指数", ((HMAccessory *)[device objectForKey:kPurifier]).room.name];
//
//
//
//    }
//    else{
//        cell.lblOfflineAlert.hidden = YES;
//
//
//        if([((HMCharacteristic *)[device objectForKey:kPurifieHeaterEnable]).value ml_intValue] == 1){
//            cell.lblHot.text = @"on";
//            cell.ivHotIcon.image = [UIImage imageNamed:@"hot_icon_on"];
//        }
//        else{
//            cell.ivHotIcon.image = [UIImage imageNamed:@"hot_icon_off"];
//            cell.lblHot.text = @"off";
//        }
//
//        cell.lblPMUnit.hidden = NO;
//        cell.lblPMValue.hidden = NO;
//        cell.lblPMValue.text = [NSString stringWithFormat:@"%d", [((HMCharacteristic *)[device objectForKey:kPurifiePM25]).value ml_intValue]];
//        cell.pm25Value = [((HMCharacteristic *)[device objectForKey:kPurifiePM25]).value ml_intValue];
//
//        cell.lblHumidityValue.text = [NSString stringWithFormat:@"%d", [((HMCharacteristic *)[device objectForKey:kPurifieCurrentHumidity]).value ml_intValue]];
//        cell.lblCo2Value.text = [NSString stringWithFormat:@"%d", [((HMCharacteristic *)[device objectForKey:kPurifieCo2Density]).value ml_intValue]];
//        cell.lblTemperatureValue.text = [NSString stringWithFormat:@"%d", [((HMCharacteristic *)[device objectForKey:kPurifieCurrentTemperature]).value ml_intValue]];
//
//        NSInteger wind = [((HMCharacteristic *)[device objectForKey:kPurifieSpeed]).value ml_intValue];
//        if(wind == 0){
//            cell.lblWindQuantityValue.text = [NSString stringWithFormat:@"%@", @"off"];
//        }
//        else{
//            cell.lblWindQuantityValue.text = [NSString stringWithFormat:@"%ld%@", (long)wind, @"%"];
//        }
//
//        cell.lblEnviromentIndex.text = [NSString stringWithFormat:@"%@ 环境指数", ((HMAccessory *)[device objectForKey:kPurifier]).room.name];
//
//    }
    
    HomeKit_MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell"];
    
    if (!cell) {
        cell = (HomeKit_MainTableViewCell *)[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainTableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    HMAccessory *accessory = (HMAccessory *)[[_maDevices objectAtIndex:indexPath.row] objectForKey:kPurifier];
    
    NSMutableDictionary *device = [_maDevices objectAtIndex:indexPath.row];
    
    NSString *deviceName = [NSString stringWithFormat:@"%@%@",[[device objectForKey:kPurifierName] ml_stringValue],accessory.reachable?@"":@""];
    cell.lblDeviceName.text = deviceName;
    cell.owner = [_manager checkCurrrentUserIsAdmin];
    
    
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
    
    
    NSString *log = [NSString stringWithFormat:@"%@ - reachable:%@", deviceName, cell.reachable?@"True":@"False"];
    kDebugLog(log);
    
    
    
    if(cell.reachable){
//        [cell fillValueWithFromHomeKit:YES];
    }
    
    
    [cell hiddenCloudWithOwner:cell.owner];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    HMAccessory *accessory = (HMAccessory *)[[_maDevices objectAtIndex:indexPath.row] objectForKey:kPurifier];
//    if(!accessory.reachable){
//        [self showDropdownViewWithMessage:@"设备不可用，检查设备！"];
//        return;
//    }
    
//    HomeKit_MainTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if(!cell.lblOfflineAlert.hidden){
//        return;
//    }
//
//    HomeKit_DetailViewController *vcDetail = (HomeKit_DetailViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"DetailViewController"];
//    vcDetail.device = [_maDevices objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:vcDetail animated:YES];
//
//    [self stopAutoFetch];
    
    
    HomeKit_MainTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell.lblOfflineAlert.hidden){
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
        HomeKit_DetailXLinkViewController *vcDetailXLink = (HomeKit_DetailXLinkViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"HomeKit_DetailXLinkViewController"];
        vcDetailXLink.XLinkDevice = cell.XLinkDevice;
        vcDetailXLink.city = _currentCity;
        vcDetailXLink.outdoorValue = _outdoorValue;
        [HomeKit_UserService sharedInstance].city = _currentCity;
        [self.navigationController pushViewController:vcDetailXLink animated:YES];
    }
    
}

#pragma mark - fetch location
- (void)FetchLocation
{
    NSDictionary *dicLocalLocation = [[HomeKit_DeviceService sharedInstance] fetchLocalSavedLocationWithHomeID:[_manager.currentHome.uniqueIdentifier UUIDString]];
    
    if(CheckNilAndNull(dicLocalLocation)){
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate fetchLocationWithCompletionBlock:^(NSString *pAddress, LocationAccessErrorType error) {
            
            switch (error) {
                case LocationAccessErrorTypeNormall:
                {
                    pAddress = [pAddress stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                    [_btnLocation setTitle:pAddress forState:UIControlStateNormal];
                    [self resetLocationButtonWithTitle:pAddress];
                    HomeKit_WatchInfoOutdoorRequest *outdoor = [[HomeKit_WatchInfoOutdoorRequest alloc] initWithCityName:[pAddress stringByReplacingOccurrencesOfString:@"市" withString:@""] stationCode:@"" stationName:@""];
                    
                    [[HomeKit_DeviceService sharedInstance] saveLocationWithCityName:outdoor.cityName stationName:@"" stationCode:@"" homeID:[_manager.currentHome.uniqueIdentifier UUIDString]];
                    
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
    [masPM25 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %ld", pm] attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size:48]}]];
    [masPM25 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"AQI" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size:18]}]];
    
    _lblPM25Count.attributedText = masPM25;
    
    _outdoorValue = pWatchInfoOutdoorResponse.watchInfoOutdoor.value;
    _lblPMDensity.text = [NSString stringWithFormat:@"PM2.5: %ld μg/m³", _outdoorValue];
    
    NSString *airQuality = [[HomeKit_DeviceService sharedInstance] airQualityDescriptionWithValue:pm];
    
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
    [self refresh];
}

- (void)refresh
{
    [_btnRefresh start];
    [_manager getHomesNotify];
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



#pragma mark - AccessoriesManager Delegate
- (void)accessoryManagerUpdateDevices:(NSMutableArray *_Nullable)pDevices
{
    [_btnRefresh stop];
    
    
    
    _maDevices = pDevices;
    NSMutableArray *maTmp = [NSMutableArray array];
    [_maDevices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HMAccessory *accessory = [obj objectForKey:kPurifier];
        
        if(self.room){
            if([[accessory.room.uniqueIdentifier UUIDString] isEqualToString:[self.room.uniqueIdentifier UUIDString]]){
                [maTmp addObject:obj];
            }
        }
        else {
            
//          get devices of default room
            __block BOOL isDefaultRoomDevice = YES;
            [_manager.currentHome.rooms enumerateObjectsUsingBlock:^(HMRoom * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj.name isEqualToString:accessory.room.name]){
                    isDefaultRoomDevice = NO;
                    *stop = YES;
                }
            }];
            if(isDefaultRoomDevice){
                [maTmp addObject:obj];
            }
        }
    }];
    _maDevices = maTmp;
    
    
    [_tvDevice reloadData];
    
    if(_maDevices.count == 0){
        
    }
    else{
        NSString *message = nil;
        for(NSMutableDictionary *device in pDevices){
            message = [device objectForKey:kPurifieErrorMessage];
            if(message != nil){
                
                break;
            }
        }
        if(message != nil){

        }
        else{
            
        }
    }
    
    [self initUI];
}

@end
