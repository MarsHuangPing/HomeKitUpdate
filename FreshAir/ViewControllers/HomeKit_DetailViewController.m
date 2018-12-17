//
//  ViewController.m
//  FreshAir
//
//  Created by mars on 08/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//


#define kMenuTop1 125
#define kMenuTop2 458

#define kControlPanelTop1 171
#define kControlPanelTop2 504

#define kFooterPanelHeight1 531
#define kFooterPanelHeight2 800



#import "HomeKit_DetailViewController.h"
#import "HomeKit_AboutViewController.h"
#import "HomeKit_RoomSettingViewController.h"
#import "HomeKit_ServiceSettingViewController.h"
#import "HomeKit_UserInfoViewController.h"

#import "HomeKit_StringResponse.h"
#import "HomeKit_User.h"
#import "HomeKit_UserService.h"

#import "AppDelegate.h"
#import "HomeKit_DemoService.h"
#import "HomeKit_BarChartView.h"
#import "HomeKit_TodayBarChartView.h"
#import "HomeKit_ParamsView.h"
#import "HomeKit_ButtonSwitch.h"
#import "RefreshButton.h"
#import "HomeKit_ButtonModeSwitch.h"
#import "HomeKit_ButtonCtrlSwitch.h"
#import "HomeKit_ButtonTurn.h"
#import "HomeKit_ColorManager.h"
#import "HomeKit_FontManager.h"
#import "NSString+MP.h"
#import "NSObject+ML.h"
#import "HomeKit_CommonAPI.h"
#import "HomeKit_DeviceService.h"
#import "HomeKit_DeviceResponse.h"
#import "HomeKit_Device.h"
#import "HomeKit_DeviceDetailInfo.h"
#import "YBPopupMenu.h"
#import "HomeKit_AccessoryManager.h"

#import "HomeKit_SDRangeSliderView.h"
#import "HomeKit_SDSingleSliderView.h"

#import "HomeKit_PMDescriptionView.h"

#import "HistoryInfoRequest.h"
#import "HistoryInfoResponse.h"
#import "historyInfo.h"


@interface HomeKit_DetailViewController ()<UITableViewDelegate, AccessoryManagerDelegate, YBPopupMenuDelegate, RoomSettingViewControllerDelegate, UITextFieldDelegate, PMDescriptionViewDelegate, SDRangeSliderViewDelegate>
{
    __weak IBOutlet UIView *_viewHeader;
    __weak IBOutlet UIView *_viewBannerBg;
    
    __weak IBOutlet UILabel *_lblLocation;
    
    __weak IBOutlet NSLayoutConstraint *_cPinIconLeft;
    __weak IBOutlet NSLayoutConstraint *_cPinIconWidth;
    __weak IBOutlet NSLayoutConstraint *_cLocationNameLeft;
    __weak IBOutlet NSLayoutConstraint *_cLocationNameWidth;
    
    __weak IBOutlet NSLayoutConstraint *_cMenuTop;
    __weak IBOutlet NSLayoutConstraint *_cModeTop;
    __weak IBOutlet NSLayoutConstraint *_cNameTop;
    __weak IBOutlet NSLayoutConstraint *_cHotTop;
    __weak IBOutlet NSLayoutConstraint *_cWindMainTop;
    __weak IBOutlet NSLayoutConstraint *_cWindFixTop;
    __weak IBOutlet NSLayoutConstraint *_cWindCustomTop;
    __weak IBOutlet NSLayoutConstraint *_cScreenTop;
    
    __weak IBOutlet UILabel *_lblPM25Count;
    
    __weak IBOutlet HomeKit_PMDescriptionView *_viewPMDescription;
    __weak IBOutlet NSLayoutConstraint *_cViewPM25DescriptionWidth;
    
    __weak IBOutlet RefreshButton *_btnRefresh;
    
    __weak IBOutlet UIView *_viewFooterBg;
    __weak IBOutlet UITableView *_tv;
    
    __weak IBOutlet UIButton *_btnName;
    __weak IBOutlet UIButton *_btnOK;
    __weak IBOutlet UITextField *_tfName;
    __weak IBOutlet UIView *_viewNamePanel;
    
    
    __weak IBOutlet UIButton *_btnMode;
    __weak IBOutlet HomeKit_ButtonModeSwitch *_btnModeSwitch;
    
    __weak IBOutlet UIView *_viewModePanel;
    
    __weak IBOutlet UIButton *_btnHot;
    __weak IBOutlet HomeKit_ButtonSwitch *_btnHotSwitch;
    __weak IBOutlet UIView *_viewHotPanel;
    
    __weak IBOutlet UIButton *_btnWind;
    __weak IBOutlet UIView *_viewWindPanel;
    __weak IBOutlet UISlider *_sliderWind;
    __weak IBOutlet UILabel *_lblWindSpped;
    
    __weak IBOutlet UIButton *_btnSleepSwitch;
    
    __weak IBOutlet UIView *_viewWindFixPanel;
    __weak IBOutlet UIView *_viewWindCustomPanel;
    
    //wind buttons
    __weak IBOutlet HomeKit_ButtonSwitch *_btnWindEnginSwitch;
    __weak IBOutlet HomeKit_ButtonCtrlSwitch *_bcsWindIntelligence;
    __weak IBOutlet HomeKit_ButtonCtrlSwitch *_bcsWindFixed;
    __weak IBOutlet HomeKit_ButtonCtrlSwitch *_bcsWindCustom;
    __weak IBOutlet UILabel *_lblWindModeTitle;
    __weak IBOutlet HomeKit_ButtonCtrlSwitch *_bcsWindFixOK;
    __weak IBOutlet HomeKit_ButtonCtrlSwitch *_bcsWindCustomOK;
    
    //light slider
    __weak IBOutlet UIButton *_btnControlScreen;
    __weak IBOutlet UIView *_viewControlScreenPanel;
    __weak IBOutlet HomeKit_SDSingleSliderView *_rsLight;
    
    
    __weak IBOutlet UIView *_viewControlPanel;
    __weak IBOutlet UITextField *_tfInput;
    
    __weak IBOutlet HomeKit_SDRangeSliderView *_rsvCustom;
    __weak IBOutlet HomeKit_SDSingleSliderView *_rsvFix;
    
    
    
    NSInteger _selectedIndex;
    
