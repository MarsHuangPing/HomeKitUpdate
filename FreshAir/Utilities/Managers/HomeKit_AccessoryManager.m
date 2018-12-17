//
//  AccessoryManager.m
//  FreshAir
//
//  Created by mars on 27/11/2017.
//  Copyright © 2017 mars. All rights reserved.
//




#import "HomeKit_AccessoryManager.h"
#import "HomeKit_DeviceStatusRoler.h"
#import "NSObject+ML.h"


typedef  void(^completionSearchDeviceBlock)(HMAccessory *result);

@interface HomeKit_AccessoryManager()<HMAccessoryBrowserDelegate, HMAccessoryDelegate, HMHomeManagerDelegate, HMHomeDelegate>
{
    completionSearchDeviceBlock _completionSearch;
//    NSMutableDictionary *_mdCha;
    NSMutableArray *_maAccessories;
    NSMutableDictionary *_mdReadCha;
    
    NSMutableDictionary *_mdFirst;
    
    NSDate *_privousExcuteReadValue;
    
    BOOL _toDoRead;
    
    BOOL _protectOfflineReachable;
    
    BOOL _searchedDevice;
    
    NSMutableDictionary *_mdEnabling;
}


@property (nonatomic, strong) HMAccessoryBrowser *browser;
@property (nonatomic, strong) NSArray *arrAccessories;



@end

@implementation HomeKit_AccessoryManager

+ (HomeKit_AccessoryManager *)sharedInstance
{
    static HomeKit_AccessoryManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeKit_AccessoryManager alloc] init];
        
    });
    
    return sharedInstance;
}

- (id)init{
    if(self = [super init]){
        //注册  已经获取到全部home信息的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomesNotify) name:kGetHomeNotification object:nil];
        [self initMyHomeKit];
        
        _maAccessories = [NSMutableArray array];
        _isUpgrading = [NSMutableDictionary dictionary];
        _upgradeWIFI = [NSMutableDictionary dictionary];
        
        _mdReadCha = [NSMutableDictionary dictionary];
        //        homeManager access
        _mdTimeOutContainer = [NSMutableDictionary dictionary];
        _mdFromBackEndCotainer = [NSMutableDictionary dictionary];
        _mdEnabling = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)initMyHomeKit
{
    self.homeManager = [[HMHomeManager alloc] init];
    self.homeManager.delegate = self;
    self.currentHome = self.homeManager.primaryHome;
    self.currentHome.delegate = self;
    //    self.currentHome refres
    
}

- (BOOL)checkCurrrentUserIsAdmin
{
    HMHome *home = self.currentHome;
    HMUser *user = home.currentUser;
    HMHomeAccessControl *accessControl = [home homeAccessControlForUser:user];
    
    return accessControl.administrator;
}

#pragma mark -
#pragma mark HMHomeManagerDelegate
- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager{
    NSString *log = [NSString stringWithFormat:@"已经获取到homes数据：%@",manager.homes];
    kDebugLog(log);
    //init current home
    if(self.homeManager.homes.count != 0 & self.currentHome == nil){
        self.currentHome = self.homeManager.homes[0];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kGetHomeNotification object:nil userInfo:nil];
}

- (void)home:(HMHome *)home didUnblockAccessory:(HMAccessory *)accessory;
{
    kDebugLog(@"didUnblockAccessory............");
}

- (void)home:(HMHome *)home didEncounterError:(NSError*)error forAccessory:(HMAccessory *)accessory;
{
    kDebugLog(@"didEncounterError............");
}

- (void)home:(HMHome *)home didUpdateHomeHubState:(HMHomeHubState)homeHubState
{
    kDebugLog(@"didUpdateHomeHubState............");
}

#pragma mark -
#pragma mark 通知回调方法
- (void)getHomesNotify{
    
    __block BOOL valid = NO;
    [self.homeManager.homes enumerateObjectsUsingBlock:^(HMHome * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.name isEqualToString:self.currentHome.name]){
            valid = YES;
            
            
        }
    }];
    
    self.arrAccessories = self.currentHome.accessories;
    
    if(!valid){
        self.currentHome = nil;
        self.arrAccessories = [NSArray array];
    }
    
    
    [self actionForControllingAc];
    
}

