//
//  DeviceService.m
//  FreshAir
//
//  Created by mars on 29/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_DeviceService.h"

#import "HomeKit_DeviceDataService.h"

#import "HomeKit_DevicesRequest.h"
#import "HomeKit_ArrayServiceResponse.h"
#import "HomeKit_WatchInfoOutdoorRequest.h"
#import "HomeKit_BooleanResponse.h"
#import "XLinkDevice.h"
#import "HomeKit_CommonAPI.h"

#import "NSObject+ML.h"

#import <HomeKit/HomeKit.h>

@interface HomeKit_DeviceService()
{
    NSTimer *_timerGetDevices;
//    BOOL _didGotAllDevice;
    NSString *_openID;
    NSString *_unionID;
    
    
}
@end

@implementation HomeKit_DeviceService

+ (HomeKit_DeviceService *)sharedInstance
{
    static HomeKit_DeviceService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeKit_DeviceService alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if(self = [super init]){
        if(!_timerGetDevices)
            _timerGetDevices = [NSTimer scheduledTimerWithTimeInterval:10
                                                                target:self
                                                              selector:@selector(refreshAllDevice)
                                                              userInfo:nil
                                                               repeats:YES];
        _hasGotXLinkList = NO;
    }
    return self;
}
#pragma mark - location
- (NSDictionary *)fetchLocalSavedLocationWithHomeID:(NSString *)pHomeID
{
    NSDictionary *dicResult = nil;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:DocumentsPath(pHomeID)]){
        NSData *dataJSON = [NSData dataWithContentsOfFile:DocumentsPath(pHomeID)];
        dicResult = [NSJSONSerialization JSONObjectWithData:dataJSON
                                                    options:NSJSONReadingMutableContainers
                                                      error:nil];
    }
    return dicResult;
}

#pragma mark - Login
//- (void)executeRequestForLoginWithOpenId:(NSString *)pOpenId
//                                 unionId:(NSString *)pUnionId
//                                nickName:(NSString *)pNickName
//                              headimgurl:(NSString *)pHeadimgurl
//                         completionBlock:(ServiceCompletionBlock)pCompletionBlock
- (void)loginWithOpenId:(NSString *)pOpenId
                unionId:(NSString *)pUnionId
               nickName:(NSString *)pNickName
             headimgurl:(NSString *)pHeadimgurl
        completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForLoginWithOpenId:pOpenId
                                 unionId:pUnionId
                                nickName:pNickName
                              headimgurl:pHeadimgurl
                         completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                             pCompletionBlock(pServiceResponse);
                         }];
}

- (void)saveLocationWithCityName:(NSString *)pCityName
                     stationName:(NSString *)pStationName
                     stationCode:(NSString *)pStationCode
                          homeID:(NSString *)pHomeID
{
    
    //save new json
    NSDictionary * dic = @{
                                 kCityNameKey: pCityName.length != 0?pCityName:@"",
                                 kStationNameKey: pStationName.length != 0?pStationName:@"",
                                 kStationCodeKey: pStationCode.length != 0?pStationCode:@""
                                 
                                 };
    
    NSData *data= [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    [data writeToFile:DocumentsPath(pHomeID) atomically:YES];
}

#pragma mark - Methods
- (void)searchOutdoorPMInfoWithRequest:(HomeKit_WatchInfoOutdoorRequest *)pRequest
                       completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForSearchOutdoorPMInfoWithRequest:pRequest completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
        pCompletionBlock(pServiceResponse);
    }];
    
}

#pragma mark - 10 设备7天数据比对
- (void)fetchHistoryInfosWithRequest:(HistoryInfoRequest *)pRequest
                     completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForHistoryInfosWithRequest:pRequest completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
        pCompletionBlock(pServiceResponse);
    }];
    
}

#pragma mark - 6 查询周边城市
- (void)fetchSearchNearCityWithRequest:(NSString *)pRequest
                       completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForSearchNearCityWithCurrentCity:pRequest completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
        pCompletionBlock(pServiceResponse);
    }];
    
}


#pragma mark - 7 查询城市 监测站
- (void)fetchPm25CityStationWithRequest:(HomeKit_Pm25CityStationRequest *)pRequest
                        completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForSearchStationByAreaWithRequest:pRequest completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
        pCompletionBlock(pServiceResponse);
    }];
    
}

#pragma mark - xLink service

