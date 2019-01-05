//
//  AboutViewController.m
//  FreshAir
//
//  Created by mars on 06/12/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#define kDelay 20
#define kTimeout 180
//#define kFromBackEndKey @"kFromBackEndKey"

#import "HomeKit_AboutViewController.h"
#import "HomeKit_AccessoryManager.h"
#import "NSObject+ML.h"
#import "JGProgressHUD.h"
#import "HomeKit_DateManager.h"

#import "HomeKit_DeviceService.h"

@interface HomeKit_AboutViewController ()<AccessoryManagerDelegate>
{
    
    __weak IBOutlet UIView *_viewHeaderPanel;
    __weak IBOutlet UITableView *_tv;
    
    __weak IBOutlet UIView *_viewS1;
    __weak IBOutlet UIView *_viewS2;
    __weak IBOutlet UIView *_viewS3;
    __weak IBOutlet UIView *_viewS4;
    __weak IBOutlet UIView *_viewS5;
    __weak IBOutlet UIView *_viewS6;
    __weak IBOutlet UIView *_viewS7;
    
    __weak IBOutlet UILabel *_lblSerial;
    __weak IBOutlet UILabel *_lblManufacturer;
    __weak IBOutlet UILabel *_lblModel;
    __weak IBOutlet UILabel *_lblFirmware;
    
    __weak IBOutlet UILabel *_lblOTAMCUProgress;
    __weak IBOutlet UILabel *_lblOTAWIFIProgress;
    
    __weak IBOutlet UIActivityIndicatorView *_aivMCU;
    __weak IBOutlet UIActivityIndicatorView *_aivWIFI;
    
    __weak IBOutlet UIButton *_btnRemove;
    
    NSString *_serial;
    HomeKit_AccessoryManager *_manager;
    HMAccessory *_acc;
    NSMutableDictionary *_mdCharactestiric;
    
    JGProgressHUD *_HUD;
    
//    BOOL _isFirst;
    
    NSInteger timeCount;
    
    
    NSString *_wifiLBLText;
    
    BOOL _delayMark;
    
    //protect vars
    BOOL _protectForLess100;
    BOOL _protectFromProgress100;
    BOOL _protectDidFinished;
    
    NSInteger _currentDeviceProgress;
    
    NSTimer *_timerInterrupt;
    BOOL _rereading;
    
}
@end

@implementation HomeKit_AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _isFirst = YES;
    _viewHeaderPanel.backgroundColor = [UIColor clearColor];
    _tv.backgroundColor = RGB(240, 239, 245);
    
    _currentDeviceProgress = 0;
    
    UIColor *colorSplit = RGB(201, 201, 201);
    _viewS1.backgroundColor = colorSplit;
    _viewS2.backgroundColor = colorSplit;
    _viewS3.backgroundColor = colorSplit;
    _viewS4.backgroundColor = colorSplit;
    _viewS5.backgroundColor = colorSplit;
    _viewS6.backgroundColor = colorSplit;
    _viewS7.backgroundColor = colorSplit;
    
    self.title = @"设置";
    
    _manager = [HomeKit_AccessoryManager sharedInstance];
    _manager.delegate = self;
    [_manager getHomesNotify];
    
    
    _serial = [((HMCharacteristic *)[self.device objectForKey:kPurifierSerialNumber]).value ml_stringValue];
    NSLog(@"serial.....:%@",_serial);
    if(_serial.length == 0){
        _lblSerial.text = [[HomeKit_DeviceService sharedInstance] loadDeviceParamsWithDeviceName:self.deviceName key:kPurifieSerial];
        _lblManufacturer.text = [[HomeKit_DeviceService sharedInstance] loadDeviceParamsWithDeviceName:self.deviceName key:kPurifieManufacturer];
        _lblModel.text = [[HomeKit_DeviceService sharedInstance] loadDeviceParamsWithDeviceName:self.deviceName key:kPurifieModel];
        _lblFirmware.text = [[HomeKit_DeviceService sharedInstance] loadDeviceParamsWithDeviceName:self.deviceName key:kPurifieFirmware];
        
    }
    
    
    if(_serial && _manager.isUpgrading){
        //[_manager.isUpgrading[_serial] ml_intValue]
        if(_manager.isUpgrading[_serial]){
            NSLog(@"[_manager.isUpgrading[_serial] ml_intValue] ... ...: %d", [_manager.isUpgrading[_serial] ml_intValue]);
        }
        else{
            NSLog(@"_manager.isUpgrading[_serial] is nil");
        }
        
    }
    
    _btnRemove.hidden = ![_manager checkCurrrentUserIsAdmin];
    
    [HomeKit_DeviceService sharedInstance].vcAbout = self;
    _wifiLBLText = @"";

    
    
}


