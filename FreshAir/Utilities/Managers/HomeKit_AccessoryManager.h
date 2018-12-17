//
//  AccessoryManager.h
//  FreshAir
//
//  Created by mars on 27/11/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HomeKit/HomeKit.h>

@protocol AccessoryManagerDelegate <NSObject>

@optional
- (void)accessoryManagerUpdateDevices:(NSMutableArray *_Nullable)pDevices;

- (void)accessoryManagerUpdateHomes:(NSArray *_Nullable)pHomes;
- (void)accessoryDidUpdateStatus:(HMAccessory *_Nullable)pAccessory;

- (void)accessory:(HMAccessory *_Nullable)pAccessory didAdded:(NSError *_Nullable)pError;
@end

@interface HomeKit_AccessoryManager : NSObject

@property (nonatomic, assign) id<AccessoryManagerDelegate> _Nullable delegate;
@property (nonatomic,strong) HMHomeManager * _Nullable homeManager;
@property (nonatomic,strong) HMHome * _Nullable currentHome;

@property (nonatomic, strong) NSMutableDictionary * _Nullable isUpgrading;
@property (nonatomic, strong) NSMutableDictionary * _Nullable upgradeWIFI;

@property (nonatomic, strong) NSMutableDictionary * _Nullable mdTimeOutContainer;
@property (nonatomic, strong) NSMutableDictionary * _Nullable mdFromBackEndCotainer;

@property (nonatomic, assign) BOOL isAdding;

+ (HomeKit_AccessoryManager *_Nullable)sharedInstance;
- (BOOL)checkCurrrentUserIsAdmin;
- (void)searchAccessoryWithCompletionBlock:(void(^_Nullable)(HMAccessory *   _Nullable result))pCompletionBlock;
- (void)stopSearchAccessory;
- (void)addAccessory:(HMAccessory *_Nullable)pAccessory completionHandler:(nonnull void (^)(NSError * _Nullable error))completion;
- (void)addAccessory:(HMAccessory *_Nullable)pAccessory;
- (void)updateAccessoryName:(NSString *_Nullable)pName accessory:(HMAccessory *_Nullable)pAccessory completionHandler:(nonnull void (^)(NSError * _Nullable error))completion;
- (void)getHomesNotify;
//for charactiric
- (void)updateCharacteristic:(HMCharacteristic *_Nullable)pCharacteristic value:(NSInteger)pValue completionHandler:(nonnull void (^)(NSError * _Nullable error))completion;

//for home
- (void)addHomeWithName:(NSString *_Nullable)pName completionHandler:(nonnull void (^)(NSError * _Nullable error))completion;

- (void)readValueWithAccessories:(NSMutableArray *_Nullable)pAccessories;
- (void)checkPermissionStatusWithCompletionHandler:(nonnull void (^)(BOOL hasPermission))completion;
- (void)enableNotificationWithDevice:(NSMutableDictionary *)pDevice;
@end
