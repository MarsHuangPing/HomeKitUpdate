//
//  HomeKit_DetailXLinkViewController.m
//  FreshAir
//
//  Created by mars on 2018/8/31.
//  Copyright © 2018 mars. All rights reserved.
//

typedef NS_ENUM(NSInteger, ChangeType) {
    ChangeTypeFanSwitch,
    ChangeTypeSleepSwitch,
    ChangeTypeSpeedInteligence,
    ChangeTypeSpeedFix,
    ChangeTypeSpeedCustom,
    ChangeTypeLilghtLevel,
    ChangeTypeHotSwitch,
    ChangeTypeAll,
    ChangeTypeNone
};

#define kReaccessCount 5

#import "HomeKit_DetailXLinkViewController.h"

#import "HomeKit_AboutViewController.h"
#import "HomeKit_RoomSettingViewController.h"
#import "HomeKit_ServiceSettingViewController.h"
#import "HomeKit_UserInfoViewController.h"
#import "HomeKit_UserService.h"
#import "HomeKit_User.h"
#import "HomeKit_BooleanResponse.h"
#import "HomeKit_XLinkDeviceServiceResponse.h"

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

#import "XLinkDevice.h"

#import "HistoryInfoRequest.h"
#import "HistoryInfoResponse.h"
#import "historyInfo.h"

@interface HomeKit_DetailXLinkViewController ()<UITableViewDelegate, PMDescriptionViewDelegate, SDRangeSliderViewDelegate>
{
    __weak IBOutlet UIView *_viewHeader;
    __weak IBOutlet UIView *_viewBannerBg;
    
    __weak IBOutlet UILabel *_lblLocation;
    
    __weak IBOutlet NSLayoutConstraint *_cPinIconLeft;
    __weak IBOutlet NSLayoutConstraint *_cPinIconWidth;
    __weak IBOutlet NSLayoutConstraint *_cLocationNameLeft;
    __weak IBOutlet NSLayoutConstraint *_cLocationNameWidth;
    
    
    
    
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
    
    
    //for log
    __weak IBOutlet UITextView *_tvLog;
    
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
    
    
    // the variables for config controll
    //只是判断当前返回的值与原来的值不同即可
    ChangeType _changeType;
    NSInteger _accessCount;
    NSInteger _fanControl;
    NSInteger _sleepControl;
    NSInteger _hotControl;
    NSInteger _lightControl;
    
}


@property(nonatomic,weak) IBOutlet HomeKit_ParamsView *paramsView;
@property(nonatomic,weak) IBOutlet HomeKit_BarChartView *barChartView;
@property(nonatomic,weak) IBOutlet HomeKit_TodayBarChartView *todayBarChartView;
@end

@implementation HomeKit_DetailXLinkViewController

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

    _tfName.enabled = [_manager checkCurrrentUserIsAdmin];

    [self FetchLocation];



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

    [self fillData];
    
    _changeType = ChangeTypeNone;
    if(!kIsDebug){
        _tvLog.hidden = YES;
    }
    _tvLog.text = [NSString stringWithFormat:@"%@ \n_changeType = %ld", _tvLog.text, (long)_changeType];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.paramsView stopRotateWind];
}

- (void)fillData
{
    [self.paramsView setValuesWithHumidity:self.XLinkDevice.IndoorHumidity
                                       co2:[NSString stringWithFormat:@"%ld", (long)self.XLinkDevice.CO2Data]
                                     speed:self.XLinkDevice.FanAirflowStatus];
    
    [self accessoryManagerUpdateDevices:self.XLinkDevice];
    
    HomeKit_User *user = [HomeKit_UserService sharedInstance].user;
    HistoryInfoRequest *historyInfoRequest = [[HistoryInfoRequest alloc] initWithArea:self.city physicalDeviceId:self.XLinkDevice.PhysicalDeviceId openId:user.openid];
    MLWeakSelf weakSelf = self;
    [[HomeKit_DeviceService sharedInstance] fetchHistoryInfosWithRequest:historyInfoRequest completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
        [weakSelf handleCompletionForHistoryInfoWithServiceResponse:(HistoryInfoResponse *)pServiceResponse];
    }];
    
    NSDictionary *values = @{@"value1":[NSString stringWithFormat:@"%ld", (long)self.XLinkDevice.PM25Data], @"value2":[NSString stringWithFormat:@"%ld", (long)self.outdoorValue]};
    self.todayBarChartView.dataResource = values;
    [self.todayBarChartView draw];
    [_btnRefresh stop];
}

