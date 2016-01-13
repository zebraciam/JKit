//
//  JMacro.h
//  JKitDemo
//
//  Created by elongtian on 16/1/6.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#ifndef JMacro_h
#define JMacro_h


#define JScreenWidth [UIScreen mainScreen].bounds.size.width
#define JScreenHeight [UIScreen mainScreen].bounds.size.height
#define JScreenSize [UIScreen mainScreen].bounds.size
#define JScreenBounds [UIScreen mainScreen].bounds

#define JDelegate [[UIApplication sharedApplication] delegate]
#define JKeyWindow [[UIApplication sharedApplication] keyWindow]
#define JWindow [[[UIApplication sharedApplication] delegate] window]

#define IOS7 [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7

#define IOS8 [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=8

#define JFont(s) ([UIFont systemFontOfSize:s])
#define JBoldFont(s) ([UIFont boldSystemFontOfSize:s])

#define JStringWithInteger(integer) [NSString stringWithFormat:@"%ld",integer]
#define JStringWithInt(int) [NSString stringWithFormat:@"%d",int]
#define JStringWithDouble(double) [NSString stringWithFormat:@"%lf",double]
#define JStringWithFloat(float) [NSString stringWithFormat:@"%f",float]

#define JBlock(block, ...) block ? block(__VA_ARGS__) : nil

#ifdef DEBUG
# define JLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define JLog(...);
#endif


#define JSingletonInterface(className) + (instancetype)shared##className;

#if __has_feature(objc_arc)
#define JSingletonImplementation(className) \
static id instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [super allocWithZone:zone]; \
}); \
return instance; \
} \
+ (instancetype)shared##className { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [[self alloc] init]; \
}); \
return instance; \
} \
- (id)copyWithZone:(NSZone *)zone { \
return instance; \
}
#else
#define JSingletonImplementation(className) \
static id instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [super allocWithZone:zone]; \
}); \
return instance; \
} \
+ (instancetype)shared##className { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [[self alloc] init]; \
}); \
return instance; \
} \
- (id)copyWithZone:(NSZone *)zone { \
return instance; \
} \
- (oneway void)release {} \
- (instancetype)retain {return instance;} \
- (instancetype)autorelease {return instance;} \
- (NSUInteger)retainCount {return ULONG_MAX;}

#endif
#endif /* JMacro_h */