    NSTimer *_timerDevices;
    BOOL _isDownloading;
    int _keyBoardheight;
    HomeKit_AccessoryManager *_manager;
    HMAccessory *_acc;
    NSMutableDictionary *_mdCharactestiric;
    
    NSInteger _refreshIndex;
    NSArray *_arrControlMenuItem;
    
    BOOL _needToChangeWindMode;
    
    BOOL _manulChange;
    
    NSInteger _minSettingValue;
    NSInteger _maxSettingValue;
    
    NSInteger _currentMinWind;
    NSInteger _currentMaxWind;
    
    //for updating the serial
    NSString *_deviceName;
}


@property(nonatomic,weak) IBOutlet HomeKit_ParamsView *paramsView;
@property(nonatomic,weak) IBOutlet HomeKit_BarChartView *barChartView;
@property(nonatomic,weak) IBOutlet HomeKit_TodayBarChartView *todayBarChartView;
@end

@implementation HomeKit_DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    _tv.backgroundColor = [[HomeKit_ColorManager sharedInstance] mainBgLightGray];
    _viewHeader.backgroundColor = [[HomeKit_ColorManager sharedInstance] mainBgLightGray];
    
    _viewBannerBg.backgroundColor = [[HomeKit_ColorManager sharedInstance] colorTopBarAndBanner];

    
    _tv.delegate = self;
    _viewPMDescription.delegate = self;
    _selectedIndex = 0;
    [self selected:_selectedIndex];

    _btnHot.layer.cornerRadius = 5;
    _btnName.layer.cornerRadius = 5;
    _btnWind.layer.cornerRadius = 5;
    _btnMode.layer.cornerRadius = 5;
    _btnControlScreen.layer.cornerRadius = 5;
    

    _manager = [HomeKit_AccessoryManager sharedInstance];
    _manager.delegate = self;
    
    _tfName.enabled = [_manager checkCurrrentUserIsAdmin];

    [self FetchLocation];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(setupDevice)];
    
    _tfName.tag = 1000;
    _tfName.delegate = self;
    _tfName.inputAccessoryView = _viewControlPanel;
    _tfInput.tag = 1;
    _tfInput.delegate = self;
    
    [self selected:CtrlWindButtonTagTypeIntelligence];
    
    //wind ctrl setting
    _bcsWindIntelligence.bsType = ButtonCtrlSwitchTypeWindSmall;
    _bcsWindIntelligence.bsStatus = ButtonSwitchStatusInactive;
    _bcsWindIntelligence.tag = WindButtonModeTagTypeIntelligence;
    
    _bcsWindFixed.bsType = ButtonCtrlSwitchTypeWindSmall;
    _bcsWindFixed.bsStatus = ButtonSwitchStatusInactive;
    _bcsWindFixed.tag = CtrlWindButtonTagTypeFix;
    
    _bcsWindCustom.bsType = ButtonCtrlSwitchTypeWindSmall;
    _bcsWindCustom.bsStatus = ButtonSwitchStatusInactive;
    _bcsWindCustom.tag = CtrlWindButtonTagTypeCustom;
    
    _bcsWindFixOK.bsType = ButtonCtrlSwitchTypeRenameOK;
    _bcsWindFixOK.bsStatus = ButtonSwitchStatusActive;
    _bcsWindFixOK.tag = WindButtonModeTagTypeFix;
    
    _bcsWindCustomOK.bsType = ButtonCtrlSwitchTypeRenameOK;
    _bcsWindCustomOK.bsStatus = ButtonSwitchStatusActive;
    _bcsWindCustomOK.tag = WindButtonModeTagTypeCustom;
    
    _rsvFix.doubleSlider = NO;
    _rsvCustom.doubleSlider = YES;
    
    _needToChangeWindMode = YES;
    
    _rsLight.doubleSlider = NO;
    _rsLight.maxValue = 8;
    _rsLight.delegate = self;
    [_rsLight eventValueDidChanged:^(double left, double right) {
        
    }];
    
    [HomeKit_DeviceService sharedInstance].vcDetail = self;
    
     [self.paramsView setValuesWithHumidity:0 co2:@"--" speed:0];
    
    [self accessoryManagerUpdateDevices:[NSMutableArray arrayWithObject:self.device]];
    
    int pmCount = [((HMCharacteristic *)[self.device objectForKey:kPurifiePM25]).value ml_intValue];
    NSDictionary *values = @{@"value1":[NSString stringWithFormat:@"%d", pmCount], @"value2":[NSString stringWithFormat:@"%ld", (long)self.outdoorValue]};
    self.todayBarChartView.dataResource = values;
    [self.todayBarChartView draw];
    
    [self setHistoryToDisplay:NO];
    if([[NSUserDefaults standardUserDefaults] valueForKey:kWechatUserJsonKey]){
        
        MLWeakSelf weakSelf = self;
        HomeKit_User *user = [HomeKit_UserService sharedInstance].user;
        
        
        HMCharacteristic *chaSerial = (HMCharacteristic *)[self.device objectForKey:kPurifierSerialNumber];
        NSString *serialNumber = [chaSerial.value ml_stringValue];
        
        if(serialNumber){
            if([[NSUserDefaults standardUserDefaults] valueForKey:serialNumber]){
                NSString *mac = [[NSUserDefaults standardUserDefaults] valueForKey:serialNumber];
                if(mac.length == 0) {
                    self.barChartView.hidden = YES;
                    return;
                }
                
                HistoryInfoRequest *historyInfoRequest = [[HistoryInfoRequest alloc] initWithArea:self.city physicalDeviceId:mac openId:user.openid];
                
                [[HomeKit_DeviceService sharedInstance] fetchHistoryInfosWithRequest:historyInfoRequest completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                    [weakSelf handleCompletionForHistoryInfoWithServiceResponse:(HistoryInfoResponse *)pServiceResponse];
                }];
            }
            else{
                [[HomeKit_DeviceService sharedInstance] getXlinkDeviceInfoBySnWithSN:serialNumber completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                    
                    HomeKit_StringResponse *resposne = (HomeKit_StringResponse *)pServiceResponse;
                    
                    if(!pServiceResponse.success || resposne.responseResult.length == 0) {
                        self.barChartView.hidden = YES;
                        return;
                    }
                    
                    HistoryInfoRequest *historyInfoRequest = [[HistoryInfoRequest alloc] initWithArea:self.city physicalDeviceId:resposne.responseResult openId:user.openid];
                    
                    [[HomeKit_DeviceService sharedInstance] fetchHistoryInfosWithRequest:historyInfoRequest completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                        [weakSelf handleCompletionForHistoryInfoWithServiceResponse:(HistoryInfoResponse *)pServiceResponse];
                    }];
                }];
            }
        }
        