- (void)startToCheckUpgrade
{
    if(_manager.isUpgrading[_serial] != nil){
        if(_serial && [_manager.isUpgrading[_serial] ml_boolValue] == YES){
            [_manager.isUpgrading removeAllObjects];
            [_manager.isUpgrading[_serial] setValue:@(NO) forKey:_serial];
        }
    }
    
    
    [self performSelector:@selector(checkUpgradeChange) withObject:nil afterDelay:5];
   
}

- (void)checkUpgradeChange
{
    
    if(_HUD){
        [_HUD dismiss];
        _HUD = nil;
    }
    
    [self readChaValue];
    [_manager getHomesNotify];
    _lblOTAWIFIProgress.text = @"";
    _lblOTAWIFIProgress.tag = 0;
}

- (void)valueWhenEnterBg
{
//    if(_serial && [_manager.isUpgrading[_serial] ml_boolValue] == YES){
//        [_manager.mdFromBackEndCotainer setObject:@(YES) forKey:_serial];
//    }
    _wifiLBLText = _lblOTAWIFIProgress.text;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self readChaValue];
//     [_manager.isUpgrading setObject:@(NO) forKey:_serial];
    NSLog(@"viewDidAppear _manager.isUpgrading setObject:@(NO) forKey:_serial");
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _lblOTAWIFIProgress.text = @"";
    _lblOTAWIFIProgress.tag = 0;
    _lblOTAMCUProgress.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (IBAction)actionForRemovingAcc:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:@"确定移除设备？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sleepAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        HMAccessory *acc = [_mdCharactestiric objectForKey:kPurifier];
        _manager.isAdding = NO;
        [_manager.currentHome removeAccessory:acc completionHandler:^(NSError * _Nullable error) {
            if(error){
                [self showDropdownViewWithMessage:@"移除设备出错，请重试！"];
            }
            else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:sleepAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}


- (IBAction)actionForUpgradeMCU:(id)sender {
 
    
}

- (IBAction)actionForUpgradeWIFI:(id)sender {
   
    if(![_manager checkCurrrentUserIsAdmin]){
        [self showDropdownViewWithMessage:@"共享用户，无更新权限！"];
        return;
    }
    
    HMAccessory *acc = [self.device objectForKey:kPurifier];
    if(!acc.reachable){
        [self showDropdownViewWithMessage:@"设备离线，不能更新！"];
        return;
    }
    
    if([_manager.isUpgrading[_serial] ml_intValue] == 1){
        [self showDropdownViewWithMessage:@"正在更新中..."];
        return;
    }

    //remove the timeout logic
    NSString *serial = [((HMCharacteristic *)[self.device objectForKey:kPurifierSerialNumber]).value ml_stringValue];
    if(serial){
        [_manager.mdTimeOutContainer removeObjectForKey:serial];
    }
    
    _aivWIFI.hidden = NO;
     [_aivWIFI startAnimating];
    _lblOTAWIFIProgress.text = @"";
    _lblOTAWIFIProgress.tag = 0;
    __block NSInteger i = 0;
   
    if(!_manager.upgradeWIFI){
        _manager.upgradeWIFI = [NSMutableDictionary dictionary];
    }
    _delayMark = NO;
    _rereading = NO;
    
    [_manager.isUpgrading setObject:@(YES) forKey:_serial];
    if(_mdCharactestiric){
        HMCharacteristic *cha = [_mdCharactestiric objectForKey:kPurifieStartUpgrade];
        if(cha){
            [_manager updateCharacteristic:cha value:1 completionHandler:^(NSError * _Nullable error) {
                if(error){
                    i++;
                    if(i < 2){
                        [_manager updateCharacteristic:cha value:1 completionHandler:^(NSError * _Nullable error) {
                            if(error){
                                [self stopAIV];
                                [self showDropdownViewWithMessage:@"异常，请重试！"];
                                [_manager.isUpgrading setObject:@(NO) forKey:_serial];
                                
                            }
                            else{
                                [_manager.isUpgrading setObject:@(YES) forKey:_serial];
                                HMCharacteristic *cha = [_mdCharactestiric objectForKey:kPurifieUpgradeProgress];
                                [cha enableNotification:YES completionHandler:^(NSError * _Nullable error) {
                                    if(error){
                                        [self stopAIV];
                                        [self showDropdownViewWithMessage:@"异常，请重试！"];
                                         [_manager.isUpgrading setObject:@(NO) forKey:_serial];
                                    }
                                    else{
                                        [_manager getHomesNotify];
                                        [self performSelector:@selector(changeDelayMarkToYes) withObject:nil afterDelay:kDelay];
                                    }
                                }];
                                
                                
                            }
                        }];
                    }
                    
                }
                else{
                    [_manager.isUpgrading setObject:@(YES) forKey:_serial];
                    HMCharacteristic *cha = [_mdCharactestiric objectForKey:kPurifieUpgradeProgress];
                    [cha enableNotification:YES completionHandler:^(NSError * _Nullable error) {
                        if(error){
                            [self stopAIV];
                            [self showDropdownViewWithMessage:@"异常，请重试！"];
                             [_manager.isUpgrading setObject:@(NO) forKey:_serial];
                        }
                        else{
                            [_manager getHomesNotify];
                            
                            [self performSelector:@selector(changeDelayMarkToYes) withObject:nil afterDelay:kDelay];
                        }
                    }];

                    
                }
            }];
        }
    }
}

- (void)changeDelayMarkToYes
{
    _delayMark = YES;
}

- (void)checkDeviceStatursWithDevice:(HMAccessory *)pDevice
{
    
    HMAccessory *acc = [self.device objectForKey:kPurifier];
    NSString *UUID1 = [acc.uniqueIdentifier UUIDString];
    NSString *UUID2 = [pDevice.uniqueIdentifier UUIDString];
    
    if(![UUID1 isEqualToString:UUID2]){
        return;
    }
    
    
    if(!pDevice.reachable){
        
        [self exitController];
    }
}

- (void)exitController
{
    
    
    [self showDropdownViewWithMessage:@"设备正在重启！"];
    
    [_manager.isUpgrading setObject:@(NO) forKey:_serial];
    NSLog(@"exitController _manager.isUpgrading setObject:@(NO) forKey:_serial");
    
    if(_HUD){
        [_HUD dismiss];
    }
    
    if(!_timerInterrupt){
        [_timerInterrupt invalidate];
        _timerInterrupt = nil;
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)refresh
{
    [_manager getHomesNotify];
    _rereading = NO;
    _delayMark = YES;
    NSLog(@"refresh method ....");
}

- (void)clearProgress
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _lblOTAWIFIProgress.text = @"";
            _lblOTAWIFIProgress.tag = 0;
        });
        
    });
}

