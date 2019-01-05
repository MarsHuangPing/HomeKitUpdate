//
//  RoomSettingViewController.m
//  FreshAir
//
//  Created by mars on 10/12/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_RoomSettingViewController.h"
#import "HomeKit_DeviceListViewController.h"
#import "HomeKit_SelectedViewController.h"

#import "YRDropdownView.h"
#import "HomeKit_AccessoryManager.h"
#import "HomeKit_CommonAPI.h"




@interface HomeKit_RoomSettingViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SelectedViewControllerDelegate>
{
    __weak IBOutlet UITableView *_tvRooms;
    __weak IBOutlet UIView *_viewControlPanel;
    __weak IBOutlet UITextField *_tfInput;
    __weak IBOutlet UITextField *_tfHidden;
    
    NSMutableArray *_maRooms;
    EditType _editType;
    NSInteger _currentIndex;
    HomeKit_AccessoryManager *_manager;
}
@end

@implementation HomeKit_RoomSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _manager = [HomeKit_AccessoryManager sharedInstance];
    if([HomeKit_AccessoryManager sharedInstance].currentHome){
        self.title = [HomeKit_AccessoryManager sharedInstance].currentHome.name;
        
        HMHome *home = [HomeKit_AccessoryManager sharedInstance].currentHome;
        
        _maRooms = [NSMutableArray arrayWithArray:home.rooms];
        
        if(self.enterType == EnterTypeSelect){
            if([self isFromDefaultRoomWithAccessory:self.currentAccessory]){
                [_maRooms insertObject:kDefaultRoomName atIndex:0];
            }
        }
        else if([self ifHaveAccessoryFromDefault]){
            [_maRooms insertObject:kDefaultRoomName atIndex:0];
        }
        
        [_tvRooms reloadData];
        
    }
    else{
        self.title = @"";
        return;
    }
    
    _tvRooms.delegate = self;
    _tvRooms.dataSource = self;
    _tvRooms.opaque = NO;
    _tvRooms.backgroundColor = [UIColor clearColor];
    
    
    _tfHidden.tag = 1000;
    _tfHidden.delegate = self;
    _tfHidden.inputAccessoryView = _viewControlPanel;
    _tfInput.tag = 1;
    _tfInput.delegate = self;
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([_manager checkCurrrentUserIsAdmin]){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新建"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(actionForAddHome:)];
    }
    
    if(self.enterType == EnterTypeAddNewDevice){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _tfInput.text = @"";
    [_tfInput resignFirstResponder];
    [_viewControlPanel endEditing:YES];
    [self.view endEditing:YES];
}



- (IBAction)actionForAddHome:(id)sender {
//    [_tfHidden becomeFirstResponder];
//    _editType = EditTypeNew;
    
    HomeKit_SelectedViewController *vcSelected = (HomeKit_SelectedViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"SelectedViewController"];
    vcSelected.delegate = self;
    NSMutableArray *maRoomNames = [NSMutableArray array];
    [_maRooms enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![obj isKindOfClass:[NSString class]]){
            HMRoom *room = obj;
            
            [maRoomNames addObject:room.name];
        }
        
    }];
    vcSelected.existNames = maRoomNames;
    vcSelected.editType = EditTypeNew;
    vcSelected.fromRoomManager = YES;
    [self.navigationController pushViewController:vcSelected animated:YES];
}

- (IBAction)actionForEndEdit:(id)sender {
    [self endEditHome];
}

