//
//  DeviceManager.h
//  NewPeek2
//
//  Created by Tyler on 10/24/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_DeviceManager : NSObject

#pragma mark - Singleton

+ (HomeKit_DeviceManager *)sharedInstance;

#pragma mark - Methods

- (NSString *)systemVersion;
- (NSString *)systemLanguage;
- (NSString *)deviceResolution;
- (NSString *)deviceType;
- (NSString *)ipAddress;
- (NSString *)macAddress;
- (double)totalMemory;
- (double)availableMemory;
- (double)totalDiskSpace;
- (double)freeDiskSpace;
- (NSString *)bundleVersion;

@end
