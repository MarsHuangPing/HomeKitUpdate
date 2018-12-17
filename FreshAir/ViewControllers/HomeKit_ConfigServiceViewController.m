//
//  ConfigServiceViewController.m
//  FreshAir
//
//  Created by mars on 07/03/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#define kAirPurifier @"000000BB-0000-1000-8000-0026BB765291"
#define kAirQualitySensor @"0000008D-0000-1000-8000-0026BB765291"
#define kCarbonSensor @"00000097-0000-1000-8000-0026BB765291"
#define kTemperatureSensor @"0000008A-0000-1000-8000-0026BB765291"
#define kHumiditySensor @"00000082-0000-1000-8000-0026BB765291"

#import "HomeKit_ConfigServiceViewController.h"
#import "YRDropdownView.h"
#import "HomeKit_DeviceService.h"
#import "HomeKit_ColorManager.h"

#import "HomeKit_CommonAPI.h"

@interface HomeKit_ConfigServiceViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITableView *_tv;
    __weak IBOutlet UIView *_viewControlPanel;
    
    __weak IBOutlet UIView *_viewServiceBox;
    __weak IBOutlet UILabel *_lblRoomName;
    __weak IBOutlet UILabel *_lblServiceName;
    __weak IBOutlet UIButton *_btnIdentify;
    
    
    __weak IBOutlet UITextField *_tfServiceName;
    
    
    __weak IBOutlet HomeKit_SplitLineBase *_ViewSplitHumiditySensor;
    
    __weak IBOutlet HomeKit_SplitLineBase *_ViewSplitSection;
    
    
//    HMService *_serviceAirPurifier;
//    HMService *_serviceAirQualitySensor;
//    HMService *_serviceCarbonSensor;
//    HMService *_serviceTemperatureSensor;
//    HMService *_serviceHumiditySensor;
}
@end

@implementation HomeKit_ConfigServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"......%ld", [DeviceService sharedInstance].services.count);
    _viewServiceBox.layer.cornerRadius = 8;
    _viewServiceBox.clipsToBounds = YES;
    _btnIdentify.layer.cornerRadius = 15;
    _btnIdentify.clipsToBounds = YES;
    [_btnIdentify setBackgroundColor:[[HomeKit_ColorManager sharedInstance] colorBlueButtonBackground]];
    
    
    _viewControlPanel.backgroundColor = [[HomeKit_ColorManager sharedInstance] mainBgLightGray];
    
    [self.accessory identifyWithCompletionHandler:^(NSError * _Nullable error) {}];
    
    NSString *nextButtonTitle = nil;
    if(self.selected == [HomeKit_DeviceService sharedInstance].services.count - 1){
        nextButtonTitle = @"完成";
    }
    else{
        nextButtonTitle = @"下一步";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nextButtonTitle
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(actionForSave)];
    
    UINavigationItem *navigationItem = self.navigationItem;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(actionForBack)];
    [navigationItem setBackBarButtonItem:item];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setCurrentValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)setCurrentValue
{
    self.title = [NSString stringWithFormat:@"%ld/%ld", self.selected + 1, [HomeKit_DeviceService sharedInstance].services.count];
    
    HMService *service = [[HomeKit_DeviceService sharedInstance].services objectAtIndex:self.selected];
    _lblServiceName.text = service.name;
    
    _tfServiceName.text = service.name;
    _tfServiceName.placeholder = service.name;
    
    NSInteger indexRoom = [HomeKit_DeviceService sharedInstance].indexRoom;
    if([[[HomeKit_DeviceService sharedInstance].rooms objectAtIndex:indexRoom] isKindOfClass:[NSString class]]){
        _lblRoomName.text =  [[HomeKit_DeviceService sharedInstance].rooms objectAtIndex:indexRoom];
    }
    else{
        HMRoom *room = [[HomeKit_DeviceService sharedInstance].rooms objectAtIndex:indexRoom];
        _lblRoomName.text = room.name;
    }
    
    
}

#pragma mark - actions

- (IBAction)actionForIdentifying:(id)sender {
    [self.accessory identifyWithCompletionHandler:^(NSError * _Nullable error) {}];
}

- (void)actionForBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionForSave
{
    if(_tfServiceName.text.length ==0){
        [self showDropdownViewWithMessage:@"服务重命名错误"];
        return;
    }
    
    HMService *service = [[HomeKit_DeviceService sharedInstance].services objectAtIndex:self.selected];
    [service updateName:_tfServiceName.text completionHandler:^(NSError * _Nullable error) {
        if(error){
            [self showDropdownViewWithMessage:@"服务重命名错误，请重试！"];
        }
        else{
            if(self.selected == [HomeKit_DeviceService sharedInstance].services.count - 1){
                [self dismissViewControllerAnimated:YES completion:^{
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                }];

            }
            else{
                HomeKit_ConfigServiceViewController *vcConfigService = (HomeKit_ConfigServiceViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"ConfigServiceViewController"];
                vcConfigService.accessory = self.accessory;
                vcConfigService.selected = self.selected + 1;
                [self.navigationController pushViewController:vcConfigService animated:YES];
            }
            
        }
    }];

    
}

#pragma mark -
#pragma mark UITableView Datasource
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 39;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [HomeKit_DeviceService sharedInstance].rooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    if([HomeKit_DeviceService sharedInstance].indexRoom == indexPath.row){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if([[[HomeKit_DeviceService sharedInstance].rooms objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
        cell.textLabel.text = [HomeKit_DeviceService sharedInstance].rooms[indexPath.row];
    }
    else{
        HMRoom *room = ((HMRoom *)[HomeKit_DeviceService sharedInstance].rooms[indexPath.row]);
        cell.textLabel.text = room.name;
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
    
    [HomeKit_DeviceService sharedInstance].indexRoom = indexPath.row;
    
    if(([HomeKit_DeviceService sharedInstance].indexRoom == 0 && ![[[HomeKit_DeviceService sharedInstance].rooms objectAtIndex:0] isKindOfClass:[NSString class]]) ||
       [HomeKit_DeviceService sharedInstance].indexRoom != 0){
        HMRoom *room = [[HomeKit_DeviceService sharedInstance].rooms objectAtIndex:[HomeKit_DeviceService sharedInstance].indexRoom];
        [[HomeKit_AccessoryManager sharedInstance].currentHome assignAccessory:self.accessory toRoom:room completionHandler:^(NSError * _Nullable error) {
           
            if(error){
                [self showDropdownViewWithMessage:@"分配房间错误，请重试！"];
            }
            else{
                if([[[HomeKit_DeviceService sharedInstance].rooms objectAtIndex:0] isKindOfClass:[NSString class]]){
                    [[HomeKit_DeviceService sharedInstance].rooms removeObjectAtIndex:0];
                    [HomeKit_DeviceService sharedInstance].indexRoom = [HomeKit_DeviceService sharedInstance].indexRoom - 1;
                }
                [_tv reloadData];
                [self setCurrentValue];
            }
        }];
    }

}

- (void)showDropdownViewWithMessage:(NSString *)pMessage
{
    
    [YRDropdownView showDropdownInView:self.navigationController.view
                                 title:@"Warning"
                                detail:pMessage
                                 image:[UIImage imageNamed:@"dropdown-alert"]
                              animated:YES hideAfter:2];
}
@end
