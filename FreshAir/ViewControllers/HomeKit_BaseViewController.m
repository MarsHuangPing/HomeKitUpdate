//
//  BaseViewController.m
//  FreshAir
//
//  Created by mars on 18/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_BaseViewController.h"
#import "YRDropdownView.h"

@interface HomeKit_BaseViewController ()

@end

@implementation HomeKit_BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationItem.backBarButtonItem setTitle:@""];
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillDisappear:animated];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDropdownViewWithHttpStatusType:(HttpStatusType)pHttpStatusType
{
    NSString *strInfo = nil;
    
    switch (pHttpStatusType) {
        case HttpStatusTypeTimeout:
        {
            strInfo = @"访问超时！";
            
            break;
        }
        case HttpStatusTypeNONetwork:
        {
            strInfo = @"没有网络！";
            
            break;
        }
        case HttpStatusTypeServerError:
        {
            strInfo = @"服务器错误！";
            
            break;
        }
        case HttpStatusTypeNoDevice:
        {
            strInfo = @"没有设备！";
            
            break;
        }
        default:
        {
            strInfo = @"服务器错误！";
            
            break;
        }
    }
    
    [YRDropdownView showDropdownInView:self.navigationController.view
                                 title:@"Warning"
                                detail:strInfo
                                 image:[UIImage imageNamed:@"dropdown-alert"]
                              animated:YES hideAfter:2];
}

- (void)showDropdownViewWithLocationAccessErrorType:(LocationAccessErrorType)pError
{
    NSString *strInfo = nil;
    
    if(pError != LocationAccessErrorTypeNormall){
        strInfo = @"拒绝访问！";
    }
    
    [YRDropdownView showDropdownInView:self.navigationController.view
                                 title:@"Warning"
                                detail:strInfo
                                 image:[UIImage imageNamed:@"dropdown-alert"]
                              animated:YES hideAfter:2];
}

- (void)showDropdownViewWithMessage:(NSString *)pMessage
{
    
    [YRDropdownView showDropdownInView:self.navigationController.view
                                 title:@"Warning"
                                detail:pMessage
                                 image:[UIImage imageNamed:@"dropdown-alert"]
                              animated:YES hideAfter:2];
}

- (void)setTitle:(NSString *)pTitle
{
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 80, 40)];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.text = pTitle;
    
    self.navigationItem.titleView = lblTitle;

}


@end
