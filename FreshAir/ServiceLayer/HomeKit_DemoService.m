//
//  DemoService.m
//  FreshAir
//
//  Created by mars on 11/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_DemoService.h"


@implementation HomeKit_DemoService

#pragma mark - Singleton

+ (HomeKit_DemoService *)sharedInstance
{
    static HomeKit_DemoService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeKit_DemoService alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Methods

- (void)fetchHomeHeaderItemsWithRequest:(NSString *)pRequest
                        completionBlock:(ServiceCompletionBlock)pCompletionBlock
{

}


@end