- (void)refresh
{
    [_btnRefresh start];
    
    if(_changeType != ChangeTypeNone){
        return;
    }
    [self getDeviceInfoWithChangeType:@(ChangeTypeAll)];
}

- (void)setupDevice
{
    return;
}

- (void)handleCompletionForHistoryInfoWithServiceResponse:(HistoryInfoResponse *)pServiceResponse
{
    NSMutableArray *maHistory = [NSMutableArray array];
    [pServiceResponse.maHistories enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HistoryInfo *historyInfo = obj;
        NSDictionary *dic = @{@"date":[historyInfo formatDate],@"value1":[historyInfo indoorStringValue],@"value2":[historyInfo outdoorStringValue]};
        [maHistory addObject:dic];
    }];
    self.barChartView.dataResource = maHistory;
    [self.barChartView setNeedsDisplay];
}

#pragma mark - SDRangeSliderViewDelegate
- (void)sliderValueEndChangedOfLeft:(double)pLeft right:(double)pRight
{
    NSLog(@"_rsLight........: %f", pLeft);
//    [self checkDeviceStatursWithDevice:_acc];
    [self changeScreenLight:pLeft];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    
    
}

#pragma mark - get the xlink device detail
- (void)refreshXlinkDeviceDetailWithChangeType:(ChangeType)pChangeType
{
    _changeType = pChangeType;
    
    if(_accessCount >= kReaccessCount){
        NSString *errorInfo = @"";
        switch (pChangeType) {
            case ChangeTypeFanSwitch:
            {
                _btnWindEnginSwitch.bsStatus = ButtonSwitchStatusActive;
                errorInfo = @"风机控制异常，请重试";
                break;
            }
            case ChangeTypeSleepSwitch:
            {
                errorInfo = @"休眠控制异常，请重试";
                break;
            }
            case ChangeTypeHotSwitch:
            {
                _btnHotSwitch.bsStatus = ButtonSwitchStatusInactive;
                errorInfo = @"辅热控制异常，请重试";
                break;
            }
            case ChangeTypeLilghtLevel:
            {
                errorInfo = @"屏幕亮度控制异常，请重试";
                break;
            }
            case ChangeTypeSpeedInteligence:
            {
                _bcsWindIntelligence.bsStatus = ButtonCtrlSwitchStatusActive;
                errorInfo = @"智能模式控制异常，请重试";
                break;
            }
            case ChangeTypeSpeedCustom:
            {
                _bcsWindCustomOK.bsStatus = ButtonCtrlSwitchStatusActive;
                errorInfo = @"自定模式控制异常，请重试";
                break;
            }
            case ChangeTypeSpeedFix:
            {
                _bcsWindFixOK.bsStatus = ButtonCtrlSwitchStatusActive;
                errorInfo = @"固定模式控制异常，请重试";
                break;
            }
            case ChangeTypeNone:
            {
                errorInfo = @"";
                break;
            }
            case ChangeTypeAll:
            {
                errorInfo = @"获取数据，请重试";
                break;
            }
        }
        if(errorInfo.length != 0){
            [self showDropdownViewWithMessage:errorInfo];
            
        }
        _accessCount = 0;
        _changeType = ChangeTypeNone;
        return;
    }
    
    [self performSelector:@selector(getDeviceInfoWithChangeType:) withObject:@(pChangeType) afterDelay:1];
}

