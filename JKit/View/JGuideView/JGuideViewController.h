//
//  JGuideViewController.h
//  JKitDemo
//
//  Created by Zebra on 16/4/11.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectedEnter)();

@interface JGuideViewController : UIViewController

@property (nonatomic, copy) DidSelectedEnter didSelectedEnter;

/**
 *  enterButton
 */
@property (nonatomic, strong) UIButton *enterButton;


/**
 *  初始化
 *
 *  @param coverNames 背景图片
 *
 *  @return self
 */
- (instancetype)initWithCoverImageNames:(NSArray*)coverNames;

/**
 *  初始化
 *
 *  @param coverNames 文字图片
 *  @param bgNames    背景图片
 *
 *  @return self
 */
- (instancetype)initWithCoverImageNames:(NSArray*)coverNames backgroundImageNames:(NSArray*)bgNames;

/**
 *  初始化
 *
 *  @param coverNames 文字图片
 *  @param bgNames    背景图片
 *  @param button     点击btn
 *
 *  @return self
 */
- (instancetype)initWithCoverImageNames:(NSArray*)coverNames backgroundImageNames:(NSArray*)bgNames button:(UIButton*)button;

/**
 *  点击button的回调 实现该方法需自己写回调事件
 *
 *  @param didSelectedEnter block
 */
- (void)j_guideViewControllerDidSelectedEnter:(DidSelectedEnter)didSelectedEnter;

@end