#pragma mark - AccessoriesManager Delegate
- (void)accessoryDidUpdateStatus:(HMAccessory *_Nullable)pAccessory
{
    [self checkDeviceStatursWithDevice:pAccessory];
}

- (void)accessoryManagerUpdateDevices:(NSMutableArray *_Nullable)pDevices
{
    
    //interupt handle
    if(!_timerInterrupt){
        [_timerInterrupt invalidate];
        _timerInterrupt = nil;
    }
    if(!_rereading){
        _timerInterrupt = [NSTimer scheduledTimerWithTimeInterval:120
                                                           target:self
                                                         selector:@selector(refresh)
                                                         userInfo:nil
                                                          repeats:YES];
        _rereading = YES;
        
        NSLog(@"_timerInterrupt ....");
    }
    
    
    
    NSMutableDictionary *mdAccessory = nil;
    NSString *tmpSerial = nil;
    for(NSMutableDictionary *accessory in pDevices){
        
        HMAccessory *acc = [self.device objectForKey:kPurifier];
        NSString *UUID = [acc.uniqueIdentifier UUIDString];
        
        HMAccessory *accInArray = [accessory objectForKey:kPurifier];
        NSString *UUIDInArray = [accInArray.uniqueIdentifier UUIDString];
        
        tmpSerial = [((HMCharacteristic *)[self.device objectForKey:kPurifierSerialNumber]).value ml_stringValue];
        
        if([UUID isEqualToString:UUIDInArray]){
            mdAccessory = accessory;
            break;
        }
    }
    
    if(!_serial){
        _serial = [((HMCharacteristic *)[self.device objectForKey:kPurifierSerialNumber]).value ml_stringValue];
    }
    
    if(mdAccessory && tmpSerial && [tmpSerial isEqualToString:_serial]){
        //control
        _mdCharactestiric = mdAccessory;
        
        
        _lblSerial.text = [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieSerial]).value ml_stringValue];
        _lblManufacturer.text = [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieManufacturer]).value ml_stringValue];
        _lblModel.text = [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieModel]).value ml_stringValue];
        _lblFirmware.text = [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieFirmware]).value ml_stringValue];
        
        
        
        //ota
        //    0  : Update completed
        //    1  : Firmware is latest version
        //    2  : Download firmware fail
        //    3  : Verify firmware fail
        //    4  : Upgrade firmware fail
        //     kPurifieUpgradeTypeIndication
        
        
        
        int typeIndication = [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieUpgradeTypeIndication]).value ml_intValue];
        NSLog(@"typeIndication： %d......................................", typeIndication);
        
        int progressResult = [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieUpgradeResult]).value ml_intValue];
        [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieUpgradeResult]) readValueWithCompletionHandler:^(NSError * _Nullable error) {}];
        NSLog(@"progressResult： %d......................................", progressResult);
        
        int progress = [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieUpgradeProgress]).value ml_intValue];
        [((HMCharacteristic *)[mdAccessory objectForKey:kPurifieUpgradeProgress]) readValueWithCompletionHandler:^(NSError * _Nullable error) {}];
        if(progress != 0 && progress != 100){
             [_manager.isUpgrading setObject:@(YES) forKey:_serial];
        }
        
        _currentDeviceProgress = progress;
        NSLog(@"progress： %d......................................", progress);
        
        //for setting time out
        if([_manager.isUpgrading[_serial] ml_boolValue] == YES){
            NSString *serial = [((HMCharacteristic *)[self.device objectForKey:kPurifierSerialNumber]).value ml_stringValue];
            if(progress == 0 && ![_manager.mdTimeOutContainer objectForKey:serial] && progressResult == 0){
                [_manager.mdTimeOutContainer setObject:[[HomeKit_DateManager sharedInstance] dateTimeToString:[NSDate date]] forKey:serial];
            }
            if(progress == 0 && [_manager.mdTimeOutContainer objectForKey:serial] && progressResult == 0){
                NSString *strDate = [((HMCharacteristic *)[_manager.mdTimeOutContainer objectForKey:serial]) ml_stringValue];
                NSDate *startDate = [[HomeKit_DateManager sharedInstance] stringToDateTime:strDate];
                
                NSInteger second = [[NSDate date] timeIntervalSinceDate:startDate];
                NSLog(@"time out is : %ld", second);
                
                if(second >= kDelay){
                    _delayMark = YES;
                }
                
                if(second >= kTimeout){
                    [self showDropdownViewWithMessage:@"更新超时，请重试！"];
                    [_manager.isUpgrading setObject:@(NO) forKey:_serial];
                    NSLog(@"second >= kTimeout _manager.isUpgrading setObject:@(NO) forKey:_serial");
                    [self stopAIV];
                    [self clearProgress];
                    [_manager.mdTimeOutContainer removeObjectForKey:serial];
                }
                
            }
        }
        
        
        
        //handle upgrading process
        if(_serial == nil){
            _serial = [((HMCharacteristic *)[self.device objectForKey:kPurifierSerialNumber]).value ml_stringValue];
        }
        
        if(progress != 0){
            [self stopAIV];
            HMCharacteristic *cha = [_mdCharactestiric objectForKey:kPurifieUpgradeProgress];
            [cha enableNotification:YES completionHandler:^(NSError * _Nullable error) {}];
            
            if(![self checkIfHaveCurrentKey]){
                [_manager.isUpgrading setObject:@(YES) forKey:_serial];
            }
            
            [_manager.upgradeWIFI setObject:@(YES) forKey:_serial];
            
            [self updateUIForUpgradeWithProgress:progress];
        }
        
        
        if(progress >= 98 && progressResult == 0 && [_manager.isUpgrading[_serial] ml_boolValue] == YES){
            NSLog(@"progress >= 98 && progressResult == 0..............");
            if(!_protectForLess100){
                [self performSelector:@selector(upgradeComplate) withObject:nil afterDelay:20];
                _protectForLess100 = YES;
                _protectFromProgress100 = NO;
            }
            
            //remove the timeout
            NSString *serial = [((HMCharacteristic *)[self.device objectForKey:kPurifierSerialNumber]).value ml_stringValue];
            if([_manager.mdTimeOutContainer objectForKey:serial]){
                [_manager.mdTimeOutContainer removeObjectForKey:serial];
            }
            
        }
        
        if(progress == 100 && progressResult == 0 && [_manager.isUpgrading[_serial] ml_boolValue] == YES){
            NSLog(@"progress == 100 && progressResult == 0 ..............");
            _protectForLess100 = NO;
            _protectFromProgress100 = YES;
            [self upgradeComplate];
            
            //remove the timeout
            NSString *serial = [((HMCharacteristic *)[self.device objectForKey:kPurifierSerialNumber]).value ml_stringValue];
            if([_manager.mdTimeOutContainer objectForKey:serial]){
                [_manager.mdTimeOutContainer removeObjectForKey:serial];
            }
        }
        
        
        if(progressResult == 2 && [_manager.isUpgrading[_serial] ml_boolValue] && _delayMark){
            [self showDropdownViewWithMessage:@"Download firmware fail"];
            [_manager.isUpgrading setObject:@(NO) forKey:_serial];
            NSLog(@"progressResult == 2 _manager.isUpgrading setObject:@(NO) forKey:_serial");
            [self clearProgress];
            [self stopAIV];
            
            //remove the timeout
            NSString *serial = [((HMCharacteristic *)[self.device objectForKey:kPurifierSerialNumber]).value ml_stringValue];
            if([_manager.mdTimeOutContainer objectForKey:serial]){
                [_manager.mdTimeOutContainer removeObjectForKey:serial];
            }
        }
        if(progressResult == 3 && [_manager.isUpgrading[_serial] ml_boolValue] && _delayMark){
            [self showDropdownViewWithMessage:@"Verify firmware fail"];
            [_manager.isUpgrading setObject:@(NO) forKey:_serial];
            NSLog(@"progressResult == 3 _manager.isUpgrading setObject:@(NO) forKey:_serial");
            _protectDidFinished = YES;
            [self stopAIV];
            [self clearProgress];
            //remove the timeout
            NSString *serial = [((HMCharacteristic *)[self.device objectForKey:kPurifierSerialNumber]).value ml_stringValue];
            if([_manager.mdTimeOutContainer objectForKey:serial]){
                [_manager.mdTimeOutContainer removeObjectForKey:serial];
            }
        }
        if(progressResult == 4 && [_manager.isUpgrading[_serial] ml_boolValue] && _delayMark){
            
            [self showDropdownViewWithMessage:@"Upgrade firmware fail"];
            [_manager.isUpgrading setObject:@(NO) forKey:_serial];
            NSLog(@"progressResult == 4 _manager.isUpgrading setObject:@(NO) forKey:_serial");
            _protectDidFinished = YES;
            [self stopAIV];
            [self clearProgress];
            //remove the timeout
            NSString *serial = [((HMCharacteristic *)[self.device objectForKey:kPurifierSerialNumber]).value ml_stringValue];
            if([_manager.mdTimeOutContainer objectForKey:serial]){
                [_manager.mdTimeOutContainer removeObjectForKey:serial];
            }
        }
        
        //_delayMark 判断最新版本，需要延迟10s，再去判断；
        if(progressResult == 1 && [_manager.isUpgrading[_serial] ml_boolValue] && _delayMark){
            [self showDropdownViewWithMessage:@"Firmware is latest version"];
            [_manager.isUpgrading setObject:@(NO) forKey:_serial];
            NSLog(@"progressResult == 1 _manager.isUpgrading setObject:@(NO) forKey:_serial");
            
            [self stopAIV];
            [self clearProgress];
            //remove the timeout
            NSString *serial = [((HMCharacteristic *)[self.device objectForKey:kPurifierSerialNumber]).value ml_stringValue];
            if([_manager.mdTimeOutContainer objectForKey:serial]){
                [_manager.mdTimeOutContainer removeObjectForKey:serial];
            }
        }
        
        

        
    }
    
    
}