- (void)getDeviceInfoWithChangeType:(NSNumber *)pChangeType
{
    ChangeType ct = [pChangeType integerValue];
    _accessCount++;
    
    MLWeakSelf weakSelf = self;
    HomeKit_User *user = [HomeKit_UserService sharedInstance].user;
    [[HomeKit_DeviceService sharedInstance] refreshXLinkDevice:self.XLinkDevice
                                                           uid:user.unionid
                                                        openID:user.openid
                                                          time:0
                                               completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                   
                                                   BOOL result = pServiceResponse.success;
                                                   HomeKit_XLinkDeviceServiceResponse *response = (HomeKit_XLinkDeviceServiceResponse *)pServiceResponse;
                                                   
                                                   
                                                   switch (ct) {
                                                       case ChangeTypeFanSwitch:
                                                       {
                                                           if(response.XLinkDevice.FanControl != _fanControl || !result){
                                                               [weakSelf refreshXlinkDeviceDetailWithChangeType:ChangeTypeFanSwitch];
                                                           }
                                                           else{
                                                               [weakSelf successToControlWithDevice:response.XLinkDevice];
                                                           }
                                                           break;
                                                       }
                                                       case ChangeTypeSleepSwitch:
                                                       {
                                                           if(response.XLinkDevice.SleepMode != _sleepControl || !result){
                                                               
                                                               [weakSelf refreshXlinkDeviceDetailWithChangeType:ChangeTypeSleepSwitch];
                                                           }
                                                           else{
                                                               [weakSelf successToControlWithDevice:response.XLinkDevice];
                                                           }
                                                           break;
                                                       }
                                                       case ChangeTypeHotSwitch:
                                                       {
                                                           if(response.XLinkDevice.PTCStatus != _hotControl || !result){
                                                               
                                                               [weakSelf refreshXlinkDeviceDetailWithChangeType:ChangeTypeHotSwitch];
                                                           }
                                                           else{
                                                               [weakSelf successToControlWithDevice:response.XLinkDevice];
                                                           }
                                                           break;
                                                       }
                                                       case ChangeTypeLilghtLevel:
                                                       {
                                                           if(response.XLinkDevice.ScreenDimmingSet != _lightControl || !result){
                                                               
                                                               [weakSelf refreshXlinkDeviceDetailWithChangeType:ChangeTypeLilghtLevel];
                                                           }
                                                           else{
                                                               [weakSelf successToControlWithDevice:response.XLinkDevice];
                                                           }
                                                           break;
                                                       }
                                                       case ChangeTypeSpeedInteligence:
                                                       {
                                                           if(![weakSelf checkWindSetting:response.XLinkDevice mode:ChangeTypeSpeedInteligence] || !result){
                                                               
                                                               [weakSelf refreshXlinkDeviceDetailWithChangeType:ChangeTypeSpeedInteligence];
                                                           }
                                                           else{
                                                               [weakSelf successToControlWithDevice:response.XLinkDevice];
                                                           }
                                                           break;
                                                       }
                                                       case ChangeTypeSpeedCustom:
                                                       {
                                                           if(![weakSelf checkWindSetting:response.XLinkDevice mode:ChangeTypeSpeedCustom] || !result){
                                                               
                                                               [weakSelf refreshXlinkDeviceDetailWithChangeType:ChangeTypeSpeedCustom];
                                                           }
                                                           else{
                                                               [weakSelf successToControlWithDevice:response.XLinkDevice];
                                                           }
                                                           break;
                                                       }
                                                       case ChangeTypeSpeedFix:
                                                       {
                                                           if(![weakSelf checkWindSetting:response.XLinkDevice mode:ChangeTypeSpeedFix] || !result){
                                                               
                                                               [weakSelf refreshXlinkDeviceDetailWithChangeType:ChangeTypeSpeedFix];
                                                           }
                                                           else{
                                                               [weakSelf successToControlWithDevice:response.XLinkDevice];
                                                           }
                                                           break;
                                                       }
                                                       case ChangeTypeNone:
                                                       {
                                                           
                                                           break;
                                                       }
                                                       case ChangeTypeAll:
                                                       {
                                                           [_btnRefresh stop];
                                                           self.XLinkDevice = response.XLinkDevice;
                                                           [weakSelf accessoryManagerUpdateDevices:self.XLinkDevice];
                                                           break;
                                                       }
                                                   }
                                                   
                                                   
                                               }];
}

- (void)successToControlWithDevice:(XLinkDevice *)pDevice
{
    _accessCount = 0;
    [_btnRefresh stop];
    self.XLinkDevice = pDevice;
    _changeType = ChangeTypeNone;
    [self accessoryManagerUpdateDevices:self.XLinkDevice];
}

//当设置风量模式时，判断是否成功
- (BOOL)checkWindSetting:(XLinkDevice *)pXLinkDevice mode:(ChangeType)pMode{
    
    if(!pXLinkDevice) return NO;
    
    BOOL result = NO;
    
    switch (pMode) {
        case ChangeTypeSpeedInteligence:
        {
            if(pXLinkDevice.TargetState == 1){
                
                result = YES;
            }
            break;
        }
        case ChangeTypeSpeedFix:
        {
            if(pXLinkDevice.TargetState != 1 && pXLinkDevice.FanAirflowMin == pXLinkDevice.FanAirflowMax){
                
                result = YES;
            }
            break;
        }
        default:{
//            if(pXLinkDevice.TargetState != 1 && pXLinkDevice.FanAirflowMin != pXLinkDevice.FanAirflowMax){
            if(pXLinkDevice.TargetState != 1){
                result = YES;
            }
            break;
        }
        
    }
    
    return result;
}