//        if(serialNumber)
//        [[HomeKit_DeviceService sharedInstance] getXlinkDeviceInfoBySnWithSN:serialNumber completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
//
//            HomeKit_StringResponse *resposne = (HomeKit_StringResponse *)pServiceResponse;
//
//            if(!pServiceResponse.success || resposne.responseResult.length == 0) {
//                self.barChartView.hidden = YES;
//                return;
//            }
//
//            HistoryInfoRequest *historyInfoRequest = [[HistoryInfoRequest alloc] initWithArea:self.city physicalDeviceId:resposne.responseResult openId:user.openid];
//
//            [[HomeKit_DeviceService sharedInstance] fetchHistoryInfosWithRequest:historyInfoRequest completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
//                [weakSelf handleCompletionForHistoryInfoWithServiceResponse:(HistoryInfoResponse *)pServiceResponse];
//            }];
//        }];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _manager.delegate = self;
    [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.paramsView stopRotateWind];
}

- (void)setHistoryToDisplay:(BOOL)pDisplay
{
    CGRect rectFooter = _viewFooterBg.frame;
    
    if(pDisplay){
        _cMenuTop.constant = kMenuTop2;
        _cModeTop.constant = kControlPanelTop2;
        _cNameTop.constant = kControlPanelTop2;
        _cHotTop.constant = kControlPanelTop2;
        _cWindMainTop.constant = kControlPanelTop2;
        _cWindFixTop.constant = kControlPanelTop2;
        _cWindCustomTop.constant = kControlPanelTop2;
        _cScreenTop.constant = kControlPanelTop2;
        rectFooter.size.height = kFooterPanelHeight2;
        _viewFooterBg.frame = rectFooter;
        self.barChartView.hidden = NO;
    }
    else{
        _cMenuTop.constant = kMenuTop1;
        _cModeTop.constant = kControlPanelTop1;
        _cNameTop.constant = kControlPanelTop1;
        _cHotTop.constant = kControlPanelTop1;
        _cWindMainTop.constant = kControlPanelTop1;
        _cWindFixTop.constant = kControlPanelTop1;
        _cWindCustomTop.constant = kControlPanelTop1;
        _cScreenTop.constant = kControlPanelTop1;
        rectFooter.size.height = kFooterPanelHeight1;
        _viewFooterBg.frame = rectFooter;
        self.barChartView.hidden = YES;
    }
    [_tv reloadData];
}

- (void)handleCompletionForHistoryInfoWithServiceResponse:(HistoryInfoResponse *)pServiceResponse
{
    
    if(!pServiceResponse.success){
//        [self showDropdownViewWithMessage:@"获取历史数据错误，请重试"];
        return;
    }
    
    [self setHistoryToDisplay:YES];
    
    NSMutableArray *maHistory = [NSMutableArray array];
    [pServiceResponse.maHistories enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HistoryInfo *historyInfo = obj;
        NSDictionary *dic = @{@"date":[historyInfo formatDate],@"value1":[historyInfo indoorStringValue],@"value2":[historyInfo outdoorStringValue]};
        [maHistory addObject:dic];
    }];
    self.barChartView.dataResource = maHistory;
    [self.barChartView setNeedsDisplay];
}

- (void)setupDevice
{
    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    
    CGPoint point = CGPointMake(self.view.bounds.size.width - 30, StatusRect.size.height == 44?84:64);
    
    if([_manager checkCurrrentUserIsAdmin]){
        _arrControlMenuItem = @[@"房间设置", @"固件管理", @"设备服务"];
    }
    else{
        _arrControlMenuItem = @[@"固件管理"];
    }
    
    [YBPopupMenu showAtPoint:point titles:_arrControlMenuItem icons:nil menuWidth:120 delegate:self];
}

#pragma mark - SDRangeSliderViewDelegate
- (void)sliderValueEndChangedOfLeft:(double)pLeft right:(double)pRight
{
    NSLog(@"_rsLight........: %f", pLeft);
    [self checkDeviceStatursWithDevice:_acc];
    [self changeScreenLight:pLeft];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    if([_manager checkCurrrentUserIsAdmin]){
        if(index == 0){
            HomeKit_RoomSettingViewController *vcRoomSetting = (HomeKit_RoomSettingViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"RoomSettingViewController"];
            vcRoomSetting.enterType = EnterTypeSelect;
            vcRoomSetting.currentRoom = _acc.room;
            vcRoomSetting.currentAccessory = _acc;
            vcRoomSetting.delegate = self;
            [self.navigationController pushViewController:vcRoomSetting animated:YES];
        }
        if(index == 1){
            if(!_acc.reachable){
                [self showDropdownViewWithMessage:@"设备处于离线状态，请检查！"];
                return;
            }
            HomeKit_AboutViewController *vcAbout = (HomeKit_AboutViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"AboutViewController"];
            vcAbout.device = self.device;
            [self.navigationController pushViewController:vcAbout animated:YES];
        }
        
        if(index == 2){
            HomeKit_ServiceSettingViewController *vcServiceSetting = (HomeKit_ServiceSettingViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"ServiceSettingViewController"];
            vcServiceSetting.accessory = _acc;
            [self.navigationController pushViewController:vcServiceSetting animated:YES];
        }
    }
    else{
        
        if(index == 0){
            if(!_acc.reachable){
                [self showDropdownViewWithMessage:@"设备处于离线状态，请检查！"];
                return;
            }
            HomeKit_AboutViewController *vcAbout = (HomeKit_AboutViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"AboutViewController"];
            vcAbout.device = self.device;
            [self.navigationController pushViewController:vcAbout animated:YES];
        }
        
        if(index == 1){
            HomeKit_ServiceSettingViewController *vcServiceSetting = (HomeKit_ServiceSettingViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"ServiceSettingViewController"];
            vcServiceSetting.accessory = _acc;
            [self.navigationController pushViewController:vcServiceSetting animated:YES];
        }
    }
    
}

