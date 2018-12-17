//
//  HelpViewController.m
//  FreshAir
//
//  Created by mars on 29/12/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_HelpViewController.h"

@interface HomeKit_HelpViewController ()

@end

@implementation HomeKit_HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(actionForBack)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionForCall:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4008270838"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    
    
}

- (void)actionForBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
