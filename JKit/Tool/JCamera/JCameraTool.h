//
//  JCameraTool.h
//  JKitDemo
//
//  Created by SKiNN on 16/1/15.
//  Copyright © 2016年 Zebra. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "QBImagePickerController.h"
//#import <AssetsLibrary/AssetsLibrary.h>


typedef void(^CallBackBlock)(UIImage *image);
typedef void(^CallBackBlocks)(NSMutableArray *images);

@interface JCameraTool : NSObject

/**
 *  裁剪实例化
 *
 *  @param viewC     self
 *  @param isSystem  是否使用系统裁剪  NO 不 YES 是
 *  @param isCropper 是否剪切  NO 不 YES 是
 *  @param scale     剪切的尺寸（屏幕的宽/scale）
 *  @param block     image
 */
+ (void)j_creatAlertController:(UIViewController *)viewC
   andMinimumNumberOfSelection:(NSInteger)minNumber
   andMaximumNumberOfSelection:(NSInteger)maxNumber
    andAllowsMultipleSelection:(BOOL)allowsMultipleSelection
                   confirmBack:(CallBackBlocks)confirmBlocks
                 andCancelBack:(dispatch_block_t)cancelBlock;


/**
 *  多选实例化
 *
 *  @param viewC                   self
 *  @param minNumber               最小的个数
 *  @param maxNumber               最大个数
 *  @param allowsMultipleSelection 是否支持多选
 *  @param block                   images
 */
+ (void)j_creatAlertController:(UIViewController *)viewC
        andCropperTypeIsSystem:(BOOL)isSystem
                    andCropper:(BOOL)isCropper
                      andScale:(CGFloat)scale
                   confirmBack:(CallBackBlock)confirmBlock
                 andCancelBack:(dispatch_block_t)cancelBlock;
@end
