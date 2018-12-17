//
//  ButtonSwitch.m
//  FreshAir
//
//  Created by mars on 02/12/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "HomeKit_ButtonSwitch.h"
#import "FDActivityIndicatorView.h"
@interface HomeKit_ButtonSwitch()
{
    FDActivityIndicatorView *_indicatorView;
}

@end
@implementation HomeKit_ButtonSwitch

- (void)setBsStatus:(ButtonSwitchStatus)bsStatus
{
    _bsStatus = bsStatus;
    if(_bsStatus == ButtonSwitchStatusPendding){
        [self start];
    }
    else{
        [self stop];
    }
    if(_bsStatus == ButtonSwitchStatusActive){
        [self setBackgroundImage:[UIImage imageNamed:@"big_light_orange"] forState:UIControlStateNormal];
    }
    if(_bsStatus == ButtonSwitchStatusInactive){
        [self setBackgroundImage:[UIImage imageNamed:@"big_light_blue"] forState:UIControlStateNormal];
    }
    
}
- (void)start
{
    if(_indicatorView){
        [_indicatorView removeFromSuperview];
        _indicatorView = nil;
    }
    
    _indicatorView = [[FDActivityIndicatorView alloc] initWithFrame:CGRectMake(15, (self.bounds.size.height - 20)/2, 20, 20)];
    _indicatorView.color = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    [self addSubview:_indicatorView];
    
    self.userInteractionEnabled = NO;
}

- (void)stop
{
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
    self.userInteractionEnabled = YES;
}

@end
