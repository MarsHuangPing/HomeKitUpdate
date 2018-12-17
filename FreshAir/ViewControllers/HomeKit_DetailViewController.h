//
//  ViewController.h
//  FreshAir
//
//  Created by mars on 08/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_BaseViewController.h"

//@class Device;


@interface HomeKit_DetailViewController : HomeKit_BaseViewController

@property (nonatomic, strong) NSMutableDictionary *device;

@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) NSInteger outdoorValue;

- (void)readValue;
@end