#pragma mark - text field delegate
// 获得焦点
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField.tag == 1000){
        [self performSelector:@selector(setFocusToInput) withObject:self afterDelay:1];
    }
    if(textField.tag == 1){
        //        self.sideMenuViewController.panGestureEnabled = NO;
    }
    return YES;
}
- (void)setFocusToInput
{
    [_tfInput becomeFirstResponder];
    _tfInput.text = _tfName.text;
}

#pragma mark - RoomSettingViewCotrollerDelegate
- (void)selectedRoom:(HMRoom *_Nullable)pRoom
{
    [_manager.currentHome assignAccessory:_acc toRoom:pRoom completionHandler:^(NSError * _Nullable error) {
        if(error){
            [self showDropdownViewWithMessage:@"分配房间错误，请重试！"];
        }
    }];
}

#pragma mark - change pm 2.5 description color
- (CAGradientLayer *)flavescentGradientLayerWithFrame:(CGRect)pFrame pmValue:(float)pmValue
{
    
    float value = pmValue > 255.0 ? 255.0 : pmValue;
    
    
    float leftScale = (255.0 - 78.0)/255.0;
    float leftValueB = 255 - value;
    float leftValueG = leftValueB * leftScale + 78;
    
    float rightScale = (255.0 - 138.0)/255.0;
    float rightValueB = 255 - value;
    float rightValueG = rightValueB * rightScale + 138;
    
    
    UIColor *leftColor = [UIColor colorWithRed:1.0 green:leftValueG/255.0 blue:leftValueB/255.0 alpha:1];
    UIColor *rightColor = [UIColor colorWithRed:1.0 green:rightValueG/255.0 blue:rightValueB/255.0 alpha:1];
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)leftColor.CGColor, (id)rightColor.CGColor, nil];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = pFrame;
    gradientLayer.colors = gradientColors;
    gradientLayer.startPoint = CGPointMake(0, .5);
    gradientLayer.endPoint = CGPointMake(1, .5);
    
    return gradientLayer;
}


#pragma mark - fetch location
- (void)FetchLocation
{
    HMAccessory *acc = [self.device objectForKey:kPurifier];
    NSMutableString *ms = [NSMutableString string];
    [ms appendString:_manager.currentHome.name];
    
    if(acc.room.name.length != 0){
        [ms appendString:@" "];
        [ms appendString:acc.room.name];
    }
    
    _lblLocation.text = ms;
    NSInteger width = [ms mp_widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14] height:20] + 3;
    if(width > 120){
        width = 120;
    }
    _cLocationNameWidth.constant = width;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect.origin.y = keyboardRect.origin.y + 50;
    _keyBoardheight = keyboardRect.size.height;
    
    _tv.contentSize = CGSizeMake(_tv.contentSize.width, _tv.contentSize.height + _keyBoardheight);
    [_tv scrollRectToVisible:keyboardRect animated:YES];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    _tv.contentSize = CGSizeMake(_tv.contentSize.width, _tv.contentSize.height - _keyBoardheight);
    [_tv scrollsToTop];
}

- (void)selected:(NSInteger)pIndex
{
    UIColor *unselectedTextColor = [UIColor blackColor];
    
    _btnHot.backgroundColor = [UIColor clearColor];
    _btnHot.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnHot setTitleColor:unselectedTextColor forState:UIControlStateNormal];

    _btnName.backgroundColor = [UIColor clearColor];
    _btnName.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnName setTitleColor:unselectedTextColor forState:UIControlStateNormal];

    _btnWind.backgroundColor = [UIColor clearColor];
    _btnWind.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnWind setTitleColor:unselectedTextColor forState:UIControlStateNormal];

    _btnMode.backgroundColor = [UIColor clearColor];
    _btnMode.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnMode setTitleColor:unselectedTextColor forState:UIControlStateNormal];
    
    _btnControlScreen.backgroundColor = [UIColor clearColor];
    _btnControlScreen.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnControlScreen setTitleColor:unselectedTextColor forState:UIControlStateNormal];
    
    _viewNamePanel.alpha = 0;
    _viewModePanel.alpha = 0;
    _viewHotPanel.alpha = 0;
    _viewWindPanel.alpha = 0;
    _viewWindFixPanel.alpha = 0;
    _viewWindCustomPanel.alpha = 0;
    _viewControlScreenPanel.alpha = 0;
    
    _selectedIndex = pIndex;
    
    UIColor *selectedTextColor = RGB(0, 176, 235);
    UIFont *selectedTextFont = [UIFont boldSystemFontOfSize:15];
    
    switch (pIndex) {
        case 0:
        {
            _viewNamePanel.alpha = 1;
            _btnName.backgroundColor = [UIColor whiteColor];
            _btnName.titleLabel.font = selectedTextFont;
            [_btnName setTitleColor:selectedTextColor forState:UIControlStateNormal];
            break;
        }
        case 1:
        {
            _viewModePanel.alpha = 1;
            _btnMode.backgroundColor = [UIColor whiteColor];
            _btnMode.titleLabel.font = selectedTextFont;
            [_btnMode setTitleColor:selectedTextColor forState:UIControlStateNormal];
            break;
        }
        case 2:
        {
            _viewHotPanel.alpha = 1;
            _btnHot.backgroundColor = [UIColor whiteColor];
            _btnHot.titleLabel.font = selectedTextFont;
            [_btnHot setTitleColor:selectedTextColor forState:UIControlStateNormal];
            break;
        }
        case CtrlWindButtonTagTypeIntelligence:
        {
            _viewWindPanel.alpha = 1;
            _btnWind.backgroundColor = [UIColor whiteColor];
            _btnWind.titleLabel.font = selectedTextFont;
            [_btnWind setTitleColor:selectedTextColor forState:UIControlStateNormal];
            break;
        }
        case CtrlWindButtonTagTypeFix:
        {
            if(_currentMinWind != 0){
                _rsvFix.leftValue = _currentMinWind;
            }
            
            _viewWindFixPanel.alpha = 1;
            _btnWind.backgroundColor = [UIColor whiteColor];
            _btnWind.titleLabel.font = selectedTextFont;
            break;
        }
        case CtrlWindButtonTagTypeCustom:
        {
            if(_currentMinWind != 0){
                _rsvCustom.leftValue = _currentMinWind;
            }
            if(_currentMaxWind != 0){
                _rsvCustom.rightValue =  (_currentMaxWind <= _currentMinWind)?100:_currentMaxWind;
            }
            _viewWindCustomPanel.alpha = 1;
            _btnWind.backgroundColor = [UIColor whiteColor];
            _btnWind.titleLabel.font = selectedTextFont;
            break;
        }
        case 5:
        {
            _viewControlScreenPanel.alpha = 1;
            _btnControlScreen.backgroundColor = [UIColor whiteColor];
            _btnControlScreen.titleLabel.font = selectedTextFont;
            [_btnControlScreen setTitleColor:selectedTextColor forState:UIControlStateNormal];
            break;
        }
    }
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self calculateFrameWithOffY:_tv.contentOffset.y];
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
    [self.view endEditing:YES];
}

