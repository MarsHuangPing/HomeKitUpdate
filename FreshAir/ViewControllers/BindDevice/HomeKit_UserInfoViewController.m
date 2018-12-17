//
//  UserInfoViewController.m
//  FreshAir
//
//  Created by mars on 2018/5/2.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_UserInfoViewController.h"
#import "HomeKit_UserPhoneNumberViewController.h"

#import "HomeKit_ColorManager.h"
#import "AppDelegate.h"
#import "HomeKit_CommonAPI.h"

#import "HomeKit_UserService.h"
#import "HomeKit_User.h"

#import "HomeKit_AreaCollectionViewCell.h"

#import "HomeKit_ColorManager.h"
#import "HomeKit_DeviceService.h"

#import "HomeKit_Pm25CityStation.h"
#import "HomeKit_Pm25CityStationRequest.h"
#import "HomeKit_Pm25CityStationResponse.h"

#import "HomeKit_CustomerAreaStationInfo.h"
#import "UpdateCustomerAreaStationRequest.h"

#import "HomeKit_ArrayServiceResponse.h"
#import "HomeKit_BooleanResponse.h"
#import "HomeKit_StringResponse.h"

#import "JGProgressHUD.h"

@interface HomeKit_UserInfoViewController ()<UITextFieldDelegate>
{
    __weak IBOutlet UITableView *_tv;
    __weak IBOutlet UIView *_viewHeader;
    
    __weak IBOutlet UILabel *_lblDeviceName;
    __weak IBOutlet UITextField *_tfDeviceName;
    
    __weak IBOutlet UILabel *_lblDetailAddress;
    __weak IBOutlet UITextField *_tfDetailAddress;
    
    __weak IBOutlet UILabel *_lblCity;
    __weak IBOutlet UITextField *_tfCity;
    
    
    __weak IBOutlet UILabel *_lblNearCity;
    __weak IBOutlet UICollectionView *_cvNearCity;
    
    NSMutableArray *_maCities;
    JGProgressHUD *_hud;
}
@end

@implementation HomeKit_UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tv.backgroundColor = [[HomeKit_ColorManager sharedInstance] mainBgLightGray];
    _viewHeader.backgroundColor = [[HomeKit_ColorManager sharedInstance] mainBgLightGray];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(actionForNext)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    _tfCity.delegate = self;
    _tfCity.text = [HomeKit_UserService sharedInstance].city;
    [self setTitle:@"更新用户信息"];
    
    _lblDeviceName.text = @"设备名称";
    _lblDetailAddress.text = @"详细地址";
    _lblCity.text = @"城市定位";
    _lblNearCity.text = @"周边城市";
    
    _tfDeviceName.placeholder = @"请输入设备名称";
//    _tfDetailAddress.placeholder = @"New_User_Info_Address_PlaceHolder";
//    _tfCity.placeholder = @"New_User_Info_City_PlaceHolder";
    
    
    MLWeakSelf weakSelf = self;
    [[HomeKit_DeviceService sharedInstance] fetchSearchNearCityWithRequest:_tfCity.text completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
        [weakSelf handleCompletionForCitiesWithServiceResponse:(HomeKit_ArrayServiceResponse *)pServiceResponse];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [UserService sharedInstance].bindDeviceStep = BindDeviceStepUserInfo;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionForNext {
    
//    HomeKit_UserPhoneNumberViewController *vcUserPhoneNumber = (HomeKit_UserPhoneNumberViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"UserPhoneNumberViewController"];
//    [self.navigationController pushViewController:vcUserPhoneNumber animated:YES];
    
    if(_tfDeviceName.text.length == 0){
        [self showDropdownViewWithMessage:@"请填写用户名"];
        return;
    }
    
    if(_tfDetailAddress.text.length == 0){
        [self showDropdownViewWithMessage:@"请填写用户地址"];
        return;
    }
    
    if(!_hud){
        _hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        _hud.textLabel.text = @"加载...";
        [_hud showInView:self.navigationController.view];
    }
    
    NSString *uid = [HomeKit_UserService sharedInstance].user.unionid;
    
    MLWeakSelf weakSelf = self;
    [[HomeKit_DeviceService sharedInstance] updateBoundDeviceAddressAreaWithPID:self.deviceID
                                                                         openID:[HomeKit_UserService sharedInstance].user.openid
                                                                        address:_tfDetailAddress.text
                                                                           area:_tfCity.text
                                                                     deivceName:_tfDeviceName.text
                                                                completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
                                                                    [weakSelf handleCompletionForDidUpdateUserInfoServiceResponse:(HomeKit_BooleanResponse *)pServiceResponse];
                                                                }];

    
    
}

