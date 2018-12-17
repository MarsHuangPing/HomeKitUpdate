//
//  MLPicker.h
//  NewPeek2
//
//  Created by Tyler on 3/7/14.
//  Copyright (c) 2014 Delaware consulting. All rights reserved.
//

#define kPickerHeight 216.0 //162.0 180.0 216.0
#define kContentHeight (44.0 + kPickerHeight)

#define kBackgroundViewTag 1000
#define kContentViewTag 1001

#import <UIKit/UIKit.h>

@interface MLPicker : UIView

- (void)initContentView;

- (void)show;

- (void)close;

@end