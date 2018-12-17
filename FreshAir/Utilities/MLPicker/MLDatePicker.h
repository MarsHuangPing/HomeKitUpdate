//
//  MLDatePicker.h
//  NewPeek2
//
//  Created by Tyler on 13-4-18.
//  Copyright (c) 2013年 Delaware consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MLPicker.h"

@protocol MLDatePickerDelegate;

@interface MLDatePicker : MLPicker

@property (nonatomic, weak) id<MLDatePickerDelegate> delegate;

- (id)initWithDefaultDate:(NSDate *)pDefaultDate
           datePickerMode:(UIDatePickerMode)pDatePickerMode;

@end

@protocol MLDatePickerDelegate <NSObject>

- (void)datePicker:(MLDatePicker *)pDatePicker date:(NSDate *)pDate;

@end
