//
//  LocationManager.m
//  NewPeek2
//
//  Created by Tyler on 6/20/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import "HomeKit_LocationManager.h"

@interface HomeKit_LocationManager () <CLLocationManagerDelegate>
{
    CLLocationManager *_lmCurrent;
    
    CompletionBlock _completionBlock;
}

@end

@implementation HomeKit_LocationManager

#pragma mark - Singleton

- (id)init
{
    if (self = [super init]) {
        _lmCurrent = [[CLLocationManager alloc] init];
        _lmCurrent.delegate = self;
        _lmCurrent.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _lmCurrent.distanceFilter = 100.0;
    }
    
    return self;
}

+ (HomeKit_LocationManager *)sharedInstance
{
    static HomeKit_LocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeKit_LocationManager alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [_lmCurrent stopUpdatingLocation];

    CLGeocoder *geo = [[CLGeocoder alloc] init];
    
    [geo reverseGeocodeLocation:newLocation completionHandler: ^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            ExecuteBlockWithOneParam(_completionBlock, placemark);
        }
        else {
            ExecuteBlockWithOneParam(_completionBlock, nil);
        } 
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    ExecuteBlockWithOneParam(_completionBlock, nil);
}

#pragma mark - Methods

- (void)updateLocationWithCompletionBlock:(void(^)(CLPlacemark *pPlace))pCompletionBlock
{
    _completionBlock = [pCompletionBlock copy];

    if ([CLLocationManager locationServicesEnabled] ) {
        if (GE_iOS8) {
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ||
                [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
                [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
                [_lmCurrent requestWhenInUseAuthorization];
//                [_lmCurrent requestAlwaysAuthorization];
                [_lmCurrent startUpdatingLocation];
            }
            else {
                ExecuteBlockWithOneParam(pCompletionBlock, nil);
            }
        }
        else {
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ||
                [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
                [_lmCurrent startUpdatingLocation];
            }
            else {
                ExecuteBlockWithOneParam(pCompletionBlock, nil);
            }
        }
    }
    else {
        ExecuteBlockWithOneParam(pCompletionBlock, nil);
    }
}

@end
