//
//  MLDatePicker.m
//  NewPeek2
//
//  Created by Tyler on 13-4-18.
//  Copyright (c) 2013年 Delaware consulting. All rights reserved.
//

#import "MLDatePicker.h"

@interface MLDatePicker ()
{
	UIDatePicker *_dpCurrent;
}

@end

@implementation MLDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithDefaultDate:(NSDate *)pDefaultDate
           datePickerMode:(UIDatePickerMode)pDatePickerMode
{
    if (self = [super init]) {
        [self initContentView];

        _dpCurrent.date = pDefaultDate != nil ? pDefaultDate : [NSDate date];
        _dpCurrent.datePickerMode = pDatePickerMode;
    }
    
    return self;
}

- (void)initContentView
{
    [super initContentView];
    
    _dpCurrent = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, self.frame.size.width, kPickerHeight)];
    _dpCurrent.maximumDate = [NSDate date];
    _dpCurrent.backgroundColor = [UIColor whiteColor];
    
    UIView *viewContent = [self viewWithTag:kContentViewTag];
    
    [viewContent addSubview:_dpCurrent];
}

- (void)done
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(datePicker:date:)]) {
        [self.delegate datePicker:self date:_dpCurrent.date];
    }
    
    [super close];
}

@end
