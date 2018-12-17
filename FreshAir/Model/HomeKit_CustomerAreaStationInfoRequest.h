//
//  CustomerAreaStationInfoRequest.h
//  FreshAir
//
//  Created by mars on 24/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_CustomerAreaStationInfoRequest : NSObject
@property (nonatomic, strong) NSString *openId;

- (HomeKit_CustomerAreaStationInfoRequest *)initWithOpenId:(NSString *)pOpenId;
@end
