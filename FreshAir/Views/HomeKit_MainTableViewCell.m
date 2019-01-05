//
//  MainTableViewCell.m
//  FreshAir
//
//  Created by mars on 23/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#define kIfNeedToBindDevice @"IfNeedToBindDevice"

#import "HomeKit_MainTableViewCell.h"
#import "HomeKit_ColorManager.h"
#import "HomeKit_CommonAPI.h"

#import "HomeKit_UserInfoViewController.h"
#import "RefreshIndicatorView.h"

#import "HomeKit_DeviceService.h"
#import "HomeKit_UserService.h"
#import "HomeKit_User.h"
#import "HomeKit_BooleanResponse.h"
#import "HomeKit_StringResponse.h"

#import "XLinkDevice.h"
#import "NSObject+ML.h"

@interface HomeKit_MainTableViewCell()
{
    
    
    NSTimer *_timerDeviceInfo;
    BOOL _refreshing;
    
    
//    #pragma mark - for 1.5.0
    NSMutableDictionary *_mdThreeSecondTime;
    //3 time to access the xlink
    NSInteger _failedTime;
    
    BOOL _prevousReachable;
    
    AFNetworkReachabilityStatus _prevoiusNetworkStatus;
}
@end

@implementation HomeKit_MainTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    
        [self setPandingState];
        self.btnCloud.hidden = YES;
        self.deviceIsOnLine = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)engines{
    
}

- (void)setSerialNumber:(NSString *)serialNumber{
    _serialNumber = serialNumber;
    if(serialNumber){
        if([[NSUserDefaults standardUserDefaults] valueForKey:serialNumber]){
            self.mac = [[NSUserDefaults standardUserDefaults] valueForKey:serialNumber];
        }
        else{
            [[HomeKit_DeviceService sharedInstance] getXlinkDeviceInfoBySnWithSN:serialNumber completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                if(pServiceResponse.success){
                    HomeKit_StringResponse *response = (HomeKit_StringResponse *)pServiceResponse;
                    
                    if(response.responseResult.length != 0){
                        [[NSUserDefaults standardUserDefaults] setValue:response.responseResult forKey:serialNumber];
                        self.mac = response.responseResult;
                    }
                    
                }
                
                
            }];
        }
    }
    if([[NSUserDefaults standardUserDefaults] valueForKey:kWechatUserJsonKey] == nil){
        _btnCloud.hidden = YES;
    }
    
}


- (void)layoutSubviews
{
    
    [super layoutSubviews];
    self.viewCellContanetPanel.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    self.lblDeviceName.textColor = [[HomeKit_ColorManager sharedInstance] textWithDarkGray];
    self.lblWindQuantityValue.textColor = [[HomeKit_ColorManager sharedInstance] textWithLightBlue];
    self.lblWindQuantityTitle.textColor = [[HomeKit_ColorManager sharedInstance] textWithGray];
    self.lblHot.textColor = [[HomeKit_ColorManager sharedInstance] textWithLightBlue];
    self.lblOfflineAlert.textColor = [[HomeKit_ColorManager sharedInstance] textWithGray];
    
    self.lblPMValue.textColor = [[HomeKit_ColorManager sharedInstance] textWithLightBlue];
    self.lblPMUnit.textColor = [[HomeKit_ColorManager sharedInstance] textWithLightBlue];
    
    self.lblEnviromentIndex.textColor = [[HomeKit_ColorManager sharedInstance] textWithGray];
    self.lblTemperatureValue.textColor = [[HomeKit_ColorManager sharedInstance] textWithGray];
    self.lblHumidityValue.textColor = [[HomeKit_ColorManager sharedInstance] textWithGray];
    self.lblCo2Value.textColor = [[HomeKit_ColorManager sharedInstance] textWithGray];
    
    self.viewSplit.backgroundColor = [[HomeKit_ColorManager sharedInstance] viewBgWithGray];
    self.viewRowMark.backgroundColor = [[HomeKit_ColorManager sharedInstance] viewBgWithLightGreen];
    
    self.viewCellPanel.layer.cornerRadius = 5.0;
    self.viewCellPanel.layer.borderColor = [[HomeKit_ColorManager sharedInstance] viewBgWithGray].CGColor;
    self.viewCellPanel.layer.borderWidth = 1.0;
    self.viewCellPanel.clipsToBounds = YES;
    
    self.viewRowMark.alpha = .7;
    
    self.viewRowMark.backgroundColor = [[HomeKit_CommonAPI sharedInstance] getColorWithValue:self.pm25Value];
}

