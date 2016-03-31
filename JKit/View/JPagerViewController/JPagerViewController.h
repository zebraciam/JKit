//
//  JPagerViewController.h
//  JKitDemo
//
//  Created by Zebra on 16/3/31.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPagerViewController : UIView

/**
 *  创建总控制器
 *
 *  @param titles         topTabTitle ps：必须和childVCs 数量相等
 *  @param childVCs       相关类的类名  ps：必须和titles 数量相等
 *  @param selectColor    选中时的颜色
 *  @param unselectColor  未选中时的颜色
 *  @param underlineColor 下划线的颜色
 *  @param topTabColor    顶部菜单栏的背景颜色
 *  @param isUnnecessary  只保留最近的5个控制器，释放其他控制器的空间，如果滑到对应位置在对其重新创建加载
 */

+ (void)j_createPagerViewControllerWithFrame:(CGRect)frame
                                   andTitles:(NSArray *)titles
                                 andchildVCs:(NSArray *)childVCs
                              andSelectColor:(UIColor *)selectColor
                            andUnselectColor:(UIColor *)unselectColor
                           andUnderlineColor:(UIColor *)underlineColor
                            andTopTabBgColor:(UIColor *)topTabColor
                  andDeallocVCsIfUnnecessary:(BOOL)isUnnecessary;

@end