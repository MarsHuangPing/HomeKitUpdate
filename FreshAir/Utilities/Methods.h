//
//  Methods.h
//  NewPeek2
//
//  Created by Tyler on 5/4/14.
//  Copyright (c) 2014 Delaware consulting. All rights reserved.
//

#define Localize(str) NSLocalizedString(str, nil)

#define RGB(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]

#define DegressToRadians(degress) (degress * (M_PI / 180.0f))
#define RadiansToDegress(radians) (radians * (180.0f / M_PI))

#define EmptyString(s) ((s).length != 0 ? (s) : @"")
#define CheckNilAndNull(obj) ((obj == nil || [obj isKindOfClass:[NSNull class]]) ? YES : NO)


#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
//Path

#define DocumentsPath(name) [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:name]
#define CachesPath(name) [[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:name]
#define TempPath(name) [NSTemporaryDirectory() stringByAppendingPathComponent:name]
#define ResourcesPath(name) [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name]
#define ImageFromResources(name) [UIImage imageNamed:name]
#define ImageFromCaches(path) [UIImage imageWithContentsOfFile:path]
#define ImageCachesPath(name) [CachesPath(kImageCachesFolderName) stringByAppendingPathComponent:name]
#define kImageCachesPath CachesPath(kImageCachesFolderName)

//Delegate

#define ExecuteDelegateWithNoParam(delegate, selector) if (delegate != nil && [delegate respondsToSelector:selector]) {[delegate performSelector:selector];}
#define ExecuteDelegateWithOneParam(delegate, selector, p1) if (delegate != nil && [delegate respondsToSelector:selector]) {[delegate performSelector:selector withObject:p1];}

//Block

#define ExecuteBlockWithNoParam(block) if (block != nil) { block(); }
#define ExecuteBlockWithOneParam(block, p1) if (block != nil) { block(p1); }
#define ExecuteBlockWithTwoParams(block, p1, p2) if (block != nil) { block(p1, p2); }
#define ExecuteBlockWithThreeParams(block, p1, p2, p3) if (block != nil) { block(p1, p2, p3); }
#define ExecuteBlockWithFourParams(block, p1, p2, p3, p4) if (block != nil) { block(p1, p2, p3, p4); }

typedef void(^ServiceCompletionBlock)(HomeKit_ServiceResponse *pServiceResponse);

//Weak
#define MLWeakObject(obj) __typeof__(obj) __weak
#define MLWeakSelf MLWeakObject(self)

//isDebug
#define kIsDebug NO
#define kDebugLog(log){ if(kIsDebug)NSLog(@"%@ \n", log); }