#pragma mamrk - system mehtods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.viewCellContanetPanel.backgroundColor =  [[HomeKit_ColorManager sharedInstance] viewCellBgSelected];
    self.viewRowMark.backgroundColor = [[HomeKit_ColorManager sharedInstance] viewCellBgSelected];
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.viewCellContanetPanel.backgroundColor = [UIColor clearColor];
    self.viewRowMark.backgroundColor = [[HomeKit_CommonAPI sharedInstance] getColorWithValue:self.pm25Value];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    self.viewCellContanetPanel.backgroundColor = [UIColor whiteColor];
    self.viewRowMark.backgroundColor = [[HomeKit_CommonAPI sharedInstance] getColorWithValue:self.pm25Value];
    [super touchesCancelled:touches withEvent:event];
}

- (IBAction)actionForBind:(UIButton *)sender {
    
    //if true then go to login
    if(![[NSUserDefaults standardUserDefaults] valueForKey:kWechatUserJsonKey]){
        if([self.mainTableViewCellDelegate respondsToSelector:@selector(loginWithDeviceSerial:)]){
            [self.mainTableViewCellDelegate loginWithDeviceSerial:self.serialNumber];
            
            //save the serialNumber for bind when logined
            if(self.serialNumber)
            [[NSUserDefaults standardUserDefaults] setValue:self.serialNumber forKey:kIfNeedToBindDevice];
        }
    }
    else{
        [self bindDevice];
    }
    
    
}

- (void)bindDevice{
    MLWeakSelf weakSelf = self;
    
    if(self.mac){
        [weakSelf tryToRegisterWithMac:self.mac];
    }
    else{
        [[HomeKit_DeviceService sharedInstance] getXlinkDeviceInfoBySnWithSN:self.serialNumber completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
            if(pServiceResponse.success){
                HomeKit_StringResponse *response = (HomeKit_StringResponse *)pServiceResponse;
                [weakSelf tryToRegisterWithMac:response.responseResult];
                
            }
        }];
        
    }
}

- (void)tryToRegisterWithMac:(NSString *)pMac
{
    
    if(pMac.length == 0 && _vcMain){
        [_vcMain showDropdownViewWithMessage:@"获取设备信息错误"];
        return;
    }
    
    MLWeakSelf weakSelf = self;
    [[HomeKit_DeviceService sharedInstance] checkIfXLinkServiceByOtherBind:pMac completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
        HomeKit_BooleanResponse *response = (HomeKit_BooleanResponse *)pServiceResponse;
        if(!response.responseResult){
            if(pServiceResponse.success){
                [weakSelf reggisterDeviceWithPysycalID:pMac];
            }
        }
        else{
            //alert
            if(_vcMain)
            [_vcMain showDropdownViewWithMessage:@"设备已被其他用户绑定"];
        }
        
    }];
}

