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
#define JWindow [[UIApplication sharedApplication] window]

#define IOS7 [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7

#define IOS8 [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=8

#define JFont(s) ([UIFont systemFontOfSize:s])

#ifdef DEBUG
# define JLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define JLog(...);
#endif
#endif /* JMacro_h */