- (void)refreshXLinkDevice:(XLinkDevice *)pXLinkDevice
                       uid:(NSString *)pUID
                    openID:(NSString *)pOpenID
                      time:(NSInteger)pTime
           completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForGetSingleDeviceWithUID:pUID
                                         device:pXLinkDevice
                                         openId:pOpenID
                                completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                    pCompletionBlock(pServiceResponse);
                                    
                                    if(pServiceResponse.success){
                                        [self.maXLinkDevices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                            XLinkDevice *device = obj;
                                            if([device.Cid isEqualToString:pXLinkDevice.Cid] || [device.PhysicalDeviceId isEqualToString:pXLinkDevice.PhysicalDeviceId]){
                                                [self.maXLinkDevices replaceObjectAtIndex:idx withObject:pXLinkDevice];
                                                *stop = YES;
                                            }
                                        }];
                                    }
                                    //handle with error
                                    else if(pTime > 3){
                                        [self.maXLinkDevices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                            XLinkDevice *device = obj;
                                            if([device.Cid isEqualToString:pXLinkDevice.Cid] || [device.PhysicalDeviceId isEqualToString:pXLinkDevice.PhysicalDeviceId]){
                                                pXLinkDevice.Cid = nil;
                                                pXLinkDevice.isOnline = NO;
                                                [self.maXLinkDevices replaceObjectAtIndex:idx withObject:pXLinkDevice];
                                                *stop = YES;
                                            }
                                        }];
                                    }
                                    
                                    
                                }];
}

//1 通过uId获取设备列表
- (void)refreshAllDevice
{
    if(!_unionID || !_openID){
        return;
    }
    
    [self getAllDevicesWithUID:_unionID openID:_openID completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) { }];
    
}
- (void)getAllDevicesWithUID:(NSString *)pUID
                      openID:(NSString *)pOpenID
                 completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    if(pUID) _unionID = pUID;
    if(pOpenID) _openID = pOpenID;
    
    MLWeakSelf weakSelf = self;
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForGetAllDevicesWithUID:pUID
                                  completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                      if(pServiceResponse.success){
                                          self.hasGotXLinkList = YES;
                                          HomeKit_ArrayServiceResponse *response = (HomeKit_ArrayServiceResponse *)pServiceResponse;
                                          
                                          if(!self.maXLinkDevices){
                                              self.maXLinkDevices = response.maData;
                                          }
                                          else{
                                              
                                              NSMutableArray *maTmp = [NSMutableArray array];
                                              for(NSInteger i = 0; i < response.maData.count; i++){
                                                  XLinkDevice *deviceOutter = response.maData[i];
                                                  
                                                  BOOL exist = NO;
                                                  for(NSInteger j = 0; j < self.maXLinkDevices.count; j++){
                                                      XLinkDevice *deviceInner = self.maXLinkDevices[j];
                                                      if([deviceInner.PhysicalDeviceId isEqualToString:deviceOutter.PhysicalDeviceId]){
                                                          exist = YES;
                                                          break;
                                                      }
                                                  }
                                                  if(!exist){
                                                      [maTmp addObject:deviceOutter];
                                                  }
                                                  
                                              }
                                              
                                              if(maTmp.count != 0){
                                                  [self.maXLinkDevices addObjectsFromArray:maTmp];
                                              }
                                          }
                                          
                                          [response.maData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                              XLinkDevice *device = obj;
                                              if([device.Platform isEqualToString:@"xlink"]){
                                                  [weakSelf refreshXLinkDevice:device
                                                                           uid:pUID
                                                                        openID:pOpenID
                                                                          time:0
                                                               completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) { }];
                                              }
                                          }];

                                          
                                          pCompletionBlock(response);
                                      }
                                      
                                  }];
}


#pragma mark - xlink 新设备绑定
//5   添加绑定任务
- (void)insertDeviceBoundWithPID:(NSString *)pId
                          openID:(NSString *)pOpenID
                 completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForInsertDeviceBoundWithPID:pId
                                           openID:pOpenID
                                  completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                      pCompletionBlock(pServiceResponse);
                                  }];
}

