//
//  HistoryInfoRequest.h
//  FreshAir
//
//  Created by mars on 25/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryInfoRequest : NSObject

@property (nonatomic, strong) NSString *openId;
@property (nonatomic, strong) NSString *physicalDeviceId;
@property (nonatomic, strong) NSString *area;

- (HistoryInfoRequest *)initWithArea:(NSString *)pArea
                    physicalDeviceId:(NSString *)pPhysicalDeviceId
                              openId:(NSString *)pOpenId;

@end
