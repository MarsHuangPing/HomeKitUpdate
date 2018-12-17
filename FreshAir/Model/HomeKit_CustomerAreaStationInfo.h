//
//  CustomerAreaStationInfo.h
//  FreshAir
//
//  Created by mars on 24/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_CustomerAreaStationInfo : NSObject

@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *positionName;
@property (nonatomic, strong) NSString *stationCode;
@property (nonatomic, strong) NSString *openId;

- (HomeKit_CustomerAreaStationInfo *)initWithArea:(NSString *)pArea
                             positionName:(NSString *)pPositionName
                              stationCode:(NSString *)pStationCode
                                   openId:(NSString *)pOpenId;

@end



//public  class CustomerAreaStationInfoModel
//{
//    public string Area { get; set; }
//    public string PositionName { get; set; }
//    public string StationCode { get; set; }
//    public string OpenId { get; set; }
//}

