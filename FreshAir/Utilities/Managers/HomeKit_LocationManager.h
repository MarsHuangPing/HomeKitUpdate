//
//  LocationManager.h
//  NewPeek2
//
//  Created by Tyler on 6/20/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

typedef void(^CompletionBlock)(CLPlacemark *pPlace);

@interface HomeKit_LocationManager : NSObject

#pragma mark - Singleton

+ (HomeKit_LocationManager *)sharedInstance;

#pragma mark - Methods

- (void)updateLocationWithCompletionBlock:(CompletionBlock)pCompletionBlock;

@end
