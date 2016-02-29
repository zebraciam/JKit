//
//  JLoadingTool.h
//  JKitDemo
//
//  Created by elongtian on 16/2/29.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLoadingTool : NSObject

/**
 *  显示
 */
+ (void)j_startLoading;

/**
 *  消失
 */
+ (void)j_stopLoading;

/**
 *  成功提示
 *
 *  @param string 提示信息
 */
+ (void)j_showSuccessWithStatus:(NSString *)string;

/**
 *  错误提示
 *
 *  @param string 提示信息
 */
+ (void)j_showErrorWithStatus:(NSString *)string;

/**
 *  警告提示
 *
 *  @param string 提示信息
 */
+ (void)j_showInfoWithStatus:(NSString *)string;

/**
 *  显示（默认一个灰色背景）
 */
+ (void)j_startLoadingWithGlobalBackgroundColor;

/**
 *  显示（自定义背景）
 */
+ (void)j_startLoadingWithBackgroundColor:(UIColor *)backgroundColor;

@end