- (void)refresh
{
    [_btnRefresh start];
    [_manager getHomesNotify];
}



- (void)initUIWithDeviceDetailInfo:(HomeKit_DeviceDetailInfo *)pDeviceDetailInfo
{
    
    [self setTitle:@"爱空气"];
}


#pragma mark - acitions

- (IBAction)actionForBindDevice:(UIButton *)sender {
    HomeKit_UserInfoViewController *vcUserInfo = (HomeKit_UserInfoViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"UserInfoViewController"];
    [self.navigationController pushViewController:vcUserInfo animated:YES];
}


- (IBAction)actionForEndEdit:(id)sender {
    [self endEditHome];
}

- (IBAction)actionForCreation:(id)sender {
    [self checkDeviceStatursWithDevice:_acc];
    if(_tfName.text.length == 0){
        [self showDropdownViewWithMessage:@"设备名称不能为空！"];
        return;
    }
    [_manager updateAccessoryName:_tfInput.text accessory:_acc completionHandler:^(NSError * _Nullable error) {
        if(error){
            [self showDropdownViewWithMessage:@"设备重命名出错，请重试！"];
        }
        else{
            //for serial is empty
            if([[NSUserDefaults standardUserDefaults] valueForKey:_deviceName]){
                NSString *serial = [[NSUserDefaults standardUserDefaults] valueForKey:_deviceName];
                [[NSUserDefaults standardUserDefaults] setValue:serial forKey:_tfInput.text];
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:_deviceName];
            }
            
            
            _tfName.text = _tfInput.text;
            self.title = _tfName.text;
            [self endEditHome];
            
        }
    }];
    
}

- (void)endEditHome
{
    [_tfInput resignFirstResponder];
    [_viewControlPanel endEditing:YES];
    [self.view endEditing:YES];
}

- (IBAction)actionForRefresh:(id)sender {
    [_btnRefresh rotate];
    [self refresh];
}
    
- (void)actionForBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
 }


//mode auto or m
- (IBAction)actionForChangingMode:(id)sender {
    [self checkDeviceStatursWithDevice:_acc];
    HomeKit_ButtonSwitch *btn = sender;
    if(_mdCharactestiric){
        HMCharacteristic *cha = [_mdCharactestiric objectForKey:kPurifierTargetState];
        if(cha){
            NSInteger currentValue = [((HMCharacteristic *)[_mdCharactestiric objectForKey:kPurifierTargetState]).value ml_intValue];
            btn.bsStatus = ButtonSwitchStatusPendding;
            [_manager updateCharacteristic:cha value:currentValue==1?0:1 completionHandler:^(NSError * _Nullable error) {
                if(error){
                    [self showDropdownViewWithMessage:@"异常，请重试！"];
                    btn.bsStatus = currentValue==1?ButtonSwitchStatusActive:ButtonSwitchStatusInactive;
                }
                else{
                    [cha enableNotification:YES completionHandler:^(NSError * _Nullable error) { }];
                    [_manager getHomesNotify];
                }
            }];
        }
    }
}
//speed
- (IBAction)actionForChangingWindSpeedValue:(UISlider *)sender {
    _lblWindSpped.text = [NSString stringWithFormat:@"%.0f%@", round(sender.value), @"%"];
}


