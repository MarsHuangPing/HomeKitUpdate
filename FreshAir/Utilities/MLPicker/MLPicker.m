//
//  MLPicker.m
//  NewPeek2
//
//  Created by Tyler on 3/7/14.
//  Copyright (c) 2014 Delaware consulting. All rights reserved.
//

#import "MLPicker.h"

@interface MLPicker ()
{
    UIWindow *_keyWindow;
}

@end

@implementation MLPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (self = [super initWithFrame:_keyWindow.frame]) {
        [self initBackgroundView];
    }
    
    return self;
}

- (void)dealloc
{
//    NSLog(@"dealloc: %@", self);
}

- (void)initBackgroundView
{
    UIView *viewBackground = [[UIView alloc] initWithFrame:_keyWindow.frame];
    viewBackground.backgroundColor = [UIColor blackColor];
    viewBackground.alpha = 0.0;
    viewBackground.tag = kBackgroundViewTag;
    
    [self addSubview:viewBackground];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    
    [viewBackground addGestureRecognizer:tgr];
}

- (void)initContentView
{
    UIView *viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, _keyWindow.frame.size.height, self.frame.size.width, kContentHeight)];
    viewContent.backgroundColor = [UIColor clearColor];
    viewContent.tag = kContentViewTag;
    
    UIToolbar *tooDate = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 44.0)];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        tooDate.barStyle = UIBarStyleDefault;
    }
    else {
        tooDate.barStyle = UIBarStyleBlack;
    }
    
    [tooDate sizeToFit];
    
    NSMutableArray *maBarItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *bbiCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                               target:self
                                                                               action:@selector(close)];
    
    [maBarItems addObject:bbiCancel];
    
    UIBarButtonItem *bbiFlexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:self
                                                                                  action:nil];
    [maBarItems addObject:bbiFlexSpace];
    
    UIBarButtonItem *bbiDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                             target:self
                                                                             action:@selector(done)];
    [maBarItems addObject:bbiDone];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIBarButtonItem *bbiSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                  target:nil
                                                                                  action:nil];
        bbiSpace.width = 10;
        
        [maBarItems insertObject:bbiSpace atIndex:0];
        [maBarItems insertObject:bbiSpace atIndex:maBarItems.count];
    }

    [tooDate setItems:maBarItems animated:YES];
    
    [viewContent addSubview:tooDate];
  
    [self addSubview:viewContent];
}

- (void)show
{
    [_keyWindow addSubview:self];
    
    UIView *viewBackground = [self viewWithTag:kBackgroundViewTag];
    UIView *viewContent = [self viewWithTag:kContentViewTag];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         viewBackground.alpha = 0.5;
                         viewContent.frame = CGRectMake(0, _keyWindow.frame.size.height - kContentHeight, self.frame.size.width, kContentHeight);
                     }];
}

- (void)close
{
    UIView *viewBackground = [self viewWithTag:kBackgroundViewTag];
    UIView *viewContent = [self viewWithTag:kContentViewTag];

    [UIView animateWithDuration:0.3
                     animations:^{
                         viewBackground.alpha = 0.0;
                         viewContent.frame = CGRectMake(0, _keyWindow.frame.size.height, self.frame.size.width, kContentHeight);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end
