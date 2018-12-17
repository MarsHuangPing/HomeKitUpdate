//
//  DeviceStatusRoler.m
//  DDD
//
//  Created by mars on 2018/6/27.
//  Copyright © 2018 mars. All rights reserved.
//

#define DocumentsPath(name) [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:name]

#define kDate @"DateKey"
#define kCo2 @"Co2Key"
#define kPM @"PMKey"
#define kHumidity @"HumidityKey"
#define kDeviceStatus @"DeviceStatusKey"
#define kDeviceConnectInfo @"DeviceConnectInfo"

#define durationThreshold 30

#import "HomeKit_DeviceStatusRoler.h"
#import "HomeKit_DateManager.h"
#import "NSObject+ML.h"

@interface HomeKit_DeviceStatusRoler()
{
    NSMutableDictionary *_mdDevices;
}
@end
@implementation HomeKit_DeviceStatusRoler

- (HomeKit_DeviceStatusRoler *)init{
    if(self = [super init]){
        _mdDevices = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (HomeKit_DeviceStatusRoler *)sharedInstance
{
    static HomeKit_DeviceStatusRoler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeKit_DeviceStatusRoler alloc] init];
    });
    
    return sharedInstance;
}

- (void)cleanDevices
{
    
    _mdDevices = [NSMutableDictionary dictionary];
    
}

- (void)updateDeviceStatusWithKey:(NSString *)pKey
           deviceConnectionStatus:(DeviceConnectionStatus)pDeviceConnectionStatus
                             from:(NSString *)pFrom{
    
    NSString *status = @"Unknow";
    if(pDeviceConnectionStatus == DeviceConnectionStatusUnknow){
        status = @"Unknow";
    }
    else if(pDeviceConnectionStatus == DeviceConnectionStatusConnected){
        status = @"Connected";
    }
    else if(pDeviceConnectionStatus == DeviceConnectionStatusDisconnected){
        status = @"Disconnected";
    }
    
    NSLog(@"the change device status was from %@, the status was changed %@...........", pFrom, status);
    
    NSDictionary *dic = _mdDevices[pKey];
    NSDictionary *tmpDic = nil;
    if(dic){
        tmpDic = @{
                   kDate:dic[kDate],
                   kCo2:dic[kCo2],
                   kPM:dic[kPM],
                   kHumidity:dic[kHumidity],
                   kDeviceStatus:dic[kDeviceStatus],
                   kDeviceConnectInfo: [NSString stringWithFormat:@"%ld", pDeviceConnectionStatus]
                   };
    }
    else{
        tmpDic = @{
                   kDate:[NSDate date],
                   kCo2:[NSString stringWithFormat:@"%d", 0],
                   kPM:[NSString stringWithFormat:@"%d", 0],
                   kHumidity:[NSString stringWithFormat:@"%d", 0],
                   kDeviceStatus:[NSString stringWithFormat:@"%ld", DeviceStatusUpdating],
                   kDeviceConnectInfo: [NSString stringWithFormat:@"%ld", pDeviceConnectionStatus]
                   };
    }
    [_mdDevices setObject:tmpDic forKey:pKey];
    
}