- (IBAction)actionForCreation:(id)sender {
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject: _tfInput.text]){
        [self showDropdownViewWithMessage:@"请使用汉字、字母或数字命名"];
    }
    else{
        [self endEditHome];
        if(_editType == EditTypeNew){
            [[HomeKit_AccessoryManager sharedInstance].currentHome addRoomWithName:_tfInput.text completionHandler:^(HMRoom * _Nullable room, NSError * _Nullable error) {
                
                _maRooms = [NSMutableArray arrayWithArray:[HomeKit_AccessoryManager sharedInstance].currentHome.rooms];
                
                if(self.enterType == EnterTypeSelect){
                    if([self isFromDefaultRoomWithAccessory:self.currentAccessory]){
                        [_maRooms insertObject:kDefaultRoomName atIndex:0];
                    }
                }
                [_tvRooms reloadData];
                _tfInput.text = @"";
            } ];
        }
        else{
            [((HMRoom *)_maRooms[_currentIndex]) updateName:_tfInput.text completionHandler:^(NSError * _Nullable error) {
                
                if(error){
                    [self showDropdownViewWithMessage:@"重命名错误"];
                }
                else{
                    _maRooms = [NSMutableArray arrayWithArray:[HomeKit_AccessoryManager sharedInstance].currentHome.rooms];
                    if(self.enterType == EnterTypeSelect){
                        if([self isFromDefaultRoomWithAccessory:self.currentAccessory]){
                            [_maRooms insertObject:kDefaultRoomName atIndex:0];
                        }
                    }
                    [_tvRooms reloadData];
                    _tfInput.text = @"";
                }
            }];
        }
        
    }
    
}
//for select
- (BOOL)isFromDefaultRoomWithAccessory:(HMAccessory *)pAccessory
{
    __block BOOL isDefaultRoomDevice = YES;
    [[HomeKit_AccessoryManager sharedInstance].currentHome.rooms enumerateObjectsUsingBlock:^(HMRoom * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.name isEqualToString:pAccessory.room.name]){
            isDefaultRoomDevice = NO;
            *stop = YES;
        }
    }];
    return isDefaultRoomDevice;
}
//for manager
- (BOOL)ifHaveAccessoryFromDefault
{
    MLWeakSelf weakSelf = self;
    
    __block BOOL haveDeviceFromDefaultRoom = NO;
    [[HomeKit_AccessoryManager sharedInstance].currentHome.accessories enumerateObjectsUsingBlock:^(HMAccessory * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([weakSelf isFromDefaultRoomWithAccessory:obj]){
            haveDeviceFromDefaultRoom = YES;
            *stop = YES;
        }
    }];
    return haveDeviceFromDefaultRoom;
}

- (void)endEditHome
{
    [_tfInput resignFirstResponder];
    [_viewControlPanel endEditing:YES];
    [self.view endEditing:YES];
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
    //    _descLabel.text = @"失去焦点";
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    if(self.enterType == EnterTypeManager){
        HomeKit_DeviceListViewController *vcDeviceList = (HomeKit_DeviceListViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"DeviceListViewController"];
        
        if([_maRooms[indexPath.row] isKindOfClass:[NSString class]]){
            vcDeviceList.room = nil;
        }
        else{
            vcDeviceList.room = _maRooms[indexPath.row];
        }
        

//        [self.navigationController pushViewController:vcDeviceList animated:YES];
    }
    else if(self.enterType == EnterTypeSelect){
        
        if(![_manager checkCurrrentUserIsAdmin]){
            return;
        }
        
        if([_maRooms[indexPath.row] isKindOfClass:[NSString class]]){
            return;
        }
        HMRoom *room = ((HMRoom *)_maRooms[indexPath.row]);
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(selectedRoom:)]) {
            [self.delegate selectedRoom:room];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        HMRoom *room;
//        id r = _maRooms[indexPath.row];
        if([_maRooms[indexPath.row] isKindOfClass:[HMRoom class]]){
            room = ((HMRoom *)_maRooms[indexPath.row]);
        }
        
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(selectedRoom:)]) {
            [self.delegate selectedRoom:room];
        }
        
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

