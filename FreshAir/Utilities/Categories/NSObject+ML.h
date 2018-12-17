//
//  NSObject+ML.h
//  Panos
//
//  Created by Tyler on 12-11-22.
//  Copyright (c) 2012年 Delaware consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ML)

- (BOOL)ml_boolValue;

- (NSString *)ml_stringValue;

- (float)ml_floatValue;

- (double)ml_doubleValue;

- (int)ml_intValue;

- (int)ml_u8IntValue;

- (NSMutableArray *)ml_mutableArray;

- (NSDate *)ml_date;

@end
