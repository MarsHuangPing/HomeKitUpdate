//
//  ArrayServiceResponse.h
//  FreshAir
//
//  Created by mars on 26/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_ServiceResponse.h"

@interface HomeKit_ArrayServiceResponse : HomeKit_ServiceResponse

@property (nonatomic, strong) NSMutableArray *maData;

- (HomeKit_ArrayServiceResponse *)initWithData:(NSMutableArray *)pData;

@end