- (BOOL)checkIfAccessing
{
    _tvLog.text = [NSString stringWithFormat:@"%@ \n_changeType = %ld", _tvLog.text, (long)_changeType];
    if(_changeType != ChangeTypeNone){
        return YES;
    }
    return NO;
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
    NSMutableString *ms = [NSMutableString string];
    [ms appendString:[HomeKit_AccessoryManager sharedInstance].currentHome.name];
    
    
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





- (void)initUIWithDeviceDetailInfo:(HomeKit_DeviceDetailInfo *)pDeviceDetailInfo
{
    
    [self setTitle:@"爱空气"];
}


#pragma mark - acitions

- (IBAction)actionForBindDevice:(UIButton *)sender {
    HomeKit_UserInfoViewController *vcUserInfo = (HomeKit_UserInfoViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"UserInfoViewController"];
    [self.navigationController pushViewController:vcUserInfo animated:YES];
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
    
    if([self checkIfAccessing]){
        return;
    }
    
    _changeType = ChangeTypeSleepSwitch;
    
    MLWeakSelf weakSelf = self;
    
    if(self.XLinkDevice.SleepMode == 1){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                 message:@"是否确定唤醒设备？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sleepAction = [UIAlertAction actionWithTitle:@"唤醒" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            HomeKit_User *user = [HomeKit_UserService sharedInstance].user;
            [[HomeKit_DeviceService sharedInstance] sleepDeviceWithOpenID:user.openid
                                                                      uid:user.unionid
                                                                      pId:self.XLinkDevice.PhysicalDeviceId
                                                                 platform:@"xlink"
                                                               deviceType:k360ADeviceType
                                                                      dId:self.XLinkDevice.DeviceID
                                                                 sendData:self.XLinkDevice.SleepMode == 1?@"0":@"1"
                                                          completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                              HomeKit_BooleanResponse *response = (HomeKit_BooleanResponse *)pServiceResponse;
                                                              if(response.responseResult){
//                                                                  self.XLinkDevice.SleepMode = !self.XLinkDevice.SleepMode;
//                                                                  [self accessoryManagerUpdateDevices:self.XLinkDevice];
                                                                  _sleepControl = self.XLinkDevice.SleepMode == 1?0:1;
                                                                  [weakSelf refreshXlinkDeviceDetailWithChangeType:ChangeTypeSleepSwitch];
                                                                      
                                                              }
                                                              else{
                                                                  _accessCount = 0;
                                                                  _changeType = ChangeTypeNone;
                                                                  [self showDropdownViewWithMessage:@"异常，请重试！"];
                                                              }
                                                          }];
            
            
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
            
            HomeKit_User *user = [HomeKit_UserService sharedInstance].user;
            [[HomeKit_DeviceService sharedInstance] sleepDeviceWithOpenID:user.openid
                                                                      uid:user.unionid
                                                                      pId:self.XLinkDevice.PhysicalDeviceId
                                                                 platform:@"xlink"
                                                               deviceType:k360ADeviceType
                                                                      dId:self.XLinkDevice.DeviceID
                                                                 sendData:self.XLinkDevice.SleepMode == 1?@"0":@"1"
                                                          completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                              HomeKit_BooleanResponse *response = (HomeKit_BooleanResponse *)pServiceResponse;
                                                              if(response.responseResult){
                                                                  _sleepControl = self.XLinkDevice.SleepMode == 1?0:1;
                                                                  [weakSelf refreshXlinkDeviceDetailWithChangeType:ChangeTypeSleepSwitch];
                                                              }
                                                              else{
                                                                  _accessCount = 0;
                                                                  _changeType = ChangeTypeNone;
                                                                  [self showDropdownViewWithMessage:@"异常，请重试！"];
                                                              }
                                                          }];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不休眠" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:sleepAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    
    
    
}

