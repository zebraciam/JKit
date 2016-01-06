//
//  UIViewController+J.h
//  JKitDemo
//
//  Created by elongtian on 16/1/6.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JBackButtonHandlderProtocol <NSObject>

@optional

/**
 *  重写此方法处理返回按钮
 *
 *  @return YES:返回,NO:不返回
 */
- (BOOL)j_navigationShouldPopOnBackButton;

@end
@interface UIViewController (J)<JBackButtonHandlderProtocol>
/**
 *  触摸自动隐藏键盘
 */
- (void)j_tapDismissKeyboard;
@end