//6  绑定设备
- (void)reBindingDeviceWithPID:(NSString *)pId
                           did:(NSString *)pDID
                          cDId:(NSString *)pCDId
                            sn:(NSString *)pSN
                      platform:(NSString *)pPlatform
                           uId:(NSString *)pUID
                        openID:(NSString *)pOpenID
               completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    
    [self insertDeviceBoundWithPID:pId
                            openID:pOpenID
                   completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                       HomeKit_BooleanResponse *response = (HomeKit_BooleanResponse *)pServiceResponse;
                       
                       if(!response.responseResult){
                           pCompletionBlock(pServiceResponse);
                       }
                       else{
                           
                           [ds executeRequestForReBindingDeviceWithPID:pId
                                                                   did:pDID
                                                                  cDId:pCDId
                                                                    sn:pSN
                                                              platform:pPlatform
                                                                   uId:pUID
                                                                openID:pOpenID
                                                       completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                           pCompletionBlock(pServiceResponse);
                                                       }];
                           
                       }
                       
                   }];
    
    
}

//7 保存绑定设备信息
- (void)updateBoundDeviceAddressAreaWithPID:(NSString *)pId
                                     openID:(NSString *)pOpenID
                                    address:(NSString *)pAddress
                                       area:(NSString *)pArea
                                 deivceName:(NSString *)pDeivceName
                            completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForUpdateBoundDeviceAddressAreaWithPID:pId
                                                      openID:pOpenID
                                                     address:pAddress
                                                        area:pArea
                                                  deivceName:pDeivceName
                                             completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                 pCompletionBlock(pServiceResponse);
                                             }];
}

//8 查询用户信息 - 电话号码
- (void)searchCustomerInfoWithOpenID:(NSString *)pOpenID
                            completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForSearchCustomerInfoWithOpenID:pOpenID
                                             completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                 pCompletionBlock(pServiceResponse);
                                             }];
}

//9 保存用户电话号码
- (void)saveUserInfoProjectWithOpenID:(NSString *)pOpenID
                          phoneNumber:(NSString *)pPhoneNumber
                     completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForSaveUserInfoProjectWithOpenID:pOpenID
                                           phoneNumber:pPhoneNumber
                                      completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                          pCompletionBlock(pServiceResponse);
                                      }];
}

//15 由sn换mac
- (void)getXlinkDeviceInfoBySnWithSN:(NSString *)pSN
                     completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForGetXlinkDeviceInfoBySnWithSN:pSN
                                       completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                           pCompletionBlock(pServiceResponse);
                                       }];
}


//14 设备休眠
//#define kSleepDevice @"/ApiServer/ProjectV2/api/DeviceInfo/SleepDeviceProjectV2"
//- (NSMutableURLRequest *)sleepDevice:(NSDictionary *)pParams;
//{
//    "uid":"",
//    "pId":"",
//    "platform":"",
//    "openId":"",
//    "deviceType":"",
//    "dId":""
//}
- (void)sleepDeviceWithOpenID:(NSString *)pOpenID
                          uid:(NSString *)pUID
                          pId:(NSString *)pPID
                     platform:(NSString *)pPlatform
                   deviceType:(NSString *)pDeviceType
                          dId:(NSString *)pDID
                     sendData:(NSString *)pSendData
              completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    
    [ds executeRequestForSleepDeviceWithOpenID:pOpenID
                                           uid:pUID
                                           pId:pPID
                                      platform:pPlatform
                                    deviceType:pDeviceType
                                           dId:pDID
                                      sendData:pSendData
                               completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                   pCompletionBlock(pServiceResponse);
                               }];
}

//13 风机开关
//#define kOpenAndCloseFan @"/ApiServer/ProjectV2/api/DeviceInfo/OpenAndCloseFanProjectV2"
//{
//    "uid":"",
//    "pId":"",
//    "platform":"",
//    "openId":"",
//    "deviceType":"",
//    "dId":"",
//    "isOpen":"",
//}
- (void)openAndCloseFanWithOpenID:(NSString *)pOpenID
                              uid:(NSString *)pUID
                              pId:(NSString *)pPID
                         platform:(NSString *)pPlatform
                       deviceType:(NSString *)pDeviceType
                              dId:(NSString *)pDID
                           isOpen:(NSString *)pIsOpen
                  completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForOpenAndCloseFanWithOpenID:pOpenID
                                               uid:pUID
                                               pId:pPID
                                          platform:pPlatform
                                        deviceType:pDeviceType
                                               dId:pDID
                                            isOpen:pIsOpen
                                   completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                       pCompletionBlock(pServiceResponse);
                                   }];
}

