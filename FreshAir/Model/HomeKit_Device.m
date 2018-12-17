//
//  Device.m
//  FreshAir
//
//  Created by mars on 28/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_Device.h"

@implementation HomeKit_Device

- (HomeKit_Device *)initWithDeviceID:(NSString *)pDeviceID
                  deviceName:(NSString *)pDeviceName
           windQuantityValue:(NSString *)pWindQuantityValue
                     PMValue:(NSString *)pPMValue
            temperatureValue:(NSString *)pTemperatureValue
               humidityValue:(NSString *)pHumidityValue
                    co2Value:(NSString *)pCo2Value
{
    if(self = [super init]){
        _deviceID = pDeviceID;
        _deviceName = pDeviceName;
        _windQuantityValue = pWindQuantityValue;
        _PMValue = pPMValue;
        _temperatureValue = pTemperatureValue;
        _humidityValue = pHumidityValue;
        _co2Value = pCo2Value;
    }
    return self;
}

@end
