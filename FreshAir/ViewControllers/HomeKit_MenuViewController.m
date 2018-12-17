//
//  MenuViewController.m
//  FreshAir
//
//  Created by mars on 09/12/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_MenuViewController.h"
#import "HomeKit_AccessoryManager.h"
#import "YRDropdownView.h"
#import "HomeKit_CommonAPI.h"





@interface HomeKit_MenuViewController()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UITableView *_tvMenu;
    __weak IBOutlet UIButton *_btnAdd;
    
    __weak IBOutlet UIView *_viewControlPanel;
    __weak IBOutlet UITextField *_tfInput;
    __weak IBOutlet UITextField *_tfHidden;
    
    NSArray *_arrHomes;
    EditType _editType;
    NSInteger _currentIndex;
}

@end

@implementation HomeKit_MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tvMenu.delegate = self;
    _tvMenu.dataSource = self;
    _tvMenu.opaque = NO;
    _tvMenu.backgroundColor = [UIColor clearColor];
    
    _btnAdd.layer.cornerRadius = 17.5;
    _btnAdd.layer.borderColor = [UIColor whiteColor].CGColor;
    _btnAdd.layer.borderWidth = 1.0;
    _tfHidden.tag = 1000;
    _tfHidden.delegate = self;
    _tfHidden.inputAccessoryView = _viewControlPanel;
    _tfInput.tag = 1;
    _tfInput.delegate = self;
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    
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
    [_tfHidden becomeFirstResponder];
    _editType = EditTypeNew;
}

- (IBAction)actionForEndEdit:(id)sender {
    [self endEditHome];
}

- (IBAction)actionForCreation:(id)sender {

    [self endEditHome];
    if(_editType == EditTypeNew){
        [[HomeKit_AccessoryManager sharedInstance] addHomeWithName:_tfInput.text completionHandler:^(NSError * _Nullable error) {
            _arrHomes = [HomeKit_AccessoryManager sharedInstance].homeManager.homes;
            [_tvMenu reloadData];
            _tfInput.text = @"";
        }];
    }
    else{
        [((HMHome *)_arrHomes[_currentIndex]) updateName:_tfInput.text completionHandler:^(NSError * _Nullable error) {
            if(error){
                [self showDropdownViewWithMessage:@"重命名错误"];
            }
            else{
                _arrHomes = [HomeKit_AccessoryManager sharedInstance].homeManager.homes;
                [_tvMenu reloadData];
                _tfInput.text = @"";
            }
        }];
    }
    
}

- (void)loadData
{
    _arrHomes = [HomeKit_AccessoryManager sharedInstance].homeManager.homes;
    [_tvMenu reloadData];
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
        self.sideMenuViewController.panGestureEnabled = NO;
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

    [HomeKit_AccessoryManager sharedInstance].currentHome = _arrHomes[indexPath.row];
    
     UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[HomeKit_CommonAPI sharedInstance] getViewControllerName:@"MainViewController"]];
    [self.sideMenuViewController setContentViewController:navigationController
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return _arrHomes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    cell.contentView.tag = indexPath.row;
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleForLongPress:)];
    [cell.contentView addGestureRecognizer:gr];
    
    cell.textLabel.text = ((HMHome *)_arrHomes[indexPath.row]).name;
    
    return cell;
}

- (void)handleForLongPress:(UIGestureRecognizer *)pGesture
{
    if (pGesture.state == UIGestureRecognizerStateBegan) {
        _editType = EditTypeRename;
        UIView *view = pGesture.view;
        NSInteger index = view.tag;
        NSLog(@"%ld......", index);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                 message:[NSString stringWithFormat:@"编辑%@",((HMHome *)_arrHomes[index]).name] preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[HomeKit_AccessoryManager sharedInstance].homeManager removeHome:_arrHomes[index] completionHandler:^(NSError * _Nullable error) {
                if(error == nil){
                    _arrHomes = [HomeKit_AccessoryManager sharedInstance].homeManager.homes;
                    [_tvMenu reloadData];
                    [[HomeKit_AccessoryManager sharedInstance] getHomesNotify];
                }
                else{
                    [self showDropdownViewWithMessage:@"删除错误"];
                }
            }];
        }];
        UIAlertAction *renameAction = [UIAlertAction actionWithTitle:@"重命名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _tfInput.text = ((HMHome *)_arrHomes[index]).name;
            [_tfHidden becomeFirstResponder];
            _currentIndex = index;
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:deleteAction];
        
        HMHome *home = _arrHomes[index];
        HMUser *user = home.currentUser;
        HMHomeAccessControl *accessControl = [home homeAccessControlForUser:user];
        
        if(accessControl.administrator){
            [alertController addAction:renameAction];
        }
        
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

@end
