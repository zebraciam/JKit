//
//  UIImage+J.m
//  JKitDemo
//
//  Created by elongtian on 16/1/6.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import "UIImage+J.h"
@interface UIImage ()

@property(copy, nonatomic) j_WriteToSavedPhotosSuccess writeToSavedPhotosSuccess;

@property(copy, nonatomic) j_WriteToSavedPhotosError writeToSavedPhotosError;

@end
@implementation UIImage (J)
#pragma mark 将UIColor转为UIImage

+ (UIImage *)j_imageWithColor:(UIColor *)color
{
    return [UIImage j_imageWithColor:color withFrame:CGRectMake(0, 0, 1, 1)];
}

+ (UIImage *)j_imageWithColor:(UIColor *)color withFrame:(CGRect)frame
{
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

#pragma mark -保存到相簿
- (void)j_writeToSavedPhotosAlbumWithSuccess:(j_WriteToSavedPhotosSuccess)success error:(j_WriteToSavedPhotosError)error
{
    self.writeToSavedPhotosSuccess = success;
    self.writeToSavedPhotosError = error;
    
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        
        if (self.writeToSavedPhotosError) {
            self.writeToSavedPhotosError(error);
        }
        
    } else {
        
        if (self.writeToSavedPhotosSuccess) {
            self.writeToSavedPhotosSuccess();
        }
    }
}

#pragma mark -图片压缩系数
- (float)j_pressImageWithLessThanSizeKB:(CGFloat )KB{
    
    NSData *data;
    if (self) {
        data = UIImageJPEGRepresentation(self, 1);
    }else{
        return 1;
    }
    float num = 1;
    if ([data length] < 1024*KB) {
        num = 1;
    }else{
        for (double i = 1.0; i>0; i-=0.05) {
            if ([UIImageJPEGRepresentation(self, i) length] <= 1024*KB) {
                num = i;
                break;
            }
        }
    }
    return num;
}
#pragma mark -改变图片尺寸
- (UIImage*)j_imageWithscaledToSize:(CGSize)newSize{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
@end
