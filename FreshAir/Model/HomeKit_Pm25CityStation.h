//
//  Pm25CityStation.h
//  FreshAir
//
//  Created by mars on 24/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_Pm25CityStation : NSObject

@property (nonatomic, strong) NSString *stationCode;
@property (nonatomic, strong) NSString *positionName;
@property (nonatomic, strong) NSString *area;

- (HomeKit_Pm25CityStation *)initWithStationCode:(NSString *)pStationCode
                            positionName:(NSString *)pPositionName
                                    area:(NSString *)pArea;

@end


//public class Pm25CityStationModel
//{
//    public string StationCode { get; set; }
//    public string PositionName { get; set; }
//    public string Area { get; set; }
//}

