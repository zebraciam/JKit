//
//  UIColor+J.h
//  JKitDemo
//
//  Created by elongtian on 16/1/5.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (J)
/**
 *  16进制转为UIColor
 *
 *  @param hex 16进制数
 *
 *  @return UIColor
 */
+ (UIColor *)j_colorWithHex:(NSUInteger)hex;

/**
 *  16进制转为UIColor
 *
 *  @param hex   16进制数
 *  @param alpha 透明度
 *
 *  @return UIColor
 */
+ (UIColor *)j_colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

/**
 *  16进制字符串转为UIColor
 *
 *  @param hexString e.g.@"ff", @"#fff", @"ff0000",  @"ff00ffcc"
 *
 *  @return UIColor
 */
+ (UIColor *)j_colorWithHexString:(NSString *)hexString;

/**
 *  产生随机颜色
 *
 *  @return 随机色
 */
+ (UIColor *)j_colorWithRamdom;
@end
