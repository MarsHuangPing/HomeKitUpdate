//
//  ServiceSettingViewController.m
//  FreshAir
//
//  Created by mars on 16/12/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#define kAirPurifier @"000000BB-0000-1000-8000-0026BB765291"
#define kAirQualitySensor @"0000008D-0000-1000-8000-0026BB765291"
#define kCarbonSensor @"00000097-0000-1000-8000-0026BB765291"
#define kTemperatureSensor @"0000008A-0000-1000-8000-0026BB765291"
#define kHumiditySensor @"00000082-0000-1000-8000-0026BB765291"

#define kDefinedServiceByApple @[kAirPurifier, kAirQualitySensor, kCarbonSensor, kTemperatureSensor, kHumiditySensor]

#import "HomeKit_ServiceSettingViewController.h"
#import "HomeKit_SelectedViewController.h"
#import "YRDropdownView.h"

#import "HomeKit_CommonAPI.h"



@interface HomeKit_ServiceSettingViewController ()<AccessoryManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SelectedViewControllerDelegate>
{
    __weak IBOutlet UITableView *_tvService;
    __weak IBOutlet UIView *_viewControlPanel;
    __weak IBOutlet UITextField *_tfInput;
    __weak IBOutlet UITextField *_tfHidden;
    
    NSMutableArray *_maService;
    HomeKit_AccessoryManager *_manager;
    
    HMService *_selectedService;
}
@end

@implementation HomeKit_ServiceSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备服务";
    _tvService.delegate = self;
    _tvService.dataSource = self;
    
    _tfHidden.tag = 1000;
    _tfHidden.delegate = self;
    _tfHidden.inputAccessoryView = _viewControlPanel;
    _tfInput.tag = 1;
    _tfInput.delegate = self;
    
    _manager = [HomeKit_AccessoryManager sharedInstance];
    
    _maService = [NSMutableArray array];
    [self.accessory.services enumerateObjectsUsingBlock:^(HMService * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HMService *service = obj;
        if(service.isUserInteractive){
            [_maService addObject:service];
        }
    }];

    [_tvService reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [AccessoryManager sharedInstance].delegate = self;

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _tfInput.text = @"";
    [_tfInput resignFirstResponder];
    [_viewControlPanel endEditing:YES];
    [self.view endEditing:YES];
}


- (IBAction)actionForEndEdit:(id)sender {
    [self endEditHome];
}

- (IBAction)actionForCreation:(id)sender {
    if(_selectedService.isUserInteractive){
        [self showDropdownViewWithMessage:@"ok"];
    }
    else{
        [self showDropdownViewWithMessage:@"not ok"];
    }
//    _manager.homeManager
    [_selectedService updateName:_tfInput.text completionHandler:^(NSError * _Nullable error) {
        if(error){
            [self showDropdownViewWithMessage:[NSString stringWithFormat:@"%@",error]];
        }
        else{
            [self showDropdownViewWithMessage:@"ok"];
        }
    }];

}

- (void)endEditHome
{
    [_tfInput resignFirstResponder];
    [_viewControlPanel endEditing:YES];
    [self.view endEditing:YES];
    //    _tfHidden.inputAccessoryView = nil;
}

- (void)showDropdownViewWithMessage:(NSString *)pMessage
{
    
    [YRDropdownView showDropdownInView:self.view
                                 title:@"Warning"
                                detail:pMessage
                                 image:[UIImage imageNamed:@"dropdown-alert"]
                              animated:YES hideAfter:2];
}

// 获得焦点
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField.tag == 1000){
        [self performSelector:@selector(setFocusToInput) withObject:self afterDelay:1];
    }
    if(textField.tag == 1){
//        self.sideMenuViewController.panGestureEnabled = NO;
    }
    return YES;
}
- (void)setFocusToInput
{
    [_tfInput becomeFirstResponder];
}

// 失去焦点
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
    

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(![_manager checkCurrrentUserIsAdmin]){
        return;
    }
    
    HomeKit_SelectedViewController *vcSelected = (HomeKit_SelectedViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"SelectedViewController"];
    vcSelected.delegate = self;
    
    NSMutableArray *maServiceNames = [NSMutableArray array];
    [_maService enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![obj isKindOfClass:[NSString class]]){
            HMService *service = obj;
            [maServiceNames addObject:service.name];
        }
        
    }];
    
    vcSelected.fromRoomManager = NO;
    vcSelected.existNames = maServiceNames;
    vcSelected.editType = EditTypeRename;
    vcSelected.currentName = ((HMService *)_maService[indexPath.row]).name;
    vcSelected.index = indexPath.row;
    [self.navigationController pushViewController:vcSelected animated:YES];
}

#pragma mark selectedRoom Delegate
- (void)setName:(NSString *_Nullable)pName editType:(EditType)pEditType  index:(NSInteger)pIndex
{
    [((HMService *)_maService[pIndex]) updateName:pName completionHandler:^(NSError * _Nullable error) {
        if(error){
            [self showDropdownViewWithMessage:[NSString stringWithFormat:@"%@",error]];
        }
        else{
            _maService = [NSMutableArray array];
            [self.accessory.services enumerateObjectsUsingBlock:^(HMService * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HMService *service = obj;
                if(service.isUserInteractive){
                    [_maService addObject:service];
                }
            }];
            [_tvService reloadData];
        }
    }];
    
   
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return _maService.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];

        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }

    NSLog(@"name :%@, UUID:%@, localized:%@", ((HMService *)_maService[indexPath.row]).name, ((HMService *)_maService[indexPath.row]).serviceType, ((HMService *)_maService[indexPath.row]).localizedDescription);
    cell.textLabel.text = ((HMService *)_maService[indexPath.row]).name;
    cell.detailTextLabel.text = ((HMService *)_maService[indexPath.row]).localizedDescription;
    
    return cell;
}


@end