#pragma mark -
#pragma mark selectedRoom Delegate
- (void)setName:(NSString *_Nullable)pName editType:(EditType)pEditType  index:(NSInteger)pIndex
{
    if(pEditType == EditTypeNew){
        [[HomeKit_AccessoryManager sharedInstance].currentHome addRoomWithName:pName completionHandler:^(HMRoom * _Nullable room, NSError * _Nullable error) {
            
            _maRooms = [NSMutableArray arrayWithArray:[HomeKit_AccessoryManager sharedInstance].currentHome.rooms];
            
            //chack is have default room from main
            if(self.enterType == EnterTypeManager){
                __block BOOL haveFromDefault = NO;
                [self.maDevices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([self isFromDefaultRoomWithAccessory:obj]){
                        haveFromDefault = YES;
                        *stop = YES;
                    }
                }];
                if(haveFromDefault){
                     [_maRooms insertObject:kDefaultRoomName atIndex:0];
                }
            }
            else //from select
            if([self isFromDefaultRoomWithAccessory:self.currentAccessory]){
                [_maRooms insertObject:kDefaultRoomName atIndex:0];
            }
            
            [_tvRooms reloadData];
            _tfInput.text = @"";
        } ];
    }
    else{
        [((HMRoom *)_maRooms[pIndex]) updateName:pName completionHandler:^(NSError * _Nullable error) {
            
            if(error){
                [self showDropdownViewWithMessage:@"重命名错误"];
            }
            else{
                
                __block BOOL haveDefaultRoom = NO;
                [_maRooms enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj isKindOfClass:[NSString class]]){
                        haveDefaultRoom = YES;
                        *stop = YES;
                    }
                }];
                
                _maRooms = [NSMutableArray arrayWithArray:[HomeKit_AccessoryManager sharedInstance].currentHome.rooms];
                
                if(haveDefaultRoom){
                    [_maRooms insertObject:kDefaultRoomName atIndex:0];
                }
                
                [_tvRooms reloadData];
                _tfInput.text = @"";
            }
        }];
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return _maRooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];

        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    cell.contentView.tag = indexPath.row;
    
    if(self.enterType == EnterTypeSelect){
        if([self isFromDefaultRoomWithAccessory:self.currentAccessory]){
            if(indexPath.row == 0){
                cell.textLabel.text = _maRooms[indexPath.row];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else{
                HMRoom *room = ((HMRoom *)_maRooms[indexPath.row]);
                cell.textLabel.text = room.name;

                cell.contentView.tag = indexPath.row;
                UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleForLongPress:)];
                [cell.contentView addGestureRecognizer:gr];

                if([[room.uniqueIdentifier UUIDString] isEqualToString:[self.currentRoom.uniqueIdentifier UUIDString]]){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
        }
        else{
            HMRoom *room = ((HMRoom *)_maRooms[indexPath.row]);
            cell.textLabel.text = room.name;
            
            cell.contentView.tag = indexPath.row;
            UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleForLongPress:)];
            [cell.contentView addGestureRecognizer:gr];
            
            if([[room.uniqueIdentifier UUIDString] isEqualToString:[self.currentRoom.uniqueIdentifier UUIDString]]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    else{
        if([self ifHaveAccessoryFromDefault]){
            if(indexPath.row == 0){
                cell.textLabel.text = _maRooms[indexPath.row];
            }
            else{
                HMRoom *room = ((HMRoom *)_maRooms[indexPath.row]);
                cell.textLabel.text = room.name;
                
                cell.contentView.tag = indexPath.row;
                UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleForLongPress:)];
                [cell.contentView addGestureRecognizer:gr];
                
                if([[room.uniqueIdentifier UUIDString] isEqualToString:[self.currentRoom.uniqueIdentifier UUIDString]]){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
        }
        else{
            HMRoom *room = ((HMRoom *)_maRooms[indexPath.row]);
            cell.textLabel.text = room.name;
            
            cell.contentView.tag = indexPath.row;
            UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleForLongPress:)];
            [cell.contentView addGestureRecognizer:gr];
            
            if([[room.uniqueIdentifier UUIDString] isEqualToString:[self.currentRoom.uniqueIdentifier UUIDString]]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        
    }
    
    
    
    return cell;
}

- (void)handleForLongPress:(UIGestureRecognizer *)pGesture
{
    if(![_manager checkCurrrentUserIsAdmin]){
        return;
    }
        if (pGesture.state == UIGestureRecognizerStateBegan) {
            _editType = EditTypeRename;
            UIView *view = pGesture.view;
            NSInteger index = view.tag;
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                     message:[NSString stringWithFormat:@"编辑%@",((HMHome *)_maRooms[index]).name] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[HomeKit_AccessoryManager sharedInstance].currentHome removeRoom:_maRooms[index] completionHandler:^(NSError * _Nullable error) {
                    if(error == nil){
                        _maRooms = [NSMutableArray arrayWithArray:[HomeKit_AccessoryManager sharedInstance].currentHome.rooms];

                        //chack is have default room from main
                        if(self.enterType == EnterTypeManager){
                            __block BOOL haveFromDefault = NO;
                            [self.maDevices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if([self isFromDefaultRoomWithAccessory:obj]){
                                    haveFromDefault = YES;
                                    *stop = YES;
                                }
                            }];
                            if(haveFromDefault){
                                [_maRooms insertObject:kDefaultRoomName atIndex:0];
                            }
                        }
                        else //from select
                        if([self isFromDefaultRoomWithAccessory:self.currentAccessory]){
                            [_maRooms insertObject:kDefaultRoomName atIndex:0];
                        }
                        
                        [_tvRooms reloadData];
                        [[HomeKit_AccessoryManager sharedInstance] getHomesNotify];
                    }
                    else{
                        [self showDropdownViewWithMessage:@"删除错误"];
                    }
                }];
            }];
            UIAlertAction *renameAction = [UIAlertAction actionWithTitle:@"重命名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                HomeKit_SelectedViewController *vcSelected = (HomeKit_SelectedViewController *)[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"SelectedViewController"];
                vcSelected.delegate = self;
                NSMutableArray *maRoomNames = [NSMutableArray array];
                [_maRooms enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(![obj isKindOfClass:[NSString class]]){
                        HMRoom *room = obj;
                        [maRoomNames addObject:room.name];
                    }
                    
                }];
                vcSelected.fromRoomManager = YES;
                vcSelected.existNames = maRoomNames;
                vcSelected.editType = EditTypeRename;
                vcSelected.currentName = ((HMRoom *)_maRooms[index]).name;
                vcSelected.index = index;
                [self.navigationController pushViewController:vcSelected animated:YES];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:deleteAction];
            [alertController addAction:renameAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    
}

@end
