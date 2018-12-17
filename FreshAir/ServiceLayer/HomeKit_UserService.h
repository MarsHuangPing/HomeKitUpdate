//
//  UserSevice.h
//  FreshAir
//
//  Created by mars on 10/07/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeKit_User;

@interface HomeKit_UserService : NSObject

+ (HomeKit_UserService *)sharedInstance;
#pragma mark - Methods

@property (nonatomic, strong) HomeKit_User *user;

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *currentMacAddress;
@property (nonatomic, assign) BOOL ifEnterWifiConfig;

//- (void)fetchAdverWithCompletionBlock:(ServiceCompletionBlock)pCompletionBlock;
//- (void)fetchAdverPictureWithURL:(NSURL *)pURL completionBlock:(ServiceCompletionBlock)pCompletionBlock;

@end