- (void)actionForControllingAc {
    [_maAccessories removeAllObjects];
    for(HMAccessory *acc in self.arrAccessories){
        
        
        BOOL isAirburg = NO;
        
        if(acc.model != nil){
            if([acc.model isEqualToString:@"NEX-360A"] || [acc.model isEqualToString:@"ZEN-168A"] || [acc.model isEqualToString:@"LUX-180"] || [acc.model isEqualToString:@"LUX-180A"]){
                isAirburg = YES;
            }
        }
        
        
        if(isAirburg){
            acc.delegate = self;
            
            NSMutableDictionary *mdCha = [NSMutableDictionary dictionary];
            [mdCha setObject:acc.name forKey:kPurifierName];
            [mdCha setObject:acc forKey:kPurifier];
            
            
            NSArray *arrService = acc.services;
            for(HMService *service in arrService){
                
                NSArray *arrCharac = service.characteristics;
                
                for(HMCharacteristic *charac in arrCharac){
                    
                    
                    
                    if([kPurifieSpeed isEqualToString:charac.characteristicType] || [kPurifieSpeedCustom isEqualToString:charac.characteristicType] || [kPurifieActive isEqualToString:charac.characteristicType]){
                        [charac enableNotification:YES completionHandler:^(NSError * _Nullable error) {}];
                    }
                    
                    
                    if([charac.characteristicType isEqualToString:kPurifieManufacturer]){
                        [mdCha setObject:charac.value?charac.value:@"" forKey:kPurifieManufacturer];
                    }
                    if([charac.characteristicType isEqualToString:kPurifieModel]){
                        [mdCha setObject:charac.value?charac.value:@"" forKey:kPurifieModel];
                    }
                    if([charac.characteristicType isEqualToString:kPurifieSerial]){
                        [mdCha setObject:charac.value?charac.value:@"" forKey:kPurifieSerial];
                        
                        
                    }
                    if([charac.characteristicType isEqualToString:kPurifieFirmware]){
                        [mdCha setObject:charac.value?charac.value:@"" forKey:kPurifieFirmware];
                    }
                    
                    [mdCha setObject:charac forKey:charac.characteristicType];
                    
                    
                    //error handle
                    if([kPurifieCustomDefinedSystemDiagnostics_PM25SensorError isEqualToString:charac.characteristicType] && [charac.value ml_intValue] == 1){
                        [mdCha setObject:@"传感器故障" forKey:kPurifieErrorMessage];
                    }
                    if([kPurifieCustomDefinedSystemDiagnostics_MotorSensorError isEqualToString:charac.characteristicType] && [charac.value ml_intValue] == 1){
                        [mdCha setObject:@"风机故障" forKey:kPurifieErrorMessage];
                    }
                    
                    if([kPurifieCustomDefinedSystemDiagnostics_DisplaySensorError isEqualToString:charac.characteristicType] && [charac.value ml_intValue] == 1){
                        [mdCha setObject:@"显示屏故障" forKey:kPurifieErrorMessage];
                    }
                }
            }
            //            [self enableNotificationWithDevice:mdCha];
            [_maAccessories addObject:mdCha];
            
        }
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(accessoryManagerUpdateDevices:)]) {
        [self.delegate accessoryManagerUpdateDevices:[self filterDeviceWithDevices:_maAccessories]];
    }
    
}


