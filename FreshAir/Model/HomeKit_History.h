//
//  History.h
//  FreshAir
//
//  Created by mars on 09/08/2017.
//  Copyright © 2017 mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeKit_History : NSObject

@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) float indoor;
@property (nonatomic, assign) float outdoor;

- (HomeKit_History *)initWithDate:(NSString *)pDate indoor:(float)pIndoor outdoor:(float)pOutdoor;

@end