- (void)reggisterDeviceWithPysycalID:(NSString *)pPysycalID
{
    HomeKit_DeviceService *service = [HomeKit_DeviceService sharedInstance];
    HomeKit_UserService *userService = [HomeKit_UserService sharedInstance];
    
    
    [service reBindingDeviceWithPID:pPysycalID
                                did:@""
                               cDId:@""
                                 sn:self.serialNumber
                           platform:@"xlink"
                                uId:userService.user.unionid
                             openID:userService.user.openid
                    completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                        HomeKit_BooleanResponse *response = (HomeKit_BooleanResponse *)pServiceResponse;
                        if(!response.responseResult){
                            HomeKit_UserInfoViewController *vcUserInfo = (HomeKit_UserInfoViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"UserInfoViewController"];
                            vcUserInfo.deviceID = pPysycalID;
                            vcUserInfo.deviceSN = self.serialNumber;
                            if(self.vcMain){
                                [self.vcMain.navigationController pushViewController:vcUserInfo animated:YES];
                            }
                        }
                        else{
                            
                        }
                    }];
}

- (void)setPandingState
{
    self.deviceIsOnLine = NO;
    self.btnCloud.hidden = YES;
    self.lblOfflineAlert.hidden = YES;
    self.lblOfflineAlert.text = @"设备离线";
    
    self.pm25Value = 0;
    
    self.lblHot.text = @"-";
    
    self.lblPMUnit.hidden = YES;
    self.lblPMValue.hidden = YES;
    
    
    self.lblHumidityValue.text = @"-";
    self.lblCo2Value.text = @"-";
    self.lblTemperatureValue.text = @"-°";
    self.lblWindQuantityValue.text = [NSString stringWithFormat:@"%@%@", @"-", @"%"];
    
    HMAccessory *accessory = (HMAccessory *)[self.mdDevice objectForKey:kPurifier];
    NSString *enviromentTitle = [NSString stringWithFormat:@"%@环境指数", accessory.room.name];
    enviromentTitle = [enviromentTitle stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    self.lblEnviromentIndex.text = [NSString stringWithFormat:@"%@", enviromentTitle];
     [self.aiCicle start];
}

- (void)setOfflineLabels
{
    
    self.deviceIsOnLine = NO;
    [self.aiCicle stop];
    self.lblOfflineAlert.hidden = NO;
    self.lblOfflineAlert.text = @"设备离线";
    
    self.pm25Value = 0;
    
    self.lblHot.text = @"-";
    
    self.lblPMUnit.hidden = YES;
    self.lblPMValue.hidden = YES;
    
    
    self.lblHumidityValue.text = @"-";
    self.lblCo2Value.text = @"-";
    self.lblTemperatureValue.text = @"-°";
    self.lblWindQuantityValue.text = [NSString stringWithFormat:@"%@%@", @"-", @"%"];
    
    HMAccessory *accessory = (HMAccessory *)[self.mdDevice objectForKey:kPurifier];
    self.lblEnviromentIndex.text = [NSString stringWithFormat:@"%@ 环境指数", accessory.room.name];
    self.btnCloud.hidden = YES;
}



- (void)hiddenCloudWithOwner:(BOOL)pOwner
{
//    self.btnCloud.hidden = !pOwner;
}

#pragma mark - for 1.5.0
- (void)refreshXLink
{
    
    //search the device in list
    __block BOOL exist = NO;
    [[HomeKit_DeviceService sharedInstance].maXLinkDevices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XLinkDevice *device = obj;
        HomeKit_User *user = [HomeKit_UserService sharedInstance].user;
        
        if(device.Cid == nil){
            if([device.PhysicalDeviceId isEqualToString:self.mac]){
                [[HomeKit_DeviceService sharedInstance] refreshXLinkDevice:device
                                                                       uid:user.unionid
                                                                    openID:user.openid
                                                                      time:_failedTime
                                                           completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                               if(pServiceResponse.success){
                                                                   _failedTime = 0;
                                                               }
                                                               else{
                                                                   _failedTime++;
                                                               }
                                                           }];
            }
        }
        else
            if([device.Cid isEqualToString:self.serialNumber]){
                self.XLinkDevice = device;
                XLinkDevice *xLinkDevice = device;
                xLinkDevice.Name = [[self.mdDevice objectForKey:kPurifierName] ml_stringValue];
                [self updateCellWithXLinkDevice:xLinkDevice];
                
                exist = YES;
                
                
                [[HomeKit_DeviceService sharedInstance] refreshXLinkDevice:xLinkDevice
                                                                       uid:user.unionid
                                                                    openID:user.openid
                                                                      time:_failedTime
                                                           completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                               if(pServiceResponse.success){
                                                                   _failedTime = 0;
                                                               }
                                                               else{
                                                                   _failedTime++;
                                                               }
                                                           }];
                
                *stop = YES;
            }
    }];
    
    if(exist == NO){
        [self setOfflineLabels];
    }
    
}