- (IBAction)actionForEndValue:(UISlider *)sender {
    [self checkDeviceStatursWithDevice:_acc];
    NSLog(@"actionForEndValue......%f", sender.value);
    if(_mdCharactestiric){
        HMCharacteristic *cha = [_mdCharactestiric objectForKey:kPurifieSpeed];
        if(cha){
            [_manager updateCharacteristic:cha value:round(sender.value) completionHandler:^(NSError * _Nullable error) {
                if(error){
                    [self showDropdownViewWithMessage:@"异常，请重试！"];
                }
                else{
                    [_manager getHomesNotify];
                }
            }];
        }
    }
}
//        0: Sleep Mode OFF
//        1: Sleep Mode On
- (IBAction)actionForSleepMode:(id)sender {
    if(_mdCharactestiric == nil){
        [self showDropdownViewWithMessage:@"异常，请重试！"];
        return;
    }
    
    if([((HMCharacteristic *)[_mdCharactestiric objectForKey:kPurifieSleepMode]).value ml_intValue] == 1){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                 message:@"是否确定唤醒设备？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sleepAction = [UIAlertAction actionWithTitle:@"唤醒" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self checkDeviceStatursWithDevice:_acc];
            
            if(_mdCharactestiric){
                HMCharacteristic *cha = [_mdCharactestiric objectForKey:kPurifieSleepMode];
                if(cha){
                    NSInteger currentValue = [((HMCharacteristic *)[_mdCharactestiric objectForKey:kPurifieSleepMode]).value ml_intValue];
                    
                    [_manager updateCharacteristic:cha value:currentValue==1?0:1 completionHandler:^(NSError * _Nullable error) {
                        if(error){
                            [self showDropdownViewWithMessage:@"异常，请重试！"];
                            
                        }
                        else{
                            [cha enableNotification:YES completionHandler:^(NSError * _Nullable error) { }];
                            [_manager getHomesNotify];
//                            [self changeScreenLight:5];
//                            [self changeWindEnginToTurnOn:YES];
                        }
                    }];
                }
            }
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:sleepAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                 message:@"休眠设备会使智能新风停止运行，退出休眠模式可再次点击休眠按键或长按按键5秒钟听到蜂鸣器响一声松开即可" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sleepAction = [UIAlertAction actionWithTitle:@"休眠" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self checkDeviceStatursWithDevice:_acc];
            
            if(_mdCharactestiric){
                HMCharacteristic *cha = [_mdCharactestiric objectForKey:kPurifieSleepMode];
                if(cha){
                    NSInteger currentValue = [((HMCharacteristic *)[_mdCharactestiric objectForKey:kPurifieSleepMode]).value ml_intValue];
                    
                    [_manager updateCharacteristic:cha value:currentValue==1?0:1 completionHandler:^(NSError * _Nullable error) {
                        if(error){
                            [self showDropdownViewWithMessage:@"异常，请重试！"];
                            
                        }
                        else{
                            [cha enableNotification:YES completionHandler:^(NSError * _Nullable error) { }];
                            [_manager getHomesNotify];
//                            [self changeScreenLight:0];
//                            [self changeWindEnginToTurnOn:NO];
                        }
                    }];
                }
            }
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不休眠" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:sleepAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    
    
    
}

//set the wind mode to intelligent mode
- (IBAction)actionForSettingWindMode:(HomeKit_ButtonCtrlSwitch *)sender {
    HMCharacteristic *cha = [_mdCharactestiric objectForKey:kPurifieActive];
    if([cha.value ml_intValue] == 0){
        [self showDropdownViewWithMessage:@"请先打开风机"];
        return;
    }
    
    switch (sender.tag) {
        case WindButtonModeTagTypeIntelligence:
        {
//            _needToChangeWindMode = YES;
            [self setMode:1];
            break;
        }
        case WindButtonModeTagTypeFix:
        {
            
            [self checkDeviceStatursWithDevice:_acc];
            if(_mdCharactestiric){
                [self setMode:0];
                [self setWindValueWithMin:_rsvFix.leftValue max:_rsvFix.leftValue];
                _minSettingValue = _rsvCustom.leftValue;
                _maxSettingValue = _rsvCustom.leftValue;
                _bcsWindFixOK.bsStatus = ButtonCtrlSwitchStatusPendding;
                [self performSelector:@selector(delayToReadingWindWithType:) withObject:@(WindButtonModeTagTypeFix) afterDelay:3];
            }
            break;
        }
        case WindButtonModeTagTypeCustom:
        {
            
            
            [self checkDeviceStatursWithDevice:_acc];
            if(_mdCharactestiric){
                [self setMode:0];
                [self setWindValueWithMin:_rsvCustom.leftValue max:_rsvCustom.rightValue];
                _minSettingValue = _rsvCustom.leftValue;
                _maxSettingValue = _rsvCustom.rightValue;
                _bcsWindCustomOK.bsStatus = ButtonCtrlSwitchStatusPendding;
                [self performSelector:@selector(delayToReadingWindWithType:) withObject:@(WindButtonModeTagTypeCustom) afterDelay:3];
            }
            
            
            break;
        }
    }
}

- (void)delayToReadingWindWithType:(id)pType
{
    if([pType integerValue] == WindButtonModeTagTypeFix){
        _bcsWindFixOK.bsStatus = ButtonCtrlSwitchStatusActive;
        _manulChange = YES;

    }
    if([pType integerValue] == WindButtonModeTagTypeCustom){
        _bcsWindCustomOK.bsStatus = ButtonCtrlSwitchStatusActive;
        _manulChange = YES;
    }
}

- (void)setMode:(NSInteger)pMode
{
    HMCharacteristic *cha = [_mdCharactestiric objectForKey:kPurifierTargetState];
    if(cha){
//        NSInteger currentValue = [((HMCharacteristic *)[_mdCharactestiric objectForKey:kPurifierTargetState]).value ml_intValue];
        [_manager updateCharacteristic:cha value:pMode completionHandler:^(NSError * _Nullable error) {
            if(error){
                [self showDropdownViewWithMessage:@"异常，请重试！"];
            }
            else{
                [cha enableNotification:YES completionHandler:^(NSError * _Nullable error) { }];
                [_manager getHomesNotify];
            }
        }];
    }
}

- (void)setWindValueWithMin:(NSInteger)pMin max:(NSInteger)pMax
{
    if(_mdCharactestiric){
        [self setMode:0];
        HMCharacteristic *chaLeft = [_mdCharactestiric objectForKey:kPurifieSpeed];
        if(chaLeft){
            [_manager updateCharacteristic:chaLeft value:pMin completionHandler:^(NSError * _Nullable error) {
                if(error){
                    [self showDropdownViewWithMessage:@"异常，请重试！"];
                }
                else{
                    [_manager getHomesNotify];
                }
            }];
        }
        
        
        HMCharacteristic *chaRight = [_mdCharactestiric objectForKey:kPurifieSpeedCustom];
        if(chaRight){
            [_manager updateCharacteristic:chaRight value:pMax completionHandler:^(NSError * _Nullable error) {
                if(error){
                    [self showDropdownViewWithMessage:@"异常，请重试！"];
                }
                else{
                    [_manager getHomesNotify];
                }
            }];
        }
        
    }
}

- (IBAction)actionForSwitch:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self selected:btn.tag];
}
- (IBAction)actionForSwitchHot:(id)sender {
    [self checkDeviceStatursWithDevice:_acc];
    HomeKit_ButtonSwitch *btn = sender;
    if(_mdCharactestiric){
        HMCharacteristic *cha = [_mdCharactestiric objectForKey:kPurifieHeaterEnable];
        if(cha){
            NSInteger currentValue = [((HMCharacteristic *)[_mdCharactestiric objectForKey:kPurifieHeaterEnable]).value ml_intValue];
            btn.bsStatus = ButtonSwitchStatusPendding;
            [_manager updateCharacteristic:cha value:currentValue==1?0:1 completionHandler:^(NSError * _Nullable error) {
                if(error){
                    [self showDropdownViewWithMessage:@"异常，请重试！"];
                    btn.bsStatus = currentValue==1?ButtonSwitchStatusActive:ButtonSwitchStatusInactive;
                }
                else{
                    [cha enableNotification:YES completionHandler:^(NSError * _Nullable error) { }];
                    [_manager getHomesNotify];
                }
            }];
        }
        
        
    }
}

- (void)changeScreenLight:(NSInteger)pValue
{
    if(_mdCharactestiric){
        HMCharacteristic *cha = [_mdCharactestiric objectForKey:kPurifieIndication];
        if(cha){
            [_manager updateCharacteristic:cha value:round(pValue) completionHandler:^(NSError * _Nullable error) {
                if(error){
                    [self showDropdownViewWithMessage:@"异常，请重试！"];
                }
                else{
                    [cha enableNotification:YES completionHandler:^(NSError * _Nullable error) { }];
                    [_manager getHomesNotify];
                }
            }];
        }
    }
}

