//
//  JCameraTool.h
//  JKitDemo
//
//  Created by SKiNN on 16/1/15.
//  Copyright © 2016年 Zebra. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CallBackBlock)(UIImage * image);
@interface JCameraTool : NSObject

/**
 *  实例化
 *
 *  @param viewC     self
 *  @param isCropper 是否剪切  NO 不 YES 是
 *  @param scale     剪切的尺寸（屏幕的宽/scale）
 *  @param block     image
 */
+ (void)j_creatAlertController:(UIViewController *)viewC andisCropper:(BOOL)isCropper andScale:(CGFloat)scale callBack:(CallBackBlock)block;

@end
