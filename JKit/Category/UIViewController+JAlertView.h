//
//  UIViewController+JAlertView.h
//  JKitDemo
//
//  Created by Zebra on 16/5/17.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JShowAlert(message) [self j_showAlert:message]

@interface UIViewController (JAlertView)

/**
 *  alertView
 *
 *  @param message 没有btn 没有回调
 */
- (void)j_showAlert:(NSString *)message;

/**
 *  alertView
 *
 *  @param message 没有btn 有回调
 */
- (void)j_showAlert:(NSString *)message andBlock:(dispatch_block_t)block;

/**
 *  alertView
 *
 *  @param message 有btn 有回调
 */
- (void)j_showAlert:(NSString *)message andDoneTitle:(NSString *)doneTitle andCancleTitle:(NSString *)cancleTitle andBlock:(dispatch_block_t)block;

/**
 *  在当前controller限制alert弹出次数
 *
 *  @param count NO 不限制 YES 限制一次
 */
- (void)j_isAllowPlay:(BOOL)isAllowPlay;
@end
