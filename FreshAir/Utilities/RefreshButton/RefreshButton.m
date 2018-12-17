//
//  FefreshButton.m
//  FreshAir
//
//  Created by mars on 30/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import "RefreshButton.h"
#import "FDActivityIndicatorView.h"

@interface RefreshButton()
{
    BOOL _stop;
    float _rotateAngle;
    FDActivityIndicatorView *_indicatorView;
}

@end

@implementation RefreshButton

- (void)start
{
    _stop = NO;
//    [self rotate];
    self.rotating = YES;
    
    if(_indicatorView){
        [_indicatorView removeFromSuperview];
        _indicatorView = nil;
    }
    
    _indicatorView = [[FDActivityIndicatorView alloc] initWithFrame:CGRectMake(3, 3, 20, 20)];
//    _indicatorView.center = self.center;
    _indicatorView.color = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    [self addSubview:_indicatorView];
    
    [self setImage:nil forState:UIControlStateNormal];
    
}

- (void)stop
{
    _stop = YES;
    self.rotating = NO;
    
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
    [self setImage:[UIImage imageNamed:@"BtnRefresh.png"] forState:UIControlStateNormal];
}

- (void)rotateWithAngle:(float)pAngle
{
    CGAffineTransform t = CGAffineTransformRotate(self.transform,pAngle);
    self.transform = t;
}


- (void)rotate
{
    [UIView animateWithDuration:0.001 animations:^{
        CGAffineTransform t = CGAffineTransformRotate(self.transform, M_PI/50);
        self.transform = t;
        
    } completion:^(BOOL finished) {
        _rotateAngle += M_PI/50;
        if(_rotateAngle >= 2* M_PI && _stop){
            _rotateAngle = 0;
        }
        else{
            [self rotate];
        }
        
    }];
    
}
@end
