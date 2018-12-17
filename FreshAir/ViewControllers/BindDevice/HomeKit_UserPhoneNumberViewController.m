//
//  UserPhoneNumberViewController.m
//  FreshAir
//
//  Created by mars on 2018/5/2.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_UserPhoneNumberViewController.h"

#import "HomeKit_ColorManager.h"
#import "AppDelegate.h"
#import "HomeKit_CommonAPI.h"

#import "HomeKit_UserService.h"
#import "HomeKit_User.h"

#import "HomeKit_DeviceService.h"

#import "HomeKit_ArrayServiceResponse.h"
#import "HomeKit_BooleanResponse.h"
#import "HomeKit_StringResponse.h"
#import "JGProgressHUD.h"

@interface HomeKit_UserPhoneNumberViewController ()
{
    __weak IBOutlet UITableView *_tv;
    __weak IBOutlet UIView *_viewHeader;
    
    __weak IBOutlet UILabel *_lblUserPhoneNumber;
    __weak IBOutlet UITextField *_tfUserPhoneNumber;
    
    JGProgressHUD *_hud;
}
@end

@implementation HomeKit_UserPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tv.backgroundColor = [[HomeKit_ColorManager sharedInstance] mainBgLightGray];
    _viewHeader.backgroundColor = [[HomeKit_ColorManager sharedInstance] mainBgLightGray];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(actionForNext)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self setTitle:@"用户信息"];
    _lblUserPhoneNumber.text = @"电话号码";
    
    _tfUserPhoneNumber.placeholder = @"请填写电话号码";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionForNext
{
    if(_tfUserPhoneNumber.text.length == 0){
        [self showDropdownViewWithMessage:@"电话号码为空"];
        return;
    }
    
    if(![[HomeKit_CommonAPI sharedInstance] validateContactNumber:_tfUserPhoneNumber.text]){
        [self showDropdownViewWithMessage:@"请输入正确的电话号码"];
        return;
    }
    
    if(!_hud){
        _hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        _hud.textLabel.text = @"加载...";
        [_hud showInView:self.navigationController.view];
    }
    
    MLWeakSelf weakSelf = self;
    
    [[HomeKit_DeviceService sharedInstance] saveUserInfoProjectWithOpenID:[HomeKit_UserService sharedInstance].user.openid
                                               phoneNumber:_tfUserPhoneNumber.text
                                           completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                               [weakSelf handleCompletionForSearchUserPhoneNumberServiceResponse:(HomeKit_BooleanResponse *)pServiceResponse];
                                           }];
}

- (void)handleCompletionForSearchUserPhoneNumberServiceResponse:(HomeKit_BooleanResponse *)pServiceResponse
{
    if (pServiceResponse.httpStatusType != HttpStatusTypeOK) {
        [self showDropdownViewWithHttpStatusType:pServiceResponse.httpStatusType];
        if(_hud){
            [_hud dismiss];
            _hud = nil;
        }
        return;
    }
    
    if (!pServiceResponse.success) {
        [self showDropdownViewWithHttpStatusType:pServiceResponse.httpStatusType];
        if(_hud){
            [_hud dismiss];
            _hud = nil;
        }

        return;
    }

    if(!pServiceResponse.responseResult){
        [self showDropdownViewWithHttpStatusType:pServiceResponse.httpStatusType];
        if(_hud){
            [_hud dismiss];
            _hud = nil;
        }

    }
    else{
        //save step 1
        MLWeakSelf weakSelf = self;
        HomeKit_DeviceService *service = [HomeKit_DeviceService sharedInstance];
        HomeKit_UserService *userService = [HomeKit_UserService sharedInstance];
        
        
        [service reBindingDeviceWithPID:self.deviceID
                                    did:@""
                                   cDId:@""
                                     sn:self.deviceSN
                               platform:@"xlink"
                                    uId:userService.user.unionid
                                 openID:userService.user.openid
                        completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                            
                            if(_hud){
                                [_hud dismiss];
                                _hud = nil;
                            }
                            
                            HomeKit_BooleanResponse *response = (HomeKit_BooleanResponse *)pServiceResponse;
                                                        if(response.responseResult){
                                                            //        getAllDevices
                                                            [[HomeKit_DeviceService sharedInstance] getAllDevicesWithUID:userService.user.unionid openID:userService.user.openid completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                                
                                                                [weakSelf popToRoot];
                                                            }];

                                                        }
                                                        else{
                                                            [weakSelf showDropdownViewWithHttpStatusType:pServiceResponse.httpStatusType];

                                                        }
                                                    }];
    }
    
    
}

- (void)popToRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
