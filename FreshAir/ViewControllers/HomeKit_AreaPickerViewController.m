//
//  AreaPickerViewController.m
//  FreshAir
//
//  Created by mars on 23/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_AreaPickerViewController.h"

#import "HomeKit_AreaCollectionViewCell.h"

#import "HomeKit_ColorManager.h"

#import "HomeKit_DeviceService.h"

#import "HomeKit_Pm25CityStation.h"
#import "HomeKit_Pm25CityStationRequest.h"
#import "HomeKit_Pm25CityStationResponse.h"

#import "HomeKit_CustomerAreaStationInfo.h"
#import "HomeKit_WatchInfoOutdoorRequest.h"

#import "HomeKit_ArrayServiceResponse.h"

@interface HomeKit_AreaPickerViewController ()<UITextFieldDelegate>
{
    __weak IBOutlet UICollectionView *_cvArea;
    
    __weak IBOutlet UIView *_viewStationPanel;
    __weak IBOutlet UILabel *_lblStation;
    
    __weak IBOutlet UITextField *_tfCity;
    
    __weak IBOutlet UILabel *_lblCityTitle;
    __weak IBOutlet UILabel *_lblSelectStationWarning;
    
    NSMutableArray *_maAreas;
    
    __weak IBOutlet UICollectionView *_cvCity;
    __weak IBOutlet NSLayoutConstraint *_cCVCityHieght;
    NSMutableArray *_maCities;
}
@end

@implementation HomeKit_AreaPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[HomeKit_ColorManager sharedInstance] colorTopBarAndBanner];
    _viewStationPanel.backgroundColor = [[HomeKit_ColorManager sharedInstance] colorTopBarAndBanner];
    
    if(self.customerAreaStationInfo == nil){
        self.customerAreaStationInfo = [[HomeKit_CustomerAreaStationInfo alloc] init];
    }
    
    _tfCity.delegate = self;
    _tfCity.text = self.city;
    
    [self setTitle:@"选择城市和监测站"];
    _lblCityTitle.text = @"选择城市定位";
    _lblSelectStationWarning.text = @"选择城市和监测站";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(actionForSave)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self getStations];
    
    _viewStationPanel.hidden = self.area == nil;
    _lblStation.text = self.area;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (void)actionForSave
{
    
    
    if(_tfCity.text.length != 0){
        self.customerAreaStationInfo.area = _tfCity.text;
    }
    else{
        [self showDropdownViewWithMessage:@"请输入城市"];
        return;
    }
    
    [[HomeKit_DeviceService sharedInstance] saveLocationWithCityName:self.customerAreaStationInfo.area
                                                 stationName:self.customerAreaStationInfo.positionName
                                                 stationCode:self.customerAreaStationInfo.stationCode
                                                      homeID:self.homeID];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(updateLocation:)]) {
        [self.delegate updateLocation:self.customerAreaStationInfo];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionForRemoveStation:(id)sender {
    self.area = nil;
    _viewStationPanel.hidden = self.area == nil;
    self.customerAreaStationInfo.positionName = nil;
    self.customerAreaStationInfo.stationCode = nil;
}

- (void)getStations
{
    if(self.city.length == 0){
        return;
    }
        
    HomeKit_Pm25CityStationRequest *pm25CityStationRequest = [[HomeKit_Pm25CityStationRequest alloc] initWithArea:self.city];
    MLWeakSelf weakSelf = self;
    [[HomeKit_DeviceService sharedInstance] fetchPm25CityStationWithRequest:pm25CityStationRequest completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
        [weakSelf handleCompletionForStationsWithServiceResponse:(HomeKit_Pm25CityStationResponse *)pServiceResponse];
    }];
}

- (void)handleCompletionForStationsWithServiceResponse:(HomeKit_Pm25CityStationResponse *)pServiceResponse
{
    
    
    if (pServiceResponse.httpStatusType != HttpStatusTypeOK) {
        [self showDropdownViewWithHttpStatusType:pServiceResponse.httpStatusType];
        
        return;
    }
    
    if (!pServiceResponse.success) {
        [self showDropdownViewWithHttpStatusType:pServiceResponse.httpStatusType];
        
        return;
    }
    
    if (pServiceResponse.maStations.count == 0) {
        [self showDropdownViewWithHttpStatusType:HttpStatusTypeNoDevice];
        return;
    }
    
    _maAreas = pServiceResponse.maStations;
    
    //clean selected station
    [_cvArea reloadData];
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
    
    float height = 0;
    NSInteger row = _maCities.count / 3 + _maCities.count % 3;
    height = row * 40;
    
    [UIView animateWithDuration:.5 animations:^{
        _cCVCityHieght.constant = height;

    }];
    [self.view setNeedsDisplay];
    
    [_cvCity reloadData];
    
    if(![self.city isEqualToString:_tfCity.text]){
        self.city = _tfCity.text;
        self.customerAreaStationInfo.area = _tfCity.text;
        [self getStations];
    }
    
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.customerAreaStationInfo.area = textField.text;
    NSLog(@"%@", textField.text);
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"获得焦点");
    _cCVCityHieght.constant = 0;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"失去焦点");
    if(textField.text.length != 0){
        
        MLWeakSelf weakSelf = self;
        [[HomeKit_DeviceService sharedInstance] fetchSearchNearCityWithRequest:textField.text completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
            [weakSelf handleCompletionForCitiesWithServiceResponse:(HomeKit_ArrayServiceResponse *)pServiceResponse];
            [self actionForRemoveStation:nil];
        }];
    }
    
}


#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView.tag == 1){
        static NSString *cellIdentifier = @"cellidentifier.area";
        HomeKit_AreaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                                 forIndexPath:indexPath];
        
        HomeKit_Pm25CityStation *station = [_maAreas objectAtIndex:indexPath.row];
        cell.lblAreaName.text = station.positionName;
        
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"cellidentifier.city";
        HomeKit_AreaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                                 forIndexPath:indexPath];

        NSString *city = [_maCities objectAtIndex:indexPath.row];
        cell.lblAreaName.text = city;

        return cell;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView.tag == 1){
        return _maAreas.count;
    }
    else{
        return _maCities.count;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 1){
        HomeKit_Pm25CityStation *station = [_maAreas objectAtIndex:indexPath.row];
        NSString *name = station.positionName;
        self.area = name;
        _viewStationPanel.hidden = self.area == nil;
        _lblStation.text = self.area;
        self.customerAreaStationInfo.positionName = station.positionName;
        self.customerAreaStationInfo.stationCode = station.stationCode;
    }
    else{
        NSString *city = [_maCities objectAtIndex:indexPath.row];
        MLWeakSelf weakSelf = self;
        [[HomeKit_DeviceService sharedInstance] fetchSearchNearCityWithRequest:city completionBlock:^(HomeKit_ServiceResponse *pServiceResponse) {
            if(pServiceResponse.success){
                _tfCity.text = city;
                self.customerAreaStationInfo.area = city;
            }
            [weakSelf handleCompletionForCitiesWithServiceResponse:(HomeKit_ArrayServiceResponse *)pServiceResponse];
            [self actionForRemoveStation:nil];
        }];
    }
    
    NSLog(@"did selected at %ld, the name is: %@", indexPath.row, [_maAreas objectAtIndex:indexPath.row]);
}


@end
