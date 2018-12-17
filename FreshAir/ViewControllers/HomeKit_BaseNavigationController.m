//
//  BaseNavigationController.m
//  FreshAir
//
//  Created by mars on 28/11/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_BaseNavigationController.h"

@interface HomeKit_BaseNavigationController ()

@end

@implementation HomeKit_BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

@end
