//
//  AboutViewController.h
//  FreshAir
//
//  Created by mars on 06/12/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_BaseViewController.h"

@interface HomeKit_AboutViewController : HomeKit_BaseViewController
@property (nonatomic, strong) NSMutableDictionary *device;

- (void)startToCheckUpgrade;
- (void)valueWhenEnterBg;
@end
