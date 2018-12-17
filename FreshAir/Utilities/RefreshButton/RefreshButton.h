//
//  FefreshButton.h
//  FreshAir
//
//  Created by mars on 30/06/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshButton : UIButton

@property (nonatomic, assign) BOOL rotating;

- (void)start;
- (void)stop;
- (void)rotateWithAngle:(float)pAngle;
- (void)rotate;

@end
