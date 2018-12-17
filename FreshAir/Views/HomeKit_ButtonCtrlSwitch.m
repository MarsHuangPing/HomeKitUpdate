//
//  ButtonCtrlSwitch.m
//  FreshAir
//
//  Created by mars on 12/03/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_ButtonCtrlSwitch.h"
#import "FDActivityIndicatorView.h"

@interface HomeKit_ButtonCtrlSwitch()
{
    FDActivityIndicatorView *_indicatorView;
    UIView *_viewCover;
}

@end

@implementation HomeKit_ButtonCtrlSwitch

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5.0;
    self.clipsToBounds = YES;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
}

- (void)setBsStatus:(ButtonCtrlSwitchStatus)bsStatus
{
    _bsStatus = bsStatus;
    if(_bsStatus == ButtonCtrlSwitchStatusPendding){
        [self start];
    }
    else{
        [self stop];
    }
    
    switch (self.bsType) {
        case ButtonCtrlSwitchTypeNormal:
        {
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if(_bsStatus == ButtonCtrlSwitchStatusActive){
                [self setBackgroundImage:[UIImage imageNamed:@"big_light_orange"] forState:UIControlStateNormal];
            }
            if(_bsStatus == ButtonCtrlSwitchStatusInactive){
                [self setBackgroundImage:[UIImage imageNamed:@"big_light_blue"] forState:UIControlStateNormal];
            }
            break;
        }
        case ButtonCtrlSwitchTypeWindSmall:
        {
            
            if(_bsStatus == ButtonCtrlSwitchStatusActive){
                [self setBackgroundImage:[UIImage imageNamed:@"big_light_blue"] forState:UIControlStateNormal];
                [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            }
            else{
                [self setBackgroundImage:nil forState:UIControlStateNormal];
                [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            }
            if(_bsStatus == ButtonCtrlSwitchStatusInactive){
                self.layer.cornerRadius = 5.0;
                self.layer.borderColor = [UIColor lightGrayColor].CGColor;
                self.layer.borderWidth = 1.0;
                [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            else{
                self.layer.borderWidth = 0;
            }
            break;
        }
        case ButtonCtrlSwitchTypeRenameOK:
        {
            [self setBackgroundImage:[UIImage imageNamed:@"big_light_blue"] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        }
    }
    
}
- (void)start
{
    if(_indicatorView){
        [_indicatorView removeFromSuperview];
        _indicatorView = nil;
    }
    
    if(_viewCover){
        [_viewCover removeFromSuperview];
        _viewCover = nil;
    }
    
    _viewCover = [[UIView alloc] initWithFrame:self.bounds];
    _viewCover.backgroundColor = [UIColor blackColor];
    _viewCover.alpha = 0.3;
    _viewCover.clipsToBounds = YES;
    [self addSubview:_viewCover];
    
    _indicatorView = [[FDActivityIndicatorView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 20)/2, (self.bounds.size.height - 20)/2, 20, 20)];
    _indicatorView.color = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    [self addSubview:_indicatorView];
    
    self.userInteractionEnabled = NO;
}

- (void)stop
{
    [_viewCover removeFromSuperview];
    _viewCover = nil;
    
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
    self.userInteractionEnabled = YES;
}

@end
