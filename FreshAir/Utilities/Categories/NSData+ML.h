//
//  NSData+ML.h
//  AFNetworkingDemo
//
//  Created by Tyler on 13-4-15.
//  Copyright (c) 2013年 Delaware consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

void *NewBase64Decode(
  const char *inputBuffer,
  size_t length,
  size_t *outputLength);

char *NewBase64Encode(
  const void *inputBuffer,
  size_t length,
  bool separateLines,
  size_t *outputLength);

@interface NSData (ML)

+ (NSData *)ml_dataFromBase64String:(NSString *)aString;
- (NSString *)ml_base64EncodedString;

@end
