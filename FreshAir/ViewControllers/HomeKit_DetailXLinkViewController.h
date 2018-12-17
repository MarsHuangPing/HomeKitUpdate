//
//  HomeKit_DetailXLinkViewController.h
//  FreshAir
//
//  Created by mars on 2018/8/31.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_BaseViewController.h"

@class XLinkDevice;

@interface HomeKit_DetailXLinkViewController : HomeKit_BaseViewController

@property (nonatomic, strong) XLinkDevice *XLinkDevice;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) NSInteger outdoorValue;

@end
