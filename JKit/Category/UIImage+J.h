//
//  UIImage+J.h
//  JKitDemo
//
//  Created by elongtian on 16/1/6.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^j_WriteToSavedPhotosSuccess)();
typedef void(^j_WriteToSavedPhotosError)(NSError *error);
@interface UIImage (J)
/**
 *  将UIColor转为UIImage
 *
 *  @param color UIColor
 *
 *  @return UIImage
 */
+ (UIImage *)j_imageWithColor:(UIColor *)color;

/**
 *  将UIColor转为UIImage
 *
 *  @param color UIColor
 *  @param frame CGRect
 *
 *  @return UIImage
 */
+ (UIImage *)j_imageWithColor:(UIColor *)color withFrame:(CGRect)frame;

/**
 *  保存到相簿
 *
 *  @param success 成功回调
 *  @param error   失败回调
 */
- (void)j_writeToSavedPhotosAlbumWithSuccess:(j_WriteToSavedPhotosSuccess)success error:(j_WriteToSavedPhotosError)error;
@end
