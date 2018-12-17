//
//  RefreshIndicatorView.m
//  FreshAir
//
//  Created by mars on 05/02/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "RefreshIndicatorView.h"
#import "FDActivityIndicatorView.h"

#import "HomeKit_ColorManager.h"

@interface RefreshIndicatorView()
{
    BOOL _stop;
    float _rotateAngle;
    FDActivityIndicatorView *_indicatorView;
}

@end

@implementation RefreshIndicatorView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)start
{
    _stop = NO;
    
    
    if(_indicatorView){
        [_indicatorView removeFromSuperview];
        _indicatorView = nil;
    }
    
    _indicatorView = [[FDActivityIndicatorView alloc] initWithFrame:CGRectMake(3, 3, 20, 20)];
    _indicatorView.color = [[HomeKit_ColorManager sharedInstance] textWithLightBlue];
    
    [self addSubview:_indicatorView];
    
    
}

- (void)stop
{
    _stop = YES;
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
    
}

@end