- (void)enableNotificationWithDevice:(NSMutableDictionary *)pDevice{
    
    //1
    HMCharacteristic *chakPurifieSpeed = [pDevice objectForKey:kPurifieSpeed];
    [chakPurifieSpeed readValueWithCompletionHandler:^(NSError * _Nullable error) { }];
    [chakPurifieSpeed enableNotification:YES completionHandler:^(NSError * _Nullable error) {
        //2
        HMCharacteristic *chakPurifiePM25 = [pDevice objectForKey:kPurifiePM25];
        [chakPurifiePM25 enableNotification:YES completionHandler:^(NSError * _Nullable error) {
            //3
            HMCharacteristic *chakPurifieCo2Density = [pDevice objectForKey:kPurifieCo2Density];
            [chakPurifieCo2Density enableNotification:YES completionHandler:^(NSError * _Nullable error) {
                //4
                HMCharacteristic *chakPurifieCurrentHumidity = [pDevice objectForKey:kPurifieCurrentHumidity];
                [chakPurifieCurrentHumidity enableNotification:YES completionHandler:^(NSError * _Nullable error) {
                    //5
                    HMCharacteristic *chakPurifieStartUpgrade = [pDevice objectForKey:kPurifieStartUpgrade];
                    [chakPurifieStartUpgrade enableNotification:YES completionHandler:^(NSError * _Nullable error) {
                        //6
                        HMCharacteristic *chakPurifieUpgradeResult = [pDevice objectForKey:kPurifieUpgradeResult];
                        [chakPurifieUpgradeResult enableNotification:YES completionHandler:^(NSError * _Nullable error) {
                            //7
                            HMCharacteristic *chakPurifieUpgradeProgress = [pDevice objectForKey:kPurifieUpgradeProgress];
                            [chakPurifieUpgradeProgress enableNotification:YES completionHandler:^(NSError * _Nullable error) {
                                //8
                                HMCharacteristic *chakPurifieIndication = [pDevice objectForKey:kPurifieIndication];
                                [chakPurifieIndication enableNotification:YES completionHandler:^(NSError * _Nullable error) {
                                    //9
                                    HMCharacteristic *chakPurifieHeaterEnable = [pDevice objectForKey:kPurifieHeaterEnable];
                                    [chakPurifieHeaterEnable enableNotification:YES completionHandler:^(NSError * _Nullable error) {
                                        //10
                                        HMCharacteristic *chakPurifieSleepMode = [pDevice objectForKey:kPurifieSleepMode];
                                        [chakPurifieSleepMode enableNotification:YES completionHandler:^(NSError * _Nullable error) {
                                            
                                        }];
                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

- (NSMutableArray *)filterDeviceWithDevices:(NSMutableArray *_Nullable)pDevices{
    
    
//    NSMutableArray *maDevices = [NSMutableArray array];
//
//    for(NSInteger i = 0; i < pDevices.count; i++){
//
//        HMAccessory *ac = (HMAccessory *)[[pDevices objectAtIndex:i] objectForKey:kPurifier];
//        NSString *outerName = ac.name;
//        NSString *serial = [((HMCharacteristic *)[[pDevices objectAtIndex:i] objectForKey:kPurifierSerialNumber]).value ml_stringValue];
//        __block NSInteger count = 0;
//        __block BOOL ifHasReachable = NO;
//
//        for(NSInteger j = 0; j < pDevices.count; j++){
//            HMAccessory *innerAc = (HMAccessory *)[[pDevices objectAtIndex:j] objectForKey:kPurifier];
//            NSString *innerSerial = [((HMCharacteristic *)[[pDevices objectAtIndex:j] objectForKey:kPurifierSerialNumber]).value ml_stringValue];
//            NSMutableDictionary *md = [pDevices objectAtIndex:j];//[[pDevices objectAtIndex:i] objectForKey:kPurifierSerialNumber];
//            HMCharacteristic *cha = [md objectForKey:kPurifierSerialNumber];
//            id value = cha.value;
//            NSString *innerName = innerAc.name;
//            if(value){
//                if([innerSerial isEqualToString:serial]){
//                    count++;
//                    if(innerAc.reachable){
//                        ifHasReachable = YES;
//                    }
//                }
//            }
//            else{
//                if([outerName isEqualToString:innerName]){
//                    count++;
//                    if(innerAc.reachable){
//                        ifHasReachable = YES;
//                    }
//                }
//            }
//
//        }
//        if(count >= 2){
//            if(ifHasReachable && ac.reachable){
//                [maDevices addObject:[pDevices objectAtIndex:i]];
//            }
//            if(!ifHasReachable){
//                BOOL ifHasDevice = NO;
//                for(NSInteger arrI = 0; arrI < maDevices.count; arrI++){
//                    HMAccessory *arrAc = (HMAccessory *)[[pDevices objectAtIndex:arrI] objectForKey:kPurifier];
//                    if([arrAc.name isEqualToString:ac.name]){
//                        ifHasDevice = YES;
//                        break;
//                    }
//                }
//                if(!ifHasDevice){
//                    [maDevices addObject:[pDevices objectAtIndex:i]];
//                }
//            }
//        }
//
//
//        if(count == 1){
//            [maDevices addObject:[pDevices objectAtIndex:i]];
//        }
//    }
    
    
    NSMutableArray *maDevices = [NSMutableArray array];
    
    for(NSInteger i = 0; i < pDevices.count; i++){
        
        HMAccessory *ac = (HMAccessory *)[[pDevices objectAtIndex:i] objectForKey:kPurifier];
        NSString *outerName = ac.name;
        NSString *serial = [((HMCharacteristic *)[[pDevices objectAtIndex:i] objectForKey:kPurifierSerialNumber]).value ml_stringValue];
        __block NSInteger count = 0;
        __block BOOL ifHasReachable = NO;
        
        NSInteger maxIndexAt = 0;
        
        for(NSInteger j = 0; j < pDevices.count; j++){
            HMAccessory *innerAc = (HMAccessory *)[[pDevices objectAtIndex:j] objectForKey:kPurifier];
            NSString *innerSerial = [((HMCharacteristic *)[[pDevices objectAtIndex:j] objectForKey:kPurifierSerialNumber]).value ml_stringValue];
            
            NSString *innerName = innerAc.name;
            if([innerSerial isEqualToString:serial] || [outerName isEqualToString:innerName]){
                count++;
                maxIndexAt = j;
                if(innerAc.reachable){
                    ifHasReachable = YES;
                }
            }
            
        }
        if(count >= 2){
//            if(ifHasReachable && ac.reachable){
//                [maDevices addObject:[pDevices objectAtIndex:i]];
//            }
//
//            if(!ifHasReachable){
//
//
//
//                BOOL ifHasDevice = NO;
//                for(NSInteger arrI = 0; arrI < maDevices.count; arrI++){
//                    HMAccessory *arrAc = (HMAccessory *)[[maDevices objectAtIndex:arrI] objectForKey:kPurifier];
//                    NSString *innerSerial = [((HMCharacteristic *)[[maDevices objectAtIndex:arrI] objectForKey:kPurifierSerialNumber]).value ml_stringValue];
//                    if([arrAc.name isEqualToString:ac.name] || [innerSerial isEqualToString:serial]){
//                        ifHasDevice = YES;
//                        break;
//                    }
//                }
//                //如果当前数组里面没有，则添加后面那个设备
//                if(!ifHasDevice){
//                    [maDevices addObject:[pDevices objectAtIndex:maxIndexAt]];
//                }
//            }
            
            BOOL ifHasDevice = NO;
            for(NSInteger arrI = 0; arrI < maDevices.count; arrI++){
                HMAccessory *arrAc = (HMAccessory *)[[maDevices objectAtIndex:arrI] objectForKey:kPurifier];
                NSString *innerSerial = [((HMCharacteristic *)[[maDevices objectAtIndex:arrI] objectForKey:kPurifierSerialNumber]).value ml_stringValue];
                if([arrAc.name isEqualToString:ac.name] || [innerSerial isEqualToString:serial]){
                    ifHasDevice = YES;
                    break;
                }
            }
            //如果当前数组里面没有，则添加后面那个设备
            if(!ifHasDevice){
                [maDevices addObject:[pDevices objectAtIndex:maxIndexAt]];
            }
        }
        
        
        if(count == 1){
            [maDevices addObject:[pDevices objectAtIndex:i]];
        }
    }
    
    return maDevices;
}

- (void)readValueWithAccessories:(NSMutableArray *)pAccessories
{
    
    //    for(NSMutableDictionary *md in pAccessories){
    //
    //        for(NSInteger i = 0; i < md.allKeys.count; i++){
    //            if([md[md.allKeys[i]] isKindOfClass:[HMCharacteristic class]])
    //                if([((HMCharacteristic *)md[md.allKeys[i]]).characteristicType isEqualToString:kPurifieActive] ||
    //                   [((HMCharacteristic *)md[md.allKeys[i]]).characteristicType isEqualToString:kPurifieSpeed] ||
    //                   [((HMCharacteristic *)md[md.allKeys[i]]).characteristicType isEqualToString:kPurifieSpeedCustom] ||
    //                   [((HMCharacteristic *)md[md.allKeys[i]]).characteristicType isEqualToString:kPurifierTargetState]){
    //                    [((HMCharacteristic *)md[md.allKeys[i]]) readValueWithCompletionHandler:^(NSError * _Nullable error) {}];
    //                }
    //        }
    //
    //    }
    
    //    for(NSMutableDictionary *md in pAccessories){
    //
    //        for(NSInteger i = 0; i < md.allKeys.count; i++){
    //            if([md[md.allKeys[i]] isKindOfClass:[HMCharacteristic class]]){
    //                [((HMCharacteristic *)md[md.allKeys[i]]) readValueWithCompletionHandler:^(NSError * _Nullable error) {}];
    //                [((HMCharacteristic *)md[md.allKeys[i]]) enableNotification:YES completionHandler:^(NSError * _Nullable error) {}];
    //            }
    //
    //        }
    //
    //    }
    
}

- (void)addHomeWithName:(NSString *)pName completionHandler:(nonnull void (^)(NSError * _Nullable error))completion
{
    [self.homeManager addHomeWithName:pName completionHandler:^(HMHome * _Nullable home, NSError * _Nullable error) {
        completion(error);
    }];
}

- (void)checkPermissionStatusWithCompletionHandler:(nonnull void (^)(BOOL hasPermission))completion
{
    
    [self.homeManager addHomeWithName:@"我的家" completionHandler:^(HMHome * _Nullable home, NSError * _Nullable error) {
        if(error && error.code == 47){
            completion(NO);
            return;
        }
        completion(YES);
        
    }];
    
    
}



#pragma mark - HMAccessoryBrowserDelegate

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory;
{
    if(self.isAdding){
        _searchedDevice = YES;
        _completionSearch(accessory);
    }
    
    
}

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didRemoveNewAccessory:(HMAccessory *)accessory
{
    kDebugLog(@"didRemoveNewAccessory....");
    [self getHomesNotify];
}

#pragma mark - search & add accessory to current home
- (void)searchAccessoryWithCompletionBlock:(void(^)(HMAccessory *result))pCompletionBlock
{
    [self stopSearchAccessory];
    if(self.browser == nil){
        self.browser = [[HMAccessoryBrowser alloc] init];
        self.browser.delegate = self;
        _completionSearch = pCompletionBlock;
    }
    
    _searchedDevice = NO;
    
    [self performSelector:@selector(searchDeviceTimeOut) withObject:nil afterDelay:20];
    [self.browser startSearchingForNewAccessories];
}

- (void)searchDeviceTimeOut
{
    if(!_searchedDevice){
        [self stopSearchAccessory];
        _completionSearch(nil);
    }
}

- (void)stopSearchAccessory
{
    if(self.browser == nil){
        self.browser = [[HMAccessoryBrowser alloc] init];
        self.browser.delegate = self;
    }
    
    [self.browser stopSearchingForNewAccessories];
    self.browser = nil;
}

- (void)addAccessory:(HMAccessory *)pAccessory completionHandler:(nonnull void (^)(NSError * _Nullable error))completion
{
    MLWeakSelf weakSelf = self;
    [self.currentHome addAccessory:pAccessory completionHandler:^(NSError * _Nullable error) {
        completion(error);
        if(!error){
            NSString *log = [NSString stringWithFormat:@"Added the %@ into home", pAccessory.name];
            kDebugLog(log);
        }
        else{
            kDebugLog(@"Failed to adding accessory");
        }
        [weakSelf stopSearchAccessory];
    }];
}

- (void)addAccessory:(HMAccessory *)pAccessory
{
    MLWeakSelf weakSelf = self;
    [self.currentHome addAccessory:pAccessory completionHandler:^(NSError * _Nullable error) {
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(accessory:didAdded:)]) {
            [weakSelf.delegate accessory:pAccessory didAdded:error];
        }
    }];
}

- (void)updateAccessoryName:(NSString *)pName accessory:(HMAccessory *)pAccessory completionHandler:(nonnull void (^)(NSError * _Nullable error))completion
{
    [pAccessory updateName:pName completionHandler:^(NSError * _Nullable error) {
        completion(error);
    }];
}

#pragma mark - Sevice delegate
- (void)accessory:(HMAccessory *)accessory service:(HMService *)service didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic
{
//    NSString *log = [NSString stringWithFormat:@"the Characteristic is : %@ ...  ... ", characteristic.characteristicType];
//    kDebugLog(log);
    
    [self getHomesNotify];
    
    
    
}

- (void)accessoryDidUpdateName:(HMAccessory *)accessory
{
    
}

/*!
 * @brief Informs the delegate when the name of a service is modfied.
 *
 * @param accessory Sender of the message.
 *
 * @param service Service whose name was modified.
 */
- (void)accessory:(HMAccessory *)accessory didUpdateNameForService:(HMService *)service
{
    
}

/*!
 * @brief Informs the delegate when the associated service type of a service is modified.
 *
 * @param accessory Sender of the message.
 *
 * @param service Service whose associated service type was modified.
 */
- (void)accessory:(HMAccessory *)accessory didUpdateAssociatedServiceTypeForService:(HMService *)service
{
    kDebugLog(@"delegate: accessoryDidUpdateServices....");
    
}

/*!
 * @brief Informs the delegate when the services on the accessory have been dynamically updated.
 *        The services discovered are accessible via the 'services' property of the accessory.
 *
 * @param accessory Sender of the message.
 */
- (void)accessoryDidUpdateServices:(HMAccessory *)accessory
{
    kDebugLog(@"delegate: accessoryDidUpdateServices....");
}

/*!
 *  @abstract   Informs the delegate when a profile is added to an accessory.
 *
 *  @param      accessory   Sender of the message.
 *  @param      profile     The added profile.
 */
- (void)accessory:(HMAccessory *)accessory didAddProfile:(HMAccessoryProfile *)profile
{
    kDebugLog(@"delegate: didAddProfile....");
    
}

/*!
 *  @abstract   Informs the delegate when a profile is removed from an accessory.
 *
 *  @param      accessory   Sender of the message.
 *  @param      profile     The removed profile.
 */
- (void)accessory:(HMAccessory *)accessory didRemoveProfile:(HMAccessoryProfile *)profile
{
    kDebugLog(@"delegate: didRemoveProfile...");
    
}

/*!
 * @brief Informs the delegate when the reachability of the accessory changes.
 *
 * @param accessory Sender of the message.
 */
- (void)accessoryDidUpdateReachability:(HMAccessory *)accessory
{
    
    [[HomeKit_DeviceStatusRoler sharedInstance] updateDeviceStatusWithKey:[accessory.identifier UUIDString]
                                           deviceConnectionStatus:accessory.reachable?DeviceConnectionStatusConnected:DeviceConnectionStatusDisconnected
                                                             from:@"AccessoryManager"];
    
    _protectOfflineReachable = accessory.reachable;
    kDebugLog(@"accessoryDidUpdateReachability:  here....%@");
    if(_protectOfflineReachable){
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(accessoryDidUpdateStatus:)]) {
            [self.delegate accessoryDidUpdateStatus:accessory];
        }
        [self getHomesNotify];
    }
    else{
        [self performSelector:@selector(handleForReachable:) withObject:accessory afterDelay:5];
    }
    
    
}

- (void)handleForReachable:(HMAccessory *)pAccessory
{
    if(_protectOfflineReachable){
        return;
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(accessoryDidUpdateStatus:)]) {
        [self.delegate accessoryDidUpdateStatus:pAccessory];
    }
    [self getHomesNotify];
}


/*!
 * @brief Informs the delegate when firmwareVersion has been changed for an accessory.
 *
 * @param accessory Sender of the message.
 *
 * @param firmwareVersion The newly updated firmwareVersion.
 */
- (void)accessory:(HMAccessory *)accessory didUpdateFirmwareVersion:(NSString *)firmwareVersion
{
    kDebugLog(@"didUpdateFirmwareVersion:here....");
    [self getHomesNotify];
}

- (void)homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager
{
    kDebugLog(@"homeManagerDidUpdatePrimaryHome: here...");
}

//for charactiric
- (void)updateCharacteristic:(HMCharacteristic *)pCharacteristic value:(NSInteger)pValue completionHandler:(nonnull void (^)(NSError * _Nullable error))completion
{
    
    [pCharacteristic enableNotification:YES completionHandler:^(NSError * _Nullable error) {
        
    }];
    
    [pCharacteristic writeValue:[NSNumber numberWithInteger:pValue] completionHandler:^(NSError * _Nullable error) {
        completion(error);
    }];
    
}


@end
