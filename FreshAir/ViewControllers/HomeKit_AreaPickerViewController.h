//
//  AreaPickerViewController.h
//  FreshAir
//
//  Created by mars on 23/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_BaseViewController.h"

@class HomeKit_CustomerAreaStationInfo;

@protocol AreaPickerViewControllerDelegate <NSObject>

@required
- (void)updateLocation:(HomeKit_CustomerAreaStationInfo *)pCustomerAreaStationInfo;

@end

@interface HomeKit_AreaPickerViewController : HomeKit_BaseViewController

@property (nonatomic, assign) id<AreaPickerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) HomeKit_CustomerAreaStationInfo *customerAreaStationInfo;
@property (nonatomic, strong) NSString *homeID;

@end