- (IBAction)actionForChangingTurn:(id)sender {
    [self checkDeviceStatursWithDevice:_acc];
    
    NSInteger currentValue = [((HMCharacteristic *)[_mdCharactestiric objectForKey:kPurifieActive]).value ml_intValue];
    [self changeWindEnginToTurnOn: currentValue? 0:1];
}

- (void)changeWindEnginToTurnOn:(BOOL)pTurnOn
{
    if(_mdCharactestiric){
        HMCharacteristic *cha = [_mdCharactestiric objectForKey:kPurifieActive];
        if(cha){
             _btnWindEnginSwitch.bsStatus = ButtonSwitchStatusPendding;
            [_manager updateCharacteristic:cha value:pTurnOn ? 1 : 0 completionHandler:^(NSError * _Nullable error) {
                if(error){
                    [self showDropdownViewWithMessage:@"异常，请重试！"];
                    _btnWindEnginSwitch.bsStatus = pTurnOn?ButtonSwitchStatusActive:ButtonSwitchStatusInactive;
                }
                else{
                    //change mode to auto
                    [cha enableNotification:YES completionHandler:^(NSError * _Nullable error) { }];
                    [_manager getHomesNotify];
                    
                    HMCharacteristic *chaPurifieSpeed = (HMCharacteristic *)[_mdCharactestiric objectForKey:kPurifieSpeed];
                    if(chaPurifieSpeed){
                        [chaPurifieSpeed readValueWithCompletionHandler:^(NSError * _Nullable error) {}];
                        [chaPurifieSpeed enableNotification:YES completionHandler:^(NSError * _Nullable error) {}];
                    }
                }
            }];
        }
        
        
    }
}

