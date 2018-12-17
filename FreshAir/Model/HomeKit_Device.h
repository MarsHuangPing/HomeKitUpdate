//
//  Device.h
//  FreshAir
//
//  Created by mars on 28/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_Device : NSObject

@property (nonatomic, strong, readonly) NSString *deviceID;
@property (nonatomic, strong, readonly) NSString *deviceName;
@property (nonatomic, strong, readonly) NSString *windQuantityValue;
@property (nonatomic, strong, readonly) NSString *PMValue;
@property (nonatomic, strong, readonly) NSString *temperatureValue;
@property (nonatomic, strong, readonly) NSString *humidityValue;
@property (nonatomic, strong, readonly) NSString *co2Value;

- (HomeKit_Device *)initWithDeviceID:(NSString *)pDeviceID
                  deviceName:(NSString *)pDeviceName
           windQuantityValue:(NSString *)pWindQuantityValue
                     PMValue:(NSString *)pPMValue
            temperatureValue:(NSString *)pTemperatureValue
               humidityValue:(NSString *)pHumidityValue
                    co2Value:(NSString *)pCo2Value;

@end
