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

// Tint: Color
-(UIImage*)j_tintedImageWithColor:(UIColor*)color {
    return [self j_tintedImageWithColor:color level:1.0f];
}

// Tint: Color + level
-(UIImage*)j_tintedImageWithColor:(UIColor*)color level:(CGFloat)level {
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    return [self j_tintedImageWithColor:color rect:rect level:level];
}

// Tint: Color + Rect
-(UIImage*)j_tintedImageWithColor:(UIColor*)color rect:(CGRect)rect {
    return [self j_tintedImageWithColor:color rect:rect level:1.0f];
}

// Tint: Color + Rect + level
-(UIImage*)j_tintedImageWithColor:(UIColor*)color rect:(CGRect)rect level:(CGFloat)level {
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawInRect:imageRect];
    
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextSetAlpha(ctx, level);
    CGContextSetBlendMode(ctx, kCGBlendModeSourceAtop);
    CGContextFillRect(ctx, rect);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *darkImage = [UIImage imageWithCGImage:imageRef
                                             scale:self.scale
                                       orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    UIGraphicsEndImageContext();
    
    return darkImage;
}

// Tint: Color + Insets
-(UIImage*)j_tintedImageWithColor:(UIColor*)color insets:(UIEdgeInsets)insets {
    return [self j_tintedImageWithColor:color insets:insets level:1.0f];
}

// Tint: Color + Insets + level
-(UIImage*)j_tintedImageWithColor:(UIColor*)color insets:(UIEdgeInsets)insets level:(CGFloat)level {
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    return [self j_tintedImageWithColor:color rect:UIEdgeInsetsInsetRect(rect, insets) level:level];
}

// Light: Level
-(UIImage*)j_lightenWithLevel:(CGFloat)level {
    return [self j_tintedImageWithColor:[UIColor whiteColor] level:level];
}

// Light: Level + Insets
-(UIImage*)j_lightenWithLevel:(CGFloat)level insets:(UIEdgeInsets)insets {
    return [self j_tintedImageWithColor:[UIColor whiteColor] insets:insets level:level];
}

// Light: Level + Rect
-(UIImage*)j_lightenRect:(CGRect)rect withLevel:(CGFloat)level {
    return [self j_tintedImageWithColor:[UIColor whiteColor] rect:rect level:level];
}

// Dark: Level
-(UIImage*)j_darkenWithLevel:(CGFloat)level {
    return [self j_tintedImageWithColor:[UIColor blackColor] level:level];
}

// Dark: Level + Insets
-(UIImage*)j_darkenWithLevel:(CGFloat)level insets:(UIEdgeInsets)insets {
    return [self j_tintedImageWithColor:[UIColor blackColor] insets:insets level:level];
}

// Dark: Level + Rect
-(UIImage*)j_darkenRect:(CGRect)rect withLevel:(CGFloat)level {
    return [self j_tintedImageWithColor:[UIColor blackColor] rect:rect level:level];
}

@end