- (void)checkIfConnectXlinkService
{
        if(![HomeKit_DeviceService sharedInstance].hasGotXLinkList) self.btnCloud.hidden = YES;
    
        MLWeakSelf weakSelf = self;
        if(![[NSUserDefaults standardUserDefaults] valueForKey:kWechatUserJsonKey] && self.owner){
            _btnCloud.hidden = !self.reachable;
        }
        else if([[NSUserDefaults standardUserDefaults] valueForKey:kWechatUserJsonKey] && (self.serialNumber || self.mac))
        [[HomeKit_DeviceService sharedInstance] checkIfXLinkServiceWithSerial:self.serialNumber pId:self.mac completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
            HomeKit_BooleanResponse *response = (HomeKit_BooleanResponse *)pServiceResponse;
            if([HomeKit_DeviceService sharedInstance].hasGotXLinkList)
            if(self.owner && [[NSUserDefaults standardUserDefaults] valueForKey:kWechatUserJsonKey] != nil && !response.responseResult){
                self.btnCloud.hidden = !self.reachable;
                if([[[NSUserDefaults standardUserDefaults] valueForKey:kIfNeedToBindDevice] isEqualToString:self.serialNumber]){
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kIfNeedToBindDevice];
                    [weakSelf bindDevice];
                }
            }
    
            if(response.responseResult){
    
                _btnCloud.hidden = YES;
    
            }
            else{
                [_btnCloud setImage:[UIImage imageNamed:@"text_cloud_disable"] forState:UIControlStateNormal];
            }
        }];
}

