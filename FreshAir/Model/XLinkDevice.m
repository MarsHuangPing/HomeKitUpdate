//
//  XLinkDevice.m
//  FreshAir
//
//  Created by mars on 2018/8/24.
//  Copyright © 2018 mars. All rights reserved.
//

#import "XLinkDevice.h"
#import "NSObject+ML.h"

@implementation XLinkDevice
- (void)enhanceWithFanControl:(NSString *)pFanControl
                     SSIValue:(NSString *)pSSIValue
                screenControl:(NSString *)pScreenControl
             screenDimmingSet:(NSString *)pScreenDimmingSet
             fanAirflowStatus:(NSString *)pFanAirflowStatus
                fanAirflowMax:(NSString *)pFanAirflowMax
                fanAirflowMin:(NSString *)pFanAirflowMin
            indoorTemperature:(NSString *)pIndoorTemperature
               indoorHumidity:(NSString *)pIndoorHumidity
                     PM25Data:(NSString *)pPM25Data
                      CO2Data:(NSString *)pCO2Data
                     PM03Data:(NSString *)pPM03Data
                    PTCStatus:(NSString *)pPTCStatus
                     deviceID:(NSString *)pDeviceID
                          cid:(NSString *)pCid
                    sleepMode:(NSString *)pSleepMode
                  targetState:(NSString *)pTargetState
                   airQuality:(NSString *)pAirQuality
{
    _FanControl = [pFanControl ml_intValue];
    _RSSIValue = [pSSIValue ml_intValue];
    _ScreenControl = [pScreenControl ml_intValue];
    _ScreenDimmingSet = [pScreenDimmingSet ml_intValue];
    _FanAirflowStatus = [pFanAirflowStatus ml_intValue];
    _FanAirflowMax = [pFanAirflowMax ml_intValue];
    _FanAirflowMin = [pFanAirflowMin ml_intValue];
    _IndoorTemperature = [pIndoorTemperature ml_intValue];
    _IndoorHumidity = [pIndoorHumidity ml_intValue];
    _PM25Data = [pPM25Data ml_intValue];
    _CO2Data = [pCO2Data ml_intValue];
    _PM03Data = [pPM03Data ml_intValue];
    _AirQuality = [pAirQuality ml_intValue];
    _PTCStatus = [[pPTCStatus lowercaseString] isEqualToString:@"false"]?NO:YES;
    _Cid = pCid;
    _SleepMode = [pSleepMode ml_intValue];
    _TargetState = [pTargetState ml_intValue];
}

- (XLinkDevice *)initWithDeviceID:(NSString *)pDeviceID
                             name:(NSString *)pName
                 physicalDeviceId:(NSString *)pPhysicalDeviceId
                         platform:(NSString *)pPlatform
                      product_key:(NSString *)pProduct_Key
{
    if(self = [super init]){
        _DeviceID = pDeviceID;
        _Name = pName;
        _PhysicalDeviceId = pPhysicalDeviceId;
        _Platform = pPlatform;
        _Product_Key = pProduct_Key;
        
    }
    return self;
}

- (BOOL)isOnline
{
    BOOL result = NO;
    
    if(_Cid){
        result = YES;
    }
    
    return result;
    
}

@end
//{
//    "FanControl": "1",
//    "RSSIValue": "5",
//    "ScreenControl": "1",
//    "ScreenDimmingSet": "3",
//    "FanAirflowStatus": "10",
//    "FanAirflowMax": "100",
//    "FanAirflowMin": "10",
//    "IndoorTemperature": "",
//    "IndoorHumidity": "55",
//    "PM25Data": "0",
//    "CO2Data": "806",
//    "PM03Data": "",
//    "PTCStatus": "False",
//    "DeviceID": null,
//    "Cid": "0403201804200101"
//}