//9 辅热开关
//#define kOpenClosePtc @"/ApiServer/ProjectV2/api/DeviceInfo/OpenClosePtcProjectV2"
//- (NSMutableURLRequest *)openClosePtc:(NSDictionary *)pParams;
//{
//    "uid":"",
//    "pId":"",
//    "platform":"",
//    "openId":"",
//    "sendData":"",
//    "deviceType":"",
//    "dId":"",
//    "isOpen":"",
//
//}

- (void)openClosePtcWithOpenID:(NSString *)pOpenID
                           uid:(NSString *)pUID
                           pId:(NSString *)pPID
                      platform:(NSString *)pPlatform
                    deviceType:(NSString *)pDeviceType
                           dId:(NSString *)pDID
                        isOpen:(NSString *)pIsOpen
                      sendData:(NSString *)pSendData
               completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForOpenClosePtcWithOpenID:pOpenID
                                            uid:pUID
                                            pId:pPID
                                       platform:pPlatform
                                     deviceType:pDeviceType
                                            dId:pDID
                                         isOpen:pIsOpen
                                       sendData:pSendData
                                completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                    pCompletionBlock(pServiceResponse);
                                }];
}

//11 屏幕亮度调节
//#define kModifyDeviceScreen @"/ApiServer/ProjectV2/api/DeviceInfo/ModifyDeviceScreenProjectV2"
//- (NSMutableURLRequest *)modifyDeviceScreen:(NSDictionary *)pParams;
//{
//    "uid":"",
//    "pId":"",
//    "platform":"",
//    "openId":"",
//    "sendData":"",
//    "deviceType":"",
//    "dId":"",
//}
- (void)modifyDeviceScreenWithOpenID:(NSString *)pOpenID
                                 uid:(NSString *)pUID
                                 pId:(NSString *)pPID
                            platform:(NSString *)pPlatform
                          deviceType:(NSString *)pDeviceType
                                 dId:(NSString *)pDID
                            sendData:(NSString *)pSendData
                     completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForModifyDeviceScreenWithOpenID:pOpenID
                                                  uid:pUID
                                                  pId:pPID
                                             platform:pPlatform
                                           deviceType:pDeviceType
                                                  dId:pDID
                                             sendData:pSendData
                                      completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                          pCompletionBlock(pServiceResponse);
                                      }];
}

//8 设置风速
//#define kSetDeivecSpeed @"/ApiServer/ProjectV2/api/DeviceInfo/SetDeivecSpeedProjectV2"
//- (NSMutableURLRequest *)setDeivecSpeed:(NSDictionary *)pParams
//{
//    "uid":"",
//    "pId":"",
//    "platform":"",
//    "openId":"",
//    "minSpeed":"",
//    "maxSpeed":"",
//    "sendData":"",
//    "deviceType":"",
//    "dId":"",
//}

- (void)setDeivecSpeedWithOpenID:(NSString *)pOpenID
                             uid:(NSString *)pUID
                             pId:(NSString *)pPID
                        platform:(NSString *)pPlatform
                      deviceType:(NSString *)pDeviceType
                             dId:(NSString *)pDID
                        sendData:(NSString *)pSendData
                        minSpeed:(NSString *)pMinSpeed
                        maxSpeed:(NSString *)pMaxSpeed
                 completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForSetDeivecSpeedWithOpenID:pOpenID
                                              uid:pUID
                                              pId:pPID
                                         platform:pPlatform
                                       deviceType:pDeviceType
                                              dId:pDID
                                         sendData:pSendData
                                         minSpeed:pMinSpeed
                                         maxSpeed:pMaxSpeed
                                  completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                      pCompletionBlock(pServiceResponse);
                                  }];
}

- (NSString *)airQualityDescriptionWithValue:(NSInteger)pValue
{
    
    
    NSString *result = PM25_AIRPROPERITY_DES_LABEL_FIRST;
    
    AirLevel airLevel = [[HomeKit_CommonAPI sharedInstance] getAirLevelWithPM:pValue];
    
    
    switch (airLevel) {
        case AirLevelOne:
        {
            result = PM25_AIRPROPERITY_DES_LABEL_FIRST;
            break;
        }
        case AirLevelTwo:
        {
            result = PM25_AIRPROPERITY_DES_LABEL_SECOND;
            break;
        }
        case AirLevelThree:
        {
            result = PM25_AIRPROPERITY_DES_LABEL_THIRD;
            break;
        }
        case AirLevelFour:
        {
            result = PM25_AIRPROPERITY_DES_LABEL_FOURTH;
            break;
        }
        case AirLevelFive:
        {
            result = PM25_AIRPROPERITY_DES_LABEL_FIVE;
            break;
        }
        case AirLevelSix:
        {
            result = PM25_AIRPROPERITY_DES_LABEL_SIX;
            break;
        }
    }
    
    
    return result;
}

