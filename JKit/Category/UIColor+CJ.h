//
//  UIColor+CJ.h
//  GuoanCommunityE_Shop
//
//  Created by SKiNN on 16/1/5.
//  Copyright © 2016年 Zebra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CJ)
/**
 *  16进制转为UIColor
 *
 *  @param hex 16进制数
 *
 *  @return UIColor
 */
+ (UIColor *)cj_colorWithHex:(NSUInteger)hex;

/**
 *  16进制转为UIColor
 *
 *  @param hex   16进制数
 *  @param alpha 透明度
 *
 *  @return UIColor
 */
+ (UIColor *)cj_colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

/**
 *  16进制字符串转为UIColor
 *
 *  @param hexString e.g.@"ff", @"#fff", @"ff0000",  @"ff00ffcc"
 *
 *  @return UIColor
 */
+ (UIColor *)cj_colorWithHexString:(NSString *)hexString;

/**
 *  产生随机颜色
 *
 *  @return 随机色
 */
+ (UIColor *)cj_colorWithRamdom;

@end