- (void)checkDeviceStatursWithDevice:(HMAccessory *)pDevice
{
    
    if(!pDevice.reachable){
        [self showDropdownViewWithMessage:@"设备不可用！"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
}

#pragma mark - PMDescriptionViewDelegate
- (void)updateConstraint:(float)pWidth
{
    _cViewPM25DescriptionWidth.constant = pWidth;
}

#pragma mark - AccessoriesManager Delegate
- (void)accessoryDidUpdateStatus:(HMAccessory *_Nullable)pAccessory
{
    [self checkDeviceStatursWithDevice:pAccessory];
}
- (void)accessoryManagerUpdateDevices:(NSMutableArray *_Nullable)pDevices
{
    if(pDevices.count == 0){
        [self actionForBack:nil];
    }
    [_btnRefresh stop];
    
    NSMutableDictionary *mdAccessory = nil;
    for(NSMutableDictionary *accessory in pDevices){

        HMAccessory *acc = [self.device objectForKey:kPurifier];
        NSString *UUID = [acc.uniqueIdentifier UUIDString];
        
        HMAccessory *accInArray = [accessory objectForKey:kPurifier];
        NSString *UUIDInArray = [accInArray.uniqueIdentifier UUIDString];
        
        if([UUID isEqualToString:UUIDInArray]){
            mdAccessory = accessory;
            break;
        }
    }
    
    if(mdAccessory == nil){
        [self showDropdownViewWithMessage:@"设备出错，请检查！"];
        [self actionForBack:nil];
        return;
    }
    
    if(mdAccessory){
        //control
        _mdCharactestiric = mdAccessory;
        _acc = [mdAccessory objectForKey:kPurifier];
        
        _deviceName = [[mdAccessory objectForKey:kPurifierName] ml_stringValue];
        self.title = _deviceName;
        
        if(_refreshIndex == 0){
            _tfName.text = [[mdAccessory objectForKey:kPurifierName] ml_stringValue];
            
        }
        _refreshIndex++;
        
        if(!_acc.reachable){
            _btnOK.enabled = NO;
            _btnModeSwitch.enabled = NO;
            _btnHotSwitch.enabled = NO;
            _sliderWind.enabled = NO;
            _btnWindEnginSwitch.enabled = NO;
            _rsLight.userInteractionEnabled = NO;
            _btnSleepSwitch.enabled = NO;
            return;
        }
        else{
            _btnOK.enabled = YES;
            _btnHotSwitch.enabled = YES;
            _btnWindEnginSwitch.enabled = YES;
            _rsLight.userInteractionEnabled = YES;
            _btnSleepSwitch.enabled = YES;
        }
        
        //kPurifierTargetState mode
        if([((HMCharacteristic *)[mdAccessory objectForKey:kPurifierTargetState]).value ml_intValue] == 1){
            [_btnModeSwitch setTitle:@"手动          自动" forState:UIControlStateNormal];
            _btnModeSwitch.bsStatus = ButtonModeSwitchStatusActive;
        }
        else{
            [_btnModeSwitch setTitle:@"手动          自动" forState:UIControlStateNormal];
            _btnModeSwitch.bsStatus = ButtonModeSwitchStatusInactive;
        }
        
        //kPurifieHeaterEnable
        if([((HMCharacteristic *)[mdAccessory objectForKey:kPurifieHeaterEnable]).value ml_intValue] == 1){
            [_btnHotSwitch setTitle:@"关闭辅热" forState:UIControlStateNormal];
            _btnHotSwitch.bsStatus = ButtonSwitchStatusActive;
        }
        else{
            [_btnHotSwitch setTitle:@"打开辅热" forState:UIControlStateNormal];
            _btnHotSwitch.bsStatus = ButtonSwitchStatusInactive;
        }
        
        //kPurifieSleepMode
//        0: Sleep Mode OFF
//        1: Sleep Mode On
        if([((HMCharacteristic *)[mdAccessory objectForKey:kPurifieSleepMode]).value ml_intValue] == 1){
            [_btnSleepSwitch setBackgroundImage:[UIImage imageNamed:@"sleep_enable.png"] forState:UIControlStateNormal];
        }
        else{
            [_btnSleepSwitch setBackgroundImage:[UIImage imageNamed:@"sleep_disable.png"] forState:UIControlStateNormal];
        }
        
        //kPurifieActive
        if([mdAccessory objectForKey:kPurifieActive] != nil){
            if([((HMCharacteristic *)[mdAccessory objectForKey:kPurifieActive]).value ml_intValue] == 1){
                [_btnWindEnginSwitch setTitle:@"关闭风机" forState:UIControlStateNormal];
                [self.paramsView startRotateWind];
                _btnWindEnginSwitch.bsStatus = ButtonSwitchStatusActive;
                
                _btnModeSwitch.enabled = YES;
                _sliderWind.enabled = YES;
                _btnHotSwitch.enabled = YES;
                _lblWindSpped.hidden = NO;
                
                
            }
            else{
                [_btnWindEnginSwitch setTitle:@"打开风机" forState:UIControlStateNormal];
                [self.paramsView stopRotateWind];
                _btnWindEnginSwitch.bsStatus = ButtonSwitchStatusInactive;
                
                _btnModeSwitch.enabled = NO;
                _sliderWind.enabled = NO;
                _btnHotSwitch.enabled = NO;
                _lblWindSpped.hidden = YES;
            }
        }
        
        

        
        _sliderWind.value = [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieSpeed]).value ml_intValue];
        _lblWindSpped.text = [NSString stringWithFormat:@"%.0f%@", round(_sliderWind.value),@"%"];
        
        
        
        _currentMinWind = [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieSpeed]).value ml_intValue];
        _currentMaxWind = [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieSpeedCustom]).value ml_intValue];
        NSInteger mode = [((HMCharacteristic *)[mdAccessory objectForKey:kPurifierTargetState]).value ml_intValue];
        
        
        if(mode == 1){
            _bcsWindIntelligence.bsStatus = ButtonSwitchStatusActive;
            _bcsWindFixed.bsStatus = ButtonSwitchStatusInactive;
            _bcsWindCustom.bsStatus = ButtonSwitchStatusInactive;
            _lblWindModeTitle.text = @"风量模式：智慧巡航";
        }
        else{
            if(_currentMinWind == _currentMaxWind) {
                _bcsWindIntelligence.bsStatus = ButtonSwitchStatusInactive;
                _bcsWindFixed.bsStatus = ButtonSwitchStatusActive;
                _bcsWindCustom.bsStatus = ButtonSwitchStatusInactive;
                _lblWindModeTitle.text = @"风量模式：定速巡航";
            }
            else{
                _bcsWindIntelligence.bsStatus = ButtonSwitchStatusInactive;
                _bcsWindFixed.bsStatus = ButtonSwitchStatusInactive;
                _bcsWindCustom.bsStatus = ButtonSwitchStatusActive;
                _lblWindModeTitle.text = @"风量模式：自定巡航";
            }
        }
        
        if(_needToChangeWindMode){
            _rsvFix.leftValue = _currentMinWind;
            
            _rsvCustom.leftValue = _currentMinWind;
            _rsvCustom.rightValue = (_currentMaxWind == 0 || _currentMaxWind <= _currentMinWind)?100:_currentMaxWind;
            _needToChangeWindMode = NO;
        }
        
        if(_manulChange && _minSettingValue == _currentMinWind && _maxSettingValue == _currentMaxWind){
            
            _rsvCustom.leftValue = _currentMinWind;
            
            _rsvCustom.rightValue = (_currentMaxWind == 0 || _currentMaxWind <= _currentMinWind)?100:_currentMaxWind;
            
            _manulChange = NO;
        }
        
        if(_manulChange && _minSettingValue == _currentMinWind){
            _rsvFix.leftValue = _currentMinWind;
            _manulChange = NO;
        }
        int lightValue = [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieIndication]).value ml_intValue];
        _rsLight.leftValue = lightValue;
        //display
        
        int pmCount = [((HMCharacteristic *)[mdAccessory objectForKey:kPurifiePM25]).value ml_intValue];
        
        //pm2.5 description
        if([mdAccessory objectForKey:kPurifieAirQuality] != nil){
            NSInteger quality = [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieAirQuality]).value ml_intValue];
            NSString *description = @"";
            switch (quality) {
                case 1:
                {
                    description = @"空气质量优";
                    break;
                }
                case 2:
                {
                    description = @"空气质量良";
                    break;
                }
                case 3:
                {
                    description = @"空气质量正常";
                    break;
                }
                case 4:
                {
                    description = @"空气质量差";
                    break;
                }
                case 5:
                {
                    description = @"空气质量极差";
                    break;
                }
            }
            [_viewPMDescription updatePMDescriptionWithPMValue:pmCount description:description];
        }
        
        //
        if([mdAccessory objectForKey:kPurifiePM25] != nil){
            _lblPM25Count.text = [NSString stringWithFormat:@"%d", pmCount];
        }
        
        //wind speed
        NSString *windSpeed = @"-- %";
        NSInteger windValue = 0;
        if([mdAccessory objectForKey:kPurifieSpeed] != nil){
            windValue = [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieSpeed]).value ml_intValue];
            if(windValue != 0){
                windSpeed = [NSString stringWithFormat:@"%ld%@", windValue, @"%"];
            }
            else{
                windSpeed = [NSString stringWithFormat:@"%@", @"off"];
            }
        }
        
        //
        NSString *hot = @"0°";
        if([mdAccessory objectForKey:kPurifieCurrentTemperature] != nil){
            hot = [NSString stringWithFormat:@"%d°", [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieCurrentTemperature]).value ml_intValue]];
        }
        
        //wind Humidity
//        NSString *humidity = @"--";
//        if([mdAccessory objectForKey:kPurifieCurrentHumidity] != nil){
//            humidity = [NSString stringWithFormat:@"%d", [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieCurrentHumidity]).value ml_intValue]];
//        }
        NSInteger humidity = 0;
        if([mdAccessory objectForKey:kPurifieCurrentHumidity] != nil){
            humidity = [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieCurrentHumidity]).value ml_intValue];
        }

        
        //wind co2
        NSString *co2 = @"--";
        if([mdAccessory objectForKey:kPurifieCo2Density] != nil){
            co2 = [NSString stringWithFormat:@"%d", [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieCo2Density]).value ml_intValue]];
        }
        
        [self.paramsView setValuesWithHumidity:humidity co2:co2 speed:windValue];
        
        [_tv reloadData];
        [_tv setNeedsDisplay];
        [ self.paramsView setNeedsDisplay];
        
        

    }
    
}

#pragma mark - public methods
- (void)readValue
{
    [_manager getHomesNotify];
    [[HomeKit_AccessoryManager sharedInstance] readValueWithAccessories:[[NSMutableArray alloc] initWithObjects:self.device, nil]];
    _needToChangeWindMode = YES;
}

@end