//set the wind mode to intelligent mode
- (IBAction)actionForSettingWindMode:(HomeKit_ButtonCtrlSwitch *)sender {
    
    if([self checkIfAccessing]){
        return;
    }
    
    if(self.XLinkDevice.FanControl == 0){
        [self showDropdownViewWithMessage:@"请先打开风机"];
        return;
    }
    
    _changeType = ChangeTypeSpeedInteligence;
    
    sender.bsStatus = ButtonCtrlSwitchStatusPendding;
    MLWeakSelf weakSelf = self;
    HomeKit_User *user = [HomeKit_UserService sharedInstance].user;
    
    NSInteger left = _rsvCustom.leftValue;
    NSInteger right = _rsvCustom.rightValue;
    
    NSInteger fixValue = _rsvFix.leftValue;
    
    switch (sender.tag) {
        case WindButtonModeTagTypeIntelligence:
        {
            
            [[HomeKit_DeviceService sharedInstance] setDeivecSpeedWithOpenID:user.openid
                                                                       uid:user.unionid
                                                                       pId:self.XLinkDevice.PhysicalDeviceId
                                                                  platform:@"xlink"
                                                                deviceType:k360ADeviceType
                                                                       dId:self.XLinkDevice.DeviceID
                                                                    sendData:@"0"
                                                                    minSpeed:@"10"
                                                                    maxSpeed:@"10"
                                                           completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                               HomeKit_BooleanResponse *response = (HomeKit_BooleanResponse *)pServiceResponse;
                                                               
                                                               if(response.responseResult){
                                                                   [weakSelf refreshXlinkDeviceDetailWithChangeType:ChangeTypeSpeedInteligence];
                                                               }
                                                               else{
                                                                   sender.bsStatus = ButtonCtrlSwitchStatusActive;
                                                                   _accessCount = 0;
                                                                   _changeType = ChangeTypeNone;
                                                                   [self showDropdownViewWithMessage:@"异常，请重试！"];
                                                               }
                                                           }];
            break;
        }
        case WindButtonModeTagTypeFix:
        {
//            if(self.XLinkDevice.FanAirflowMax != self.XLinkDevice.FanAirflowMin){
//                sender.bsStatus = ButtonCtrlSwitchStatusActive;
//                _tvLog.text = [NSString stringWithFormat:@"%@ \n %@", _tvLog.text, @"self.XLinkDevice.FanAirflowMax == self.XLinkDevice.FanAirflowMin"];
//                _accessCount = 0;
//                _changeType = ChangeTypeNone;
//                return;
//            }
            [[HomeKit_DeviceService sharedInstance] setDeivecSpeedWithOpenID:user.openid
                                                                         uid:user.unionid
                                                                         pId:self.XLinkDevice.PhysicalDeviceId
                                                                    platform:@"xlink"
                                                                  deviceType:k360ADeviceType
                                                                         dId:self.XLinkDevice.DeviceID
                                                                    sendData:@"3"
                                                                    minSpeed:[NSString stringWithFormat:@"%ld", (long)fixValue]
                                                                    maxSpeed:[NSString stringWithFormat:@"%ld", (long)fixValue]
                                                             completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                                 HomeKit_BooleanResponse *response = (HomeKit_BooleanResponse *)pServiceResponse;
                                                                 
                                                                 if(response.responseResult){
                                                                     [weakSelf refreshXlinkDeviceDetailWithChangeType:ChangeTypeSpeedFix];
                                                                 }
                                                                 else{
                                                                     sender.bsStatus = ButtonCtrlSwitchStatusActive;
                                                                     _accessCount = 0;
                                                                     _changeType = ChangeTypeNone;
                                                                     [self showDropdownViewWithMessage:@"异常，请重试！"];
                                                                 }
                                                             }];
            break;
        }
        case WindButtonModeTagTypeCustom:
        {
            if(self.XLinkDevice.FanAirflowMax == left && self.XLinkDevice.FanAirflowMin == right){
                sender.bsStatus = ButtonCtrlSwitchStatusActive;
                _accessCount = 0;
                _changeType = ChangeTypeNone;
                return;
            }
            
            [[HomeKit_DeviceService sharedInstance] setDeivecSpeedWithOpenID:user.openid
                                                                         uid:user.unionid
                                                                         pId:self.XLinkDevice.PhysicalDeviceId
                                                                    platform:@"xlink"
                                                                  deviceType:k360ADeviceType
                                                                         dId:self.XLinkDevice.DeviceID
                                                                    sendData:@"1"
                                                                    minSpeed:[NSString stringWithFormat:@"%ld", (long)left]
                                                                    maxSpeed:[NSString stringWithFormat:@"%ld", (long)right]
                                                             completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                                 HomeKit_BooleanResponse *response = (HomeKit_BooleanResponse *)pServiceResponse;
                                                                 
                                                                 if(response.responseResult){
                                                                     [weakSelf refreshXlinkDeviceDetailWithChangeType:ChangeTypeSpeedCustom];
                                                                 }
                                                                 else{
                                                                     sender.bsStatus = ButtonCtrlSwitchStatusActive;
                                                                     _accessCount = 0;
                                                                     _changeType = ChangeTypeNone;
                                                                     [self showDropdownViewWithMessage:@"异常，请重试！"];
                                                                 }
                                                             }];
            
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
//setDeivecSpeedWithOpenID
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
    
    if([self checkIfAccessing]){
        return;
    }
    
    _changeType = ChangeTypeHotSwitch;
    
    HomeKit_ButtonSwitch *btn = sender;
    btn.bsStatus = ButtonSwitchStatusPendding;
    MLWeakSelf weakSelf = self;
    HomeKit_User *user = [HomeKit_UserService sharedInstance].user;
    [[HomeKit_DeviceService sharedInstance] openClosePtcWithOpenID:user.openid
                                                               uid:user.unionid
                                                               pId:self.XLinkDevice.PhysicalDeviceId
                                                          platform:@"xlink"
                                                        deviceType:k360ADeviceType
                                                               dId:self.XLinkDevice.DeviceID
                                                            isOpen:self.XLinkDevice.PTCStatus?@"0":@"1"
                                                          sendData:self.XLinkDevice.PTCStatus?@"0":@"1"
                                                   completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                       HomeKit_BooleanResponse *response = (HomeKit_BooleanResponse *)pServiceResponse;
                                                       
                                                       if(response.responseResult){
//                                                           [weakSelf refreshXlinkDeviceDetail];
                                                           _hotControl = self.XLinkDevice.PTCStatus?0:1;
                                                           [weakSelf refreshXlinkDeviceDetailWithChangeType:ChangeTypeHotSwitch];
                                                       }
                                                       else{
                                                           btn.bsStatus = ButtonSwitchStatusInactive;
                                                           _accessCount = 0;
                                                           _changeType = ChangeTypeNone;
                                                           [self showDropdownViewWithMessage:@"异常，请重试！"];
                                                       }
                                                   }];
    
    
}

