//
//  DevicesRequest.h
//  FreshAir
//
//  Created by mars on 07/08/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HomeKit_User;

@interface HomeKit_DevicesRequest : NSObject

@property (nonatomic, strong, readonly) HomeKit_User *user;

- (HomeKit_DevicesRequest *)initWithUser:(HomeKit_User *)pUser;

@end
