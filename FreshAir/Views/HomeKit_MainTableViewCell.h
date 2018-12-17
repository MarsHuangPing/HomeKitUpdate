//
//  MainTableViewCell.h
//  FreshAir
//
//  Created by mars on 23/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeKit_MainViewController.h"

@class XLinkDevice, RefreshIndicatorView;

@protocol HomeKit_MainTableViewCellDelegate <NSObject>
@optional
- (void)loginWithDeviceSerial:(NSString *)pSerial;

@end

@interface HomeKit_MainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewCellPanel;
@property (weak, nonatomic) IBOutlet UIView *viewRowMark;
@property (weak, nonatomic) IBOutlet UIView *viewCellContanetPanel;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *lblWindQuantityTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblWindQuantityValue;
@property (weak, nonatomic) IBOutlet UILabel *lblPMValue;
@property (weak, nonatomic) IBOutlet UILabel *lblPMUnit;
@property (weak, nonatomic) IBOutlet UIView *viewSplit;
@property (weak, nonatomic) IBOutlet UILabel *lblEnviromentIndex;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperatureValue;
@property (weak, nonatomic) IBOutlet UILabel *lblHumidityValue;
@property (weak, nonatomic) IBOutlet UILabel *lblCo2Value;
@property (weak, nonatomic) IBOutlet UIImageView *ivHotIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblHot;
@property (weak, nonatomic) IBOutlet UILabel *lblOfflineAlert;

@property (nonatomic, weak) IBOutlet RefreshIndicatorView *aiCicle;
@property (nonatomic, weak) IBOutlet UIButton *btnCloud;

@property (strong, nonatomic) HomeKit_MainViewController *vcMain;
@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, strong) NSString *mac;
//@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, assign) BOOL reachable;
@property (nonatomic, strong) XLinkDevice *XLinkDevice;
@property (assign, nonatomic) float pm25Value;
@property (nonatomic, strong) NSMutableDictionary *mdDevice;
@property (nonatomic, assign) BOOL fromHomeKit;
@property (nonatomic, assign) BOOL owner;
@property (nonatomic, assign) BOOL deviceIsOnLine;

@property (nonatomic, assign) id<HomeKit_MainTableViewCellDelegate>  mainTableViewCellDelegate;


- (void)hiddenCloudWithOwner:(BOOL)pOwner;


- (void)updateDeviceWithNetworkStatus:(AFNetworkReachabilityStatus)pNetworkStatus
                            reachable:(BOOL)pReachable
                               serial:(NSString *)pSerial
                        homeKitDevice:(NSMutableDictionary *)pHomeKitDevice;
@end
