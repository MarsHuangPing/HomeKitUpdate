//
//  SelectedViewController.h
//  FreshAir
//
//  Created by mars on 17/12/2017.
//  Copyright © 2017 mars. All rights reserved.
//
#import "HomeKit_BaseTableViewController.h"


@protocol SelectedViewControllerDelegate <NSObject>

@optional
- (void)setName:(NSString *_Nullable)pName editType:(EditType)pEditType index:(NSInteger)pIndex;


@end

@interface HomeKit_SelectedViewController : HomeKit_BaseTableViewController

@property (nonatomic, assign) id<SelectedViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *currentName;
@property (nonatomic, strong) NSMutableArray *existNames;
@property (nonatomic, assign) EditType editType;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) BOOL fromRoomManager;


@end