- (void)changeScreenLight:(NSInteger)pValue
{
    
    if([self checkIfAccessing]){
        return;
    }
    
    _changeType = ChangeTypeLilghtLevel;
    
    MLWeakSelf weakSelf = self;
    HomeKit_User *user = [HomeKit_UserService sharedInstance].user;
    [[HomeKit_DeviceService sharedInstance] modifyDeviceScreenWithOpenID:user.openid
                                                               uid:user.unionid
                                                               pId:self.XLinkDevice.PhysicalDeviceId
                                                          platform:@"xlink"
                                                        deviceType:k360ADeviceType
                                                               dId:self.XLinkDevice.DeviceID
                                                                sendData:[NSString stringWithFormat:@"%ld", (long)pValue]
                                                   completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                       HomeKit_BooleanResponse *response = (HomeKit_BooleanResponse *)pServiceResponse;
                                                       
                                                       if(response.responseResult){
//                                                           [weakSelf refreshXlinkDeviceDetail];
                                                           _lightControl = pValue;
                                                           [weakSelf refreshXlinkDeviceDetailWithChangeType:ChangeTypeLilghtLevel];
                                                       }
                                                       else{
                                                           _accessCount = 0;
                                                           _changeType = ChangeTypeNone;
                                                           [self showDropdownViewWithMessage:@"异常，请重试！"];
                                                       }
                                                   }];
    
}

- (IBAction)actionForChangingTurn:(id)sender {
   
    [self changeWindEnginToTurnOn: self.XLinkDevice.FanControl == 1 ? 0:1];
}