- (void)updateDeviceWithNetworkStatus:(AFNetworkReachabilityStatus)pNetworkStatus
                            reachable:(BOOL)pReachable
                               serial:(NSString *)pSerial
                        homeKitDevice:(NSMutableDictionary *)pHomeKitDevice
{
    if(_prevoiusNetworkStatus != pNetworkStatus || _prevousReachable != pReachable){
        if(_mdThreeSecondTime){
            [_mdThreeSecondTime removeAllObjects];
            _mdThreeSecondTime = nil;
        }
        
        if(_timerDeviceInfo){
            [_timerDeviceInfo invalidate];
            _timerDeviceInfo = nil;
        }
        
        self.deviceIsOnLine = NO;
        _failedTime = 0;
    }
    
    switch (pNetworkStatus) {
        case AFNetworkReachabilityStatusReachableViaWiFi:{
            
            [self checkIfConnectXlinkService];
            
            [self connect360ServiceWithReachable:pReachable homeKitDevice:pHomeKitDevice networkStatus:pNetworkStatus];
            
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWWAN:{
            
            [self connect360ServiceWithReachable:pReachable homeKitDevice:pHomeKitDevice networkStatus:pNetworkStatus];
            
            break;
        }
        default:
        {
            [self setOfflineLabels];
            
            [_mdThreeSecondTime removeAllObjects];
            _mdThreeSecondTime = nil;
            
            [_timerDeviceInfo invalidate];
            _timerDeviceInfo = nil;
            
            break;
        }
    }
    _prevousReachable = pReachable;
    _prevoiusNetworkStatus = pNetworkStatus;
}

- (void)connect360ServiceWithReachable:(BOOL)pReachable
                      homeKitDevice:(NSMutableDictionary *)pHomeKitDevice
                         networkStatus:(AFNetworkReachabilityStatus)pNetworkStatus
{
    if(pReachable){
        
        [self connectXLinkServiceWhenReachableIsYesWithHomeKitDevice:pHomeKitDevice networkStatus:pNetworkStatus];
        
    }
    else{
        if(![[NSUserDefaults standardUserDefaults] valueForKey:kWechatUserJsonKey] || !self.owner){
            [self setOfflineLabels];
        }
        else{
            // go to xlink
            [self prepareToConnectXlink];
        }
        
        [_mdThreeSecondTime removeAllObjects];
        _mdThreeSecondTime = nil;
    }
}
//set _failedTime to zero, when network switch or reachable was changed
//reachable is Yes, if 4g first is xlink, if wifi first is homekit
- (void)connectXLinkServiceWhenReachableIsYesWithHomeKitDevice:(NSMutableDictionary *)pHomeKitDevice
                                                 networkStatus:(AFNetworkReachabilityStatus)pNetworkStatus
{
    if(pNetworkStatus == AFNetworkReachabilityStatusReachableViaWiFi || _failedTime > 3){
        if(!_mdThreeSecondTime){
            //init dic and use current co2 value to fill in dic
            _mdThreeSecondTime = [NSMutableDictionary dictionary];
            NSString *currentCo2Value = [NSString stringWithFormat:@"%d", [((HMCharacteristic *)[pHomeKitDevice objectForKey:kPurifieCo2Density]).value ml_intValue]];
            [_mdThreeSecondTime setValue:currentCo2Value forKey:@"Co2Key"];
            [_mdThreeSecondTime setValue:[NSDate date] forKey:@"TimeKey"];
        }
        else{
            //for co2
            NSString *previousCo2Value = [_mdThreeSecondTime valueForKey:@"Co2Key"];
            NSString *currentCo2Value = [NSString stringWithFormat:@"%d", [((HMCharacteristic *)[pHomeKitDevice objectForKey:kPurifieCo2Density]).value ml_intValue]];
            //for time
            NSDate *previousTime = [_mdThreeSecondTime valueForKey:@"TimeKey"];
            NSDate *currentTime = [NSDate date];
            if([previousCo2Value isEqualToString:currentCo2Value] && [currentTime timeIntervalSinceDate:previousTime] > 10){
                //than grater 3s, go to xlink
                if(!_timerDeviceInfo)
                    [self prepareToConnectXlink];
            }
            else{
                
                if(![previousCo2Value isEqualToString:currentCo2Value]){
                    [_mdThreeSecondTime setValue:currentCo2Value forKey:@"Co2Key"];
                }
                
                //iCloud
                [self updateCellWithHomeKitDevice:pHomeKitDevice];
                
                if(_timerDeviceInfo){
                    [_timerDeviceInfo invalidate];
                    _timerDeviceInfo = nil;
                }
            }
        }
    }
    
    //first is xlink, try 3 times that all are not, then connect to homekit by icloud
    if(pNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN && _failedTime <= 3){
        [self prepareToConnectXlink];
    }
    
}

- (void)prepareToConnectXlink
{
    if(!_timerDeviceInfo)
        _timerDeviceInfo = [NSTimer scheduledTimerWithTimeInterval:10
                                                            target:self
                                                          selector:@selector(refreshXLink)
                                                          userInfo:nil
                                                           repeats:YES];
    
}

- (void)updateCellWithHomeKitDevice:(NSMutableDictionary *)pHomeKitDevice
{
    self.viewCellPanel.backgroundColor = RGB(255, 255, 255);
    
    self.lblOfflineAlert.hidden = YES;
   
    
    if([((HMCharacteristic *)[pHomeKitDevice objectForKey:kPurifieHeaterEnable]).value ml_intValue] == 1){
        self.lblHot.text = @"on";
        self.ivHotIcon.image = [UIImage imageNamed:@"hot_icon_on"];
    }
    else{
        self.ivHotIcon.image = [UIImage imageNamed:@"hot_icon_off"];
        self.lblHot.text = @"off";
    }
    
    self.lblPMUnit.hidden = NO;
    self.lblPMValue.hidden = NO;
    self.lblPMValue.text = [NSString stringWithFormat:@"%d", [((HMCharacteristic *)[pHomeKitDevice objectForKey:kPurifiePM25]).value ml_intValue]];
    self.pm25Value = [((HMCharacteristic *)[pHomeKitDevice objectForKey:kPurifiePM25]).value ml_intValue];
    
    self.lblHumidityValue.text = [NSString stringWithFormat:@"%d", [((HMCharacteristic *)[pHomeKitDevice objectForKey:kPurifieCurrentHumidity]).value ml_intValue]];
    self.lblCo2Value.text = [NSString stringWithFormat:@"%d", [((HMCharacteristic *)[pHomeKitDevice objectForKey:kPurifieCo2Density]).value ml_intValue]];
    self.lblTemperatureValue.text = [NSString stringWithFormat:@"%d", [((HMCharacteristic *)[pHomeKitDevice objectForKey:kPurifieCurrentTemperature]).value ml_intValue]];
    
    NSInteger wind = [((HMCharacteristic *)[pHomeKitDevice objectForKey:kPurifieSpeed]).value ml_intValue];
    if(wind == 0){
        self.lblWindQuantityValue.text = [NSString stringWithFormat:@"%@", @"off"];
    }
    else{
        self.lblWindQuantityValue.text = [NSString stringWithFormat:@"%ld%@", (long)wind, @"%"];
    }
    self.deviceIsOnLine = YES;
    self.lblEnviromentIndex.text = [NSString stringWithFormat:@"%@ 环境指数", ((HMAccessory *)[pHomeKitDevice objectForKey:kPurifier]).room.name];
    
     [self.aiCicle stop];
    self.fromHomeKit = YES;
}

- (void)updateCellWithXLinkDevice:(XLinkDevice *)pXlinkDevice
{
    if(kIsDebug){
        self.viewCellPanel.backgroundColor = RGB(246, 251, 253);
    }
    
    
    self.lblOfflineAlert.hidden = YES;
    
    
    if(pXlinkDevice.PTCStatus){
        self.lblHot.text = @"on";
        self.ivHotIcon.image = [UIImage imageNamed:@"hot_icon_on"];
    }
    else{
        self.ivHotIcon.image = [UIImage imageNamed:@"hot_icon_off"];
        self.lblHot.text = @"off";
    }
    
    self.lblPMUnit.hidden = NO;
    self.lblPMValue.hidden = NO;
    
    self.pm25Value = pXlinkDevice.PM25Data;
    self.lblPMValue.text = [NSString stringWithFormat:@"%ld", (long)self.pm25Value];
    
    self.lblHumidityValue.text = [NSString stringWithFormat:@"%ld", (long)pXlinkDevice.IndoorHumidity];
    self.lblCo2Value.text = [NSString stringWithFormat:@"%ld", (long)pXlinkDevice.CO2Data];
    self.lblTemperatureValue.text = [NSString stringWithFormat:@"%ld", (long)pXlinkDevice.IndoorTemperature];
    
    NSInteger wind = pXlinkDevice.FanAirflowStatus;
    if(wind == 0 || pXlinkDevice.FanControl == 0){
        self.lblWindQuantityValue.text = [NSString stringWithFormat:@"%@", @"off"];
    }
    else{
        self.lblWindQuantityValue.text = [NSString stringWithFormat:@"%ld%@", (long)wind, @"%"];
    }
    
    self.lblEnviromentIndex.text = [NSString stringWithFormat:@"%@ 环境指数", ((HMAccessory *)[self.mdDevice objectForKey:kPurifier]).room.name];
    self.deviceIsOnLine = YES;
    
    [self.aiCicle stop];
    self.fromHomeKit = NO;
}


@end