- (void)checkIfXLinkServiceWithSerial:(NSString *)pSerial
                                 pId:(NSString *)pPId
                     completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    __block BOOL exist = NO;
    [self.maXLinkDevices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XLinkDevice *device = obj;
        if([device.Cid isEqualToString:pSerial] || [device.PhysicalDeviceId isEqualToString:pPId]){
            exist = YES;
            *stop = YES;
        }
    }];
    
    HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] initWithResponseResult:exist?@"true":@"false"];
    

    result.success = YES;
    pCompletionBlock(result);
    
//    if(exist == YES){
//        HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] initWithResponseResult:@"true"];
//        result.success = YES;
//        pCompletionBlock(result);
//        return;
//    }
//    else{
//        HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] initWithResponseResult:@"false"];
//        result.success = YES;
//        pCompletionBlock(result);
//        return;
//    }
//
//    __block BOOL exist = NO;
//    [self.maXLinkDevices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        XLinkDevice *device = obj;
//        if([device.Cid isEqualToString:pSerial]){
//            exist = YES;
//            *stop = YES;
//        }
//    }];
//
//    if(exist == YES){
//        HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] initWithResponseResult:@"true"];
//        result.success = YES;
//        pCompletionBlock(result);
//        return;
//    }
//
//    if(pPId.length == 0){
//        HomeKit_BooleanResponse *result = [[HomeKit_BooleanResponse alloc] initWithResponseResult:@"false"];
//        result.success = YES;
//        pCompletionBlock(result);
//        return;
//    }
//
//    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
//    [ds executeRequestForIsDeviceBoundWithPID:pPId completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
//        pCompletionBlock(pServiceResponse);
//    }];
    
    
}

- (void)checkIfXLinkServiceByOtherBind:(NSString *)PID completionBlock:(ServiceCompletionBlock)pCompletionBlock
{
    HomeKit_DeviceDataService *ds = [[HomeKit_DeviceDataService alloc] init];
    [ds executeRequestForIsDeviceBoundWithPID:PID completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
        pCompletionBlock(pServiceResponse);
    }];

}


#pragma mark - for about
- (void)saveDeviceParamsWithDic:(NSMutableDictionary *)pPamames deviceName:(NSString *)pDeviceName{
    NSString *searial = [((HMCharacteristic *)[pPamames objectForKey:kPurifieSerial]).value ml_stringValue];
    if(searial.length != 0){
        [[NSUserDefaults standardUserDefaults] setValue:searial
                                                 forKey:[NSString stringWithFormat:@"%@___%@", pDeviceName, kPurifieSerial]];
    }
    
    NSString *manufacturer = [((HMCharacteristic *)[pPamames objectForKey:kPurifieManufacturer]).value ml_stringValue];
    if(manufacturer.length != 0){
        [[NSUserDefaults standardUserDefaults] setValue:manufacturer
                                                 forKey:[NSString stringWithFormat:@"%@___%@", pDeviceName, kPurifieManufacturer]];
    }
    
    NSString *model = [((HMCharacteristic *)[pPamames objectForKey:kPurifieModel]).value ml_stringValue];
    if(model.length != 0){
        [[NSUserDefaults standardUserDefaults] setValue:model
                                                 forKey:[NSString stringWithFormat:@"%@___%@", pDeviceName, kPurifieModel]];
    }
    
    NSString *firmware = [((HMCharacteristic *)[pPamames objectForKey:kPurifieFirmware]).value ml_stringValue];
    if(firmware.length != 0){
        [[NSUserDefaults standardUserDefaults] setValue:firmware
                                                 forKey:[NSString stringWithFormat:@"%@___%@", pDeviceName, kPurifieFirmware]];
    }
    
}

- (NSString *)loadDeviceParamsWithDeviceName:(NSString *)pDeviceName key:(NSString *)pKey{
    NSString *value = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@___%@", pDeviceName, pKey]];
    
    return value;
}

@end
