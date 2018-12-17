//
//  SplitLineBase.m
//  FreshAir
//
//  Created by mars on 08/03/2018.
//  Copyright © 2018 mars. All rights reserved.
//

#import "HomeKit_SplitLineBase.h"

@implementation HomeKit_SplitLineBase

- (void)awakeFromNib {
    [super awakeFromNib];
    UIColor *colorSplit = RGB(201, 201, 201);
    self.backgroundColor = colorSplit;
}

@end

