//
//  TopClassification.h
//  JKitDemo
//
//  Created by SKiNN on 16/1/27.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^JTopClassificationCallBackBlock)(NSInteger index);
@interface JTopClassification : UIView

@property (nonatomic, strong) NSMutableArray *titleArr;

@property (nonatomic, strong) JTopClassificationCallBackBlock block;

/**
 *  实例化
 *
 *  @param frame     frame
 *  @param titleArr  title
 *  @param width     每个btn的宽
 *  @param isSliding 是否支持滑动
 *
 *  @return TopClassification
 */

+ (instancetype)j_topClassificationWithFrame:(CGRect)frame andTitleArr:(NSMutableArray<NSString *> *)titleArr andTitleBtnWidth:(CGFloat)width andIsSliding:(BOOL)isSliding;

/**
 *  title颜色
 *
 *  @param selectcolor 选中颜色
 *  @param normalcolor 未选中颜色
 */
- (void)j_setSelectedTitleColor:(UIColor *)selectcolor andNormalTitleColor:(UIColor *)normalcolor;

/**
 *  title背景
 *
 *  @param selectcolor 选中背景
 *  @param normalcolor 未选中背景
 */
- (void)j_setBackgroundSelectedImage:(UIImage *)selectImg andBackgroundNormalImage:(UIImage *)normalImg;

/**
 *  回调
 *
 *  @param block 点击btn的下标
 */
- (void)j_getTopClassificationCallBackBlock:(JTopClassificationCallBackBlock)block;
@end