- (void)updateUIForUpgradeWithProgress:(NSInteger)pProgress
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{

            if([self checkIfHaveCurrentKey]){
                if(pProgress > _lblOTAWIFIProgress.tag){
                    _lblOTAWIFIProgress.text =  [NSString stringWithFormat:@"%ld%@", pProgress, @"%"];
                    _lblOTAWIFIProgress.tag = pProgress;
                }
                
                
            }
            
            if(pProgress == 100){
                [[HomeKit_AccessoryManager sharedInstance].isUpgrading setObject:@(NO) forKey:_serial];
                NSLog(@"updateUIForUpgradeWithProgress _manager.isUpgrading setObject:@(NO) forKey:_serial");
                _lblOTAWIFIProgress.tag = 0;
                
            }
            
        });
        
    });
}

- (void)changeMark
{
    timeCount++;
    if(timeCount >= 2){
        [[HomeKit_AccessoryManager sharedInstance].isUpgrading setObject:@(NO) forKey:_serial];
        timeCount = 0;
    }
}

- (BOOL)checkIfHaveCurrentKey
{
    
    if(_manager.isUpgrading.allKeys.count == 0){
        return NO;
    }
    
    __block BOOL result = NO;
    [_manager.isUpgrading.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = obj;
        
        if([_serial isEqualToString:key]){
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

- (void)stopAIV
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_aivWIFI.isAnimating){[_aivWIFI stopAnimating]; _aivWIFI.hidden = YES;}
            if(_aivMCU.isAnimating){[_aivMCU stopAnimating]; _aivMCU.hidden = YES;}
        });
        
    });
    
    
}

