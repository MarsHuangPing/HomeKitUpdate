//
//  DemoService.h
//  FreshAir
//
//  Created by mars on 11/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_DemoService : NSObject

#pragma mark - Singleton

+ (HomeKit_DemoService *)sharedInstance;

#pragma mark - Methods

- (void)fetchHomeHeaderItemsWithRequest:(NSString *)pRequest
                        completionBlock:(ServiceCompletionBlock)pCompletionBlock;


@end
