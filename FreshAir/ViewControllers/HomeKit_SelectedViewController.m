//
//  SelectedViewController.m
//  FreshAir
//
//  Created by mars on 17/12/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#define kPredefinedRooms @[@"客厅", @"卧室", @"厨房", @"阳台", @"书房", @"车库", @"走廊"]
#define kPredefinedServices @[@"Air Purify", @"Air Quality", @"Carbon Sensor", @"Temperature Sensor", @"Humidity Sensor", @"HEPA Filter", @"ION DUST Filter", @"Carbon Filter", @"Pre-Filter", @"Dust-Collector", @"Panel Indication", @"System Diagnostic"]

#import "HomeKit_SelectedViewController.h"
#import "YRDropdownView.h"
#import "HomeKit_ColorManager.h"

@interface HomeKit_SelectedViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    __weak IBOutlet UIView *_viewHeaderPanel;
    __weak IBOutlet UIView *_viewWarningForService;
    __weak IBOutlet UILabel *_lblWarningForService;
    __weak IBOutlet UITextField *_tfName;
    
    NSMutableArray *_maNames;
}
@end

@implementation HomeKit_SelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewHeaderPanel.backgroundColor = RGB(238, 238, 238);
    _tfName.delegate = self;
    
    _viewWarningForService.layer.borderColor = [[HomeKit_ColorManager sharedInstance] warningBorderYellow].CGColor;
    _viewWarningForService.layer.borderWidth = 1.0;
    _viewWarningForService.backgroundColor = [[HomeKit_ColorManager sharedInstance] warningBgLightYellow];
    _viewWarningForService.layer.cornerRadius = 5.0;
    _viewWarningForService.clipsToBounds = YES;
    
    if(self.fromRoomManager){
        _maNames = [NSMutableArray arrayWithArray:kPredefinedRooms];
    }
    else{
        _maNames = [NSMutableArray arrayWithArray:kPredefinedServices];
    }
    
    if(self.editType == EditTypeRename){
        _tfName.text = self.currentName;
    }
    
    CGRect frameHeader = _viewHeaderPanel.frame;
    
    if(self.fromRoomManager){
        [self.navigationItem.backBarButtonItem setTitle:@"房间名称"];
        self.title = @"房间设置";
        frameHeader.size.height = 75;
        _viewWarningForService.hidden = YES;
    }
    else{
        [self.navigationItem.backBarButtonItem setTitle:@"服务名称"];
        self.title = @"服务设置";
        frameHeader.size.height = 140;
    }
    
    _viewHeaderPanel.frame = frameHeader;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [AccessoryManager sharedInstance].delegate = self;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}




- (IBAction)actionForCreation:(id)sender {
    
    if(_tfName.text.length == 0){
        [self showDropdownViewWithMessage:@"名称不可为空！"];
        return;
    }
    
    __block BOOL exist = NO;
    [self.existNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = obj;
        if(self.editType == EditTypeNew){
            if([name isEqualToString:_tfName.text]){
                exist = YES;
                *stop = YES;
            }
        }
        else{
            if([name isEqualToString:_tfName.text] && self.index != idx){
                exist = YES;
                *stop = YES;
            }
        }
    }];
    
    if(exist){
        [self showDropdownViewWithMessage:@"名称已经存在！"];
        return;
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(setName:editType:index:)]) {
        [self.delegate setName:_tfName.text editType:self.editType index:self.index];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)endEditHome
{
    [_tfName resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)showDropdownViewWithMessage:(NSString *)pMessage
{
    
    [YRDropdownView showDropdownInView:self.navigationController.view
                                 title:@"Warning"
                                detail:pMessage
                                 image:[UIImage imageNamed:@"dropdown-alert"]
                              animated:YES hideAfter:2];
}

// 获得焦点
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
//    if(textField.tag == 1000){
//        [self performSelector:@selector(setFocusToInput) withObject:self afterDelay:1];
//    }
//    if(textField.tag == 1){
//        //        self.sideMenuViewController.panGestureEnabled = NO;
//    }
    
    return YES;
}

// 失去焦点
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSLog(@"shouldChangeCharactersInRange.......%@", _tfName.text);
//    [self filterContentForSearchText:_tfName.text];
    return YES;
}
- (void)textFieldChanged:(id)sender
{
//    NSLog(@"current ContentOffset is %@",_tfName.text);
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _tfName.text = [_maNames objectAtIndex:indexPath.row];

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
    return _maNames.count;
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
    
    cell.textLabel.text = [_maNames objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - clsoe keyboard...
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

@end
