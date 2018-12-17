//
//  XLinkDevice.h
//  FreshAir
//
//  Created by mars on 2018/8/24.
//  Copyright © 2018 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLinkDevice : NSObject


@property (nonatomic, assign) NSInteger FanControl;
@property (nonatomic, assign) NSInteger RSSIValue;
@property (nonatomic, assign) NSInteger ScreenControl;
@property (nonatomic, assign) NSInteger ScreenDimmingSet;
@property (nonatomic, assign) NSInteger FanAirflowStatus;
@property (nonatomic, assign) NSInteger FanAirflowMax;
@property (nonatomic, assign) NSInteger FanAirflowMin;
@property (nonatomic, assign) NSInteger IndoorTemperature;
@property (nonatomic, assign) NSInteger IndoorHumidity;
@property (nonatomic, assign) NSInteger PM25Data;
@property (nonatomic, assign) NSInteger CO2Data;
@property (nonatomic, assign) NSInteger PM03Data;
@property (nonatomic, assign) BOOL PTCStatus;
@property (nonatomic, strong) NSString *Cid;
@property (nonatomic, assign) NSInteger SleepMode;
@property (nonatomic, assign) NSInteger TargetState;
@property (nonatomic, assign) BOOL isOnline;
@property (nonatomic, assign) NSInteger AirQuality;


@property (nonatomic, strong) NSString *DeviceID;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *PhysicalDeviceId;
@property (nonatomic, strong) NSString *Platform;
@property (nonatomic, strong) NSString *Product_Key;

- (XLinkDevice *)initWithDeviceID:(NSString *)pDeviceID
                             name:(NSString *)pName
                 physicalDeviceId:(NSString *)pPhysicalDeviceId
                         platform:(NSString *)pPlatform
                      product_key:(NSString *)pProduct_Key;

- (void)enhanceWithFanControl:(NSString *)pFanControl
                     SSIValue:(NSString *)pScreenControl
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
                   airQuality:(NSString *)pAirQuality;
- (BOOL)isOnline;

@end



