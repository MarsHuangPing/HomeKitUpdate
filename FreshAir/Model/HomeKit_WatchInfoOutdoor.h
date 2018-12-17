//
//  WatchInfoOutdoor.h
//  FreshAir
//
//  Created by mars on 11/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeKit_CustomerAreaStationInfo;

@interface HomeKit_WatchInfoOutdoor : NSObject

@property (nonatomic, strong) NSString *openId;
@property (nonatomic, strong) NSString *customerArea;
@property (nonatomic, strong) NSString *deviceArea;
@property (nonatomic, strong) NSString *positionName;
@property (nonatomic, strong) NSString *stationCode;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger aqi;

- (HomeKit_WatchInfoOutdoor *)initWithOpenId:(NSString *)pOpenId
                        customerArea:(NSString *)pCustomerArea
                          deviceArea:(NSString *)pDeviceArea
                        positionName:(NSString *)pPositionName
                         stationCode:(NSString *)pStationCode
                            deviceId:(NSString *)pDeviceId
                           timestamp:(NSString *)pTimestamp
                               value:(NSInteger)pValue
                                 aqi:(NSInteger)pAqi;

- (HomeKit_CustomerAreaStationInfo *)toCustomerAreaStationInfo;

@end

//"OpenId": null,
//"CustomerArea": null,
//"DeviceArea": null,
//"PositionName": null,
//"StationCode": null,
//"DeviceId": null,
//"Timestamp": "2018-01-31 16:00:00",
//"Value": 19,
//"Aqi": 54

