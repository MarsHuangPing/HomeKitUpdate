//
//  Pm25CityStationRequest.h
//  FreshAir
//
//  Created by mars on 24/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HomeKit_Pm25CityStationRequest : NSObject

@property (nonatomic, strong) NSString *area;

- (HomeKit_Pm25CityStationRequest *)initWithArea:(NSString *)pArea;

@end