- (void)changeWindEnginToTurnOn:(BOOL)pTurnOn
{
    if([self checkIfAccessing]){
        return;
    }
    
    _changeType = ChangeTypeFanSwitch;
    MLWeakSelf weakSelf = self;
    HomeKit_User *user = [HomeKit_UserService sharedInstance].user;
    _btnWindEnginSwitch.bsStatus = ButtonSwitchStatusPendding;
    [[HomeKit_DeviceService sharedInstance] openAndCloseFanWithOpenID:user.openid
                                                                  uid:user.unionid
                                                                  pId:self.XLinkDevice.PhysicalDeviceId
                                                             platform:@"xlink"
                                                           deviceType:k360ADeviceType
                                                                  dId:self.XLinkDevice.DeviceID
                                                               isOpen:self.XLinkDevice.FanControl == 1?@"1":@"0"
                                                      completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                          HomeKit_BooleanResponse *response = (HomeKit_BooleanResponse *)pServiceResponse;
                                                          if(response.responseResult){
                                                              _fanControl = self.XLinkDevice.FanControl == 1?0:1;
                                                              [weakSelf refreshXlinkDeviceDetailWithChangeType:ChangeTypeFanSwitch];
                                                          }
                                                          else{
                                                              _btnWindEnginSwitch.bsStatus = ButtonSwitchStatusActive;
                                                              _accessCount = 0;
                                                              _changeType = ChangeTypeNone;
                                                              [self showDropdownViewWithMessage:@"异常，请重试！"];
                                                          }
                                                      }];
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
- (void)accessoryManagerUpdateDevices:(XLinkDevice *_Nullable)pDevices
{
    
    [_btnRefresh stop];
    _bcsWindFixOK.bsStatus = ButtonSwitchStatusActive;
    _bcsWindCustomOK.bsStatus = ButtonSwitchStatusActive;
    _btnWindEnginSwitch.bsStatus = ButtonSwitchStatusActive;
    if(pDevices){
        
        self.title = pDevices.Name;
        if(_refreshIndex == 0){
            _tfName.text = pDevices.Name;
            
        }
        _refreshIndex++;
        
        if(!pDevices.isOnline){
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
        
        //kPurifieHeaterEnable
        if(pDevices.PTCStatus){
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
        if(pDevices.SleepMode == 1){
            [_btnSleepSwitch setBackgroundImage:[UIImage imageNamed:@"sleep_enable.png"] forState:UIControlStateNormal];
        }
        else{
            [_btnSleepSwitch setBackgroundImage:[UIImage imageNamed:@"sleep_disable.png"] forState:UIControlStateNormal];
        }
        
        //kPurifieActive
        if(pDevices.FanControl == 1){
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
        
        
        
        
        _sliderWind.value = pDevices.FanAirflowStatus;
        _lblWindSpped.text = [NSString stringWithFormat:@"%.0f%@", round(_sliderWind.value),@"%"];
        
        
        
        _currentMinWind = pDevices.FanAirflowMin;
        _currentMaxWind = pDevices.FanAirflowMax;
        
        if(pDevices.TargetState == 1){
            _bcsWindIntelligence.bsStatus = ButtonSwitchStatusActive;
            _bcsWindFixed.bsStatus = ButtonSwitchStatusInactive;
            _bcsWindCustom.bsStatus = ButtonSwitchStatusInactive;
            _lblWindModeTitle.text = @"风量模式：智慧巡航";
        }
        else{
            if(_currentMinWind == _currentMaxWind){
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

        _rsLight.leftValue = pDevices.ScreenDimmingSet;
        //display

        
        //pm2.5 description
        NSInteger quality = pDevices.AirQuality;
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
        [_viewPMDescription updatePMDescriptionWithPMValue:pDevices.PM25Data description:description];
        
        _lblPM25Count.text = [NSString stringWithFormat:@"%ld", pDevices.PM25Data];
        
        //wind speed
        NSString *windSpeed = @"-- %";
        NSInteger windValue = pDevices.FanAirflowStatus;
        
        
        if(windValue == 0 || pDevices.FanControl == 0){
            windSpeed = [NSString stringWithFormat:@"%@", @"off"];
            windValue = 0;
        }
        else{
            windSpeed = [NSString stringWithFormat:@"%ld%@", (long)windValue, @"%"];
        }
        
        NSInteger humidity = pDevices.IndoorHumidity;
        
        //wind co2
        NSString *co2 = @"--";
        co2 = [NSString stringWithFormat:@"%ld", pDevices.CO2Data];
        
        [self.paramsView setValuesWithHumidity:humidity co2:co2 speed:windValue];
        
        [_tv reloadData];
        [_tv setNeedsDisplay];
        [ self.paramsView setNeedsDisplay];
        
    }
}



@end