#pragma mark - protect

- (void)upgradeComplate
{
    if(!_protectForLess100 && !_protectFromProgress100){
        return;
    }
    
    if(_protectDidFinished){
        return;
    }
    
    _protectDidFinished = YES;
    
    
    [self updateUIForUpgradeWithProgress:100];
    [self showDropdownViewWithMessage:@"更新完成！"];
    [self stopAIV];
    
    [_manager.isUpgrading setObject:@(NO) forKey:_serial];
    NSLog(@"upgradeComplate _manager.isUpgrading setObject:@(NO) forKey:_serial");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(!_HUD){
                _HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
                _HUD.textLabel.text = @"等待设备重启";
                [_HUD showInView:self.navigationController.view];
            }
            
            
            
        });
        
    });
    
    [self readChaValue];
    
    
    [self performSelector:@selector(exitController) withObject:nil afterDelay:30];
}

- (void)readChaValue
{
    HMAccessory *acc = [self.device objectForKey:kPurifier];
    NSArray *arrService = acc.services;
    for(HMService *service in arrService){
        
        NSArray *arrCharac = service.characteristics;
        
        for(HMCharacteristic *charac in arrCharac){
            [charac readValueWithCompletionHandler:^(NSError * _Nullable error) {}];
        }
    }
}

@end
