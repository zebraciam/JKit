//
//  JImageCropperViewController.h
//  JKitDemo
//
//  Created by Zebra on 16/7/5.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JImageCropperViewController;

@protocol JImageCropperDelegate <NSObject>

- (void)imageCropper:(JImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(JImageCropperViewController *)cropperViewController;

@end

@interface JImageCropperViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<JImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;
@property (nonatomic, strong) NSString *confirmTitle;
@property (nonatomic, strong) NSString *cancelTitle;
@property (nonatomic, strong) UIColor *btnBgColor;
@property (nonatomic, strong) UIFont *cancelBtnFont;
@property (nonatomic, strong) UIFont *confirmBtnFont;

/** Color of the crop rectangle (defaults to yellow if not specified) */
@property (nonatomic, strong) UIColor *cropRectColor;

/** If YES, then the image will be sized to initally aspect fill the dimensions of the controller's view */
@property (nonatomic, assign) BOOL shouldInitiallyAspectFillImage;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
