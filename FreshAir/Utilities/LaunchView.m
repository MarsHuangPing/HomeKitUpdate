//
//  LaunchView.m
//  SplashDemo
//
//  Created by Tyler on 1/22/15.
//  Copyright (c) 2015 Delaware consulting. All rights reserved.
//

#import "LaunchView.h"

#import "POP.h"

@interface LaunchView ()
<
    POPAnimationDelegate
>
{
    UIImageView *_ivBackground;
    UIImageView *_ivLogo;
    UIImageView *_ivOne;
    UILabel *_lblTitle;
}

@end

@implementation LaunchView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self customizeControls];
        [self makeAnimations];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
//    NSLog(@"dealloc: %@", self);
}

- (void)customizeControls
{
    _ivBackground = [[UIImageView alloc] initWithFrame:self.bounds];
    
    UIImage *img = nil;
    
//    if (iPhone4) {
//        img = [UIImage imageNamed:@"LaunchImage-700@2x.png"];
//    }
//    else if (iPhone5) {
//        img = [UIImage imageNamed:@"LaunchImage-700-568h@2x.png"];
//    }
//    else if (iPhone6) {
//        img = [UIImage imageNamed:@"LaunchImage-800-667h@2x.png"];
//    }
//    else if (iPhone6Plus) {
//        img = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x.png"];
//    }
//    else {
//        img = [UIImage imageNamed:@"LaunchImage-800-667h@2x.png"];
//    }
    
    _ivBackground.image = img;
    
    [self addSubview:_ivBackground];
    
    _ivLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_memiao"]];
    _ivLogo.frame = CGRectMake((kScreenWidth - 100) / 2.0, (kScreenHeight - 100) / 2.0, 100, 100);
    _ivLogo.alpha = 0;
    
    [_ivBackground addSubview:_ivLogo];
    
    _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, _ivLogo.frame.size.height + _ivLogo.frame.origin.y + 10, kScreenWidth, 21)];
    _lblTitle.text = @"1 minute Buzz!";
    _lblTitle.textAlignment = NSTextAlignmentCenter;
    _lblTitle.font = [UIFont boldSystemFontOfSize:20];
    _lblTitle.textColor = [UIColor colorWithRed:(12/255.0) green:(112/255.0) blue:(191/255.0) alpha:1];
    _lblTitle.alpha = 0;
    
    [_ivBackground addSubview:_lblTitle];
    
    _ivOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_one"]];
    _ivOne.frame = CGRectMake(kScreenWidth * 0.54, 0, 27, 61);
    _ivOne.transform = CGAffineTransformMakeRotation(DegressToRadians(-45));
    _ivOne.alpha = 0;
    
    [_ivBackground addSubview:_ivOne];
    
    UILabel *lblCoypright = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight - 20, kScreenWidth - 10, 20)];
    lblCoypright.textColor = [UIColor colorWithRed:(12/255.0) green:(112/255.0) blue:(191/255.0) alpha:1];
    lblCoypright.text = Localize(@"general_copyright");
    lblCoypright.font = [UIFont systemFontOfSize:13];
    lblCoypright.textAlignment = NSTextAlignmentRight;
    
    [_ivBackground addSubview:lblCoypright];
}

#pragma mark - POPAnimatorDelegate

- (void)pop_animationDidReachToValue:(POPAnimation *)anim
{
    POPSpringAnimation *saRotation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    saRotation.springBounciness = 20;
    saRotation.toValue = @(0);
    
    [_ivOne.layer pop_addAnimation:saRotation forKey:@"rotation"];
    
    [saRotation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        [self removeLaunchView];
    }];
}

#pragma mark - Mehtods

- (void)makeAnimations
{
    [self animationForLogo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animationForTitle];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _ivOne.alpha = 1;
        
        [self animationForOne];
    });
}

- (void)animationForLogo
{
    POPBasicAnimation *baAlpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    baAlpha.toValue = @(1);
    baAlpha.duration = 1.0;
    
    [_ivLogo pop_addAnimation:baAlpha forKey:@"logo-alpha"];
}

- (void)animationForTitle
{
    POPBasicAnimation *baAlpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    baAlpha.toValue = @(1);
    baAlpha.duration = 1.0;
    
    [_lblTitle pop_addAnimation:baAlpha forKey:@"title-alpha"];
}

- (void)animationForOne
{
    POPSpringAnimation *saPositionY = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    saPositionY.springBounciness = 20;
    saPositionY.delegate = self;
    
    float multiplier = 0.533;
    
//    if (iPhone4) {
//        multiplier = 0.545;
//    }
//    else if (iPhone5) {
//        multiplier = 0.539;
//    }
//    else if (iPhone6){
//        multiplier = 0.533;
//    }
//    else {
//        multiplier = 0.53;
//    }
    
    saPositionY.toValue = @(kScreenHeight * multiplier);
    
    [_ivOne.layer pop_addAnimation:saPositionY forKey:@"one-position"];
}

- (void)removeLaunchView
{
    POPBasicAnimation *baScaleXY = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    baScaleXY.toValue = [NSValue valueWithCGSize:CGSizeMake(10.0f, 10.0f)];
    baScaleXY.duration = 1.5;
    
    [self.layer pop_addAnimation:baScaleXY forKey:@"launch-scalexy"];
    
    POPBasicAnimation *baAlpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    baAlpha.toValue = @(0);
    baAlpha.duration = 1.0;
    
    [self pop_addAnimation:baAlpha forKey:@"launch-alpha"];
    
    [baAlpha setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
