//
//  BarChartView.h
//  BarChart
//
//  Created by Yuanin2 on 2017/4/14.
//  Copyright © 2017年 YangLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeKit_TodayBarChartView : UIView
@property(nonatomic,strong) NSDictionary *dataResource;

-(void)draw;

@end
