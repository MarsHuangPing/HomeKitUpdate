//
//  MLDataPicker.m
//  NewPeek2
//
//  Created by Tyler on 13-4-23.
//  Copyright (c) 2013年 Delaware consulting. All rights reserved.
//

#define kSelectedRowColor [UIColor colorWithRed:12/255.0 green:76/255.0 blue:186/255.0 alpha:1.0]

#import "MLDataPicker.h"

@interface MLDataPicker () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView *_pvItems;
    
    NSMutableArray *_maItems;
    
    NSInteger _indexSelected;
}

@end

@implementation MLDataPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithDefaultIndex:(int)pIndex
                     items:(NSMutableArray *)pItems
{
    if (self = [super init]) {
        [self initContentView];
        
        _maItems = pItems;
        
        _indexSelected = pIndex;
        
        [_pvItems selectRow:pIndex inComponent:0 animated:YES];
        
        UILabel *lblTitle = (UILabel *)[_pvItems viewForRow:pIndex forComponent:0];
        
        lblTitle.textColor = kSelectedRowColor;
    }
    
    return self;
}

- (void)initContentView
{
    [super initContentView];
    
    _pvItems = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, self.frame.size.width, kPickerHeight)];
    _pvItems.showsSelectionIndicator = YES;
    _pvItems.backgroundColor = [UIColor whiteColor];
    _pvItems.dataSource = self;
    _pvItems.delegate = self;
    
    UIView *viewContent = [self viewWithTag:kContentViewTag];
    
    [viewContent addSubview:_pvItems];
}

- (void)done
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(dataPicker:index:)]) {
        [self.delegate dataPicker:self index:_indexSelected];
    }
    
    [super close];
}

#pragma mark - UIPickerViewDataSsource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return _maItems.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UILabel* lblTitle = (UILabel*)view;
    
    if (lblTitle == nil) {
        lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
		lblTitle.backgroundColor = [UIColor clearColor];
		lblTitle.textAlignment = NSTextAlignmentCenter;
		lblTitle.textColor = [UIColor blackColor];
		lblTitle.font = [UIFont boldSystemFontOfSize:24];
    }
    
    lblTitle.text = _maItems[row];
    lblTitle.textColor = [UIColor blackColor];
	
    return lblTitle;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return self.frame.size.width;
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	UILabel *lblOld = (UILabel *)[pickerView viewForRow:_indexSelected forComponent:component];
    lblOld.textColor = [UIColor blackColor];
    
    UILabel *lblNew = (UILabel *)[pickerView viewForRow:row forComponent:component];
    
    lblNew.textColor = kSelectedRowColor;
    
    _indexSelected = row;
}

@end