- (DeviceStatus)checkDeviceStatusWithKey:(NSString *)pKey
                                co2Value:(NSInteger)pCo2Value
                                 pmValue:(NSInteger)pPmValue
                                humidity:(NSInteger)pHumidity
                               reachable:(BOOL)pReachable{
    DeviceStatus result = DeviceStatusOffline;
    
    BOOL reachable = pReachable;
    
    NSDictionary *dic = _mdDevices[pKey];
    if(dic){
        //no first
        NSDate *date = dic[kDate];
        
        if([dic[kDeviceConnectInfo] ml_intValue] != DeviceConnectionStatusUnknow){
            reachable = [dic[kDeviceConnectInfo] ml_intValue] == DeviceConnectionStatusConnected;
        }
        
        if([dic[kCo2] isEqualToString:[NSString stringWithFormat:@"%ld", pCo2Value]] &&
           [dic[kPM] isEqualToString:[NSString stringWithFormat:@"%ld", pPmValue]] &&
           [dic[kHumidity] isEqualToString:[NSString stringWithFormat:@"%ld", pHumidity]]){
            //no changed
            NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:date];
            if(time > durationThreshold || !pReachable){
                
                
                NSDictionary *tmpDic = @{
                                         kDate:dic[kDate],
                                         kCo2:dic[kCo2],
                                         kPM:dic[kPM],
                                         kHumidity:dic[kHumidity],
                                         kDeviceStatus:[NSString stringWithFormat:@"%ld", DeviceStatusOffline],
                                         kDeviceConnectInfo: dic[kDeviceConnectInfo]
                                         };
                
                [_mdDevices setValue:tmpDic forKey:pKey];
                
                return DeviceStatusOffline;
            }
            else{
                
                //if privious status is offline, then
                if([dic[kDeviceStatus] ml_intValue] == DeviceStatusOffline || [dic[kDeviceStatus] ml_intValue] == DeviceStatusUpdating){
                    NSDictionary *tmpDic = @{
                                             kDate:dic[kDate],
                                             kCo2:dic[kCo2],
                                             kPM:dic[kPM],
                                             kHumidity:dic[kHumidity],
                                             kDeviceStatus:[NSString stringWithFormat:@"%ld", DeviceStatusUpdating],
                                             kDeviceConnectInfo: dic[kDeviceConnectInfo]
                                             };
                    
                    
                    [_mdDevices setValue:tmpDic forKey:pKey];
                    
                    return DeviceStatusUpdating;
                    
//                    if(time > durationThreshold){
//
//                        NSDictionary *tmpDic = @{
//                                                 kDate:dic[kDate],
//                                                 kCo2:dic[kCo2],
//                                                 kPM:dic[kPM],
//                                                 kHumidity:dic[kHumidity],
//                                                 kDeviceStatus:[NSString stringWithFormat:@"%ld", DeviceStatusNormal],
//                                                 kDeviceConnectInfo: dic[kDeviceConnectInfo]
//                                                 };
//
//
//                        [_mdDevices setValue:tmpDic forKey:pKey];
//
//                        return DeviceStatusNormal;
//                    }
//                    else{
//
//                        NSDictionary *tmpDic = @{
//                                                 kDate:dic[kDate],
//                                                 kCo2:dic[kCo2],
//                                                 kPM:dic[kPM],
//                                                 kHumidity:dic[kHumidity],
//                                                 kDeviceStatus:[NSString stringWithFormat:@"%ld", DeviceStatusUpdating],
//                                                 kDeviceConnectInfo: dic[kDeviceConnectInfo]
//                                                 };
//
//
//                        [_mdDevices setValue:tmpDic forKey:pKey];
//
//                        return DeviceStatusUpdating;
//                    }
                    
                }
                else{
                    return DeviceStatusNormal;
                }
                
            }
            
        }
        else{
            //changed
            //update the dic
            NSDictionary *dicChanged = @{
                                  kDate:[NSDate date],
                                  kCo2:[NSString stringWithFormat:@"%ld", pCo2Value],
                                  kPM:[NSString stringWithFormat:@"%ld", pPmValue],
                                  kHumidity:[NSString stringWithFormat:@"%ld", pHumidity],
                                  kDeviceStatus:[NSString stringWithFormat:@"%ld", DeviceStatusNormal],
                                  kDeviceConnectInfo: dic[kDeviceConnectInfo]
                                  };
            [_mdDevices setValue:dicChanged forKey:pKey];
            
            return DeviceStatusNormal;
        }
        
    }
    else{
        //be first
        NSDictionary *dic = @{
                              kDate:[NSDate date],
                              kCo2:[NSString stringWithFormat:@"%ld", pCo2Value],
                              kPM:[NSString stringWithFormat:@"%ld", pPmValue],
                              kHumidity:[NSString stringWithFormat:@"%ld", pHumidity],
                              kDeviceStatus:[NSString stringWithFormat:@"%ld", DeviceStatusUpdating],
                              kDeviceConnectInfo: [NSString stringWithFormat:@"%ld", DeviceConnectionStatusUnknow]
                              };
        [_mdDevices setObject:dic forKey:pKey];
        
        return DeviceStatusUpdating;
        
    }
    
    
    return result;
}


- (NSDictionary *)fetchLocalSavedWithKey:(NSString *)pKey
{
    NSDictionary *dicResult = nil;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:DocumentsPath(pKey)]){
        NSData *dataJSON = [NSData dataWithContentsOfFile:DocumentsPath(pKey)];
        dicResult = [NSJSONSerialization JSONObjectWithData:dataJSON
                                                    options:NSJSONReadingMutableContainers
                                                      error:nil];
    }
    return dicResult;
}

- (void)saveWithKey:(NSString *)pKey
               data:(NSDictionary *)pData
{
    
    //save new json
    NSData *data= [NSJSONSerialization dataWithJSONObject:pData options:NSJSONWritingPrettyPrinted error:nil];
    [data writeToFile:DocumentsPath(pKey) atomically:YES];
}

@end