- (void)handleCompletionForDidUpdateUserInfoServiceResponse:(HomeKit_BooleanResponse *)pServiceResponse
{
    if (pServiceResponse.httpStatusType != HttpStatusTypeOK) {
        [self showDropdownViewWithHttpStatusType:pServiceResponse.httpStatusType];
        return;
    }

    if (!pServiceResponse.success) {
        [self showDropdownViewWithHttpStatusType:pServiceResponse.httpStatusType];

        return;
    }

    if (!pServiceResponse.responseResult) {
        [self showDropdownViewWithMessage:@"保存用户信息失败"];

        return;
    }

    if(!_hud){
        _hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        _hud.textLabel.text = @"加载...";
        [_hud showInView:self.navigationController.view];
    }

    MLWeakSelf weakSelf = self;
    [[HomeKit_DeviceService sharedInstance] searchCustomerInfoWithOpenID:[HomeKit_UserService sharedInstance].user.openid
                                                   completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {

                                                       if(_hud){
                                                           [_hud dismiss];
                                                           _hud = nil;
                                                       }
     
                                                       [weakSelf handleCompletionForSearchUserPhoneNumberServiceResponse:(HomeKit_BooleanResponse *)pServiceResponse];
                                                   }];
    
}

- (void)handleCompletionForSearchUserPhoneNumberServiceResponse:(HomeKit_BooleanResponse *)pServiceResponse
{
    if (pServiceResponse.httpStatusType != HttpStatusTypeOK) {
        [self showDropdownViewWithHttpStatusType:pServiceResponse.httpStatusType];
        return;
    }

    if (!pServiceResponse.success) {
        [self showDropdownViewWithHttpStatusType:pServiceResponse.httpStatusType];

        return;
    }

    if(!pServiceResponse.responseResult){
        //go to input phone number
        HomeKit_UserPhoneNumberViewController *vcUserPhoneNumber = (HomeKit_UserPhoneNumberViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"UserPhoneNumberViewController"];
        vcUserPhoneNumber.deviceSN = self.deviceSN;
        vcUserPhoneNumber.deviceID = self.deviceID;
        [self.navigationController pushViewController:vcUserPhoneNumber animated:YES];

    }
    else{
        //save step 1
        if(!_hud){
            _hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
            _hud.textLabel.text = @"加载...";
            [_hud showInView:self.navigationController.view];
        }
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

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSLog(@"%@", textField.text);
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"获得焦点");
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"失去焦点");
    if(textField.text.length != 0){
        
        
    }
    
}

- (void)handleCompletionForCitiesWithServiceResponse:(HomeKit_ArrayServiceResponse *)pServiceResponse
{
    
    
    if (pServiceResponse.httpStatusType != HttpStatusTypeOK) {
        [self showDropdownViewWithHttpStatusType:pServiceResponse.httpStatusType];

        return;
    }

    if (!pServiceResponse.success) {
        [self showDropdownViewWithHttpStatusType:pServiceResponse.httpStatusType];

        return;
    }

    if (pServiceResponse.maData.count == 0) {
        [self showDropdownViewWithHttpStatusType:HttpStatusTypeNoDevice];
        return;
    }

    _maCities = pServiceResponse.maData;

    [_cvNearCity reloadData];
    
    
    
}



#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellidentifier.city";
    HomeKit_AreaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                             forIndexPath:indexPath];
    
    NSString *city = [_maCities objectAtIndex:indexPath.row];
    cell.lblAreaName.text = city;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _maCities.count;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *city = [_maCities objectAtIndex:indexPath.row];
    MLWeakSelf weakSelf = self;
    [[HomeKit_DeviceService sharedInstance] fetchSearchNearCityWithRequest:city completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
        if(pServiceResponse.success){
            _tfCity.text = city;
        }
        [weakSelf handleCompletionForCitiesWithServiceResponse:(HomeKit_ArrayServiceResponse *)pServiceResponse];
    }];
    
}


@end
