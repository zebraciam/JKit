//
//  UIViewController+J.h
//  JKitDemo
//
//  Created by elongtian on 16/1/6.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JFinishPickingMedia)(NSDictionary *info);
typedef void(^JCancelPickingMedia)();

@protocol JBackButtonHandlderProtocol <NSObject>

@optional

/**
 *  重写此方法处理返回按钮
 *
 *  @return YES:返回,NO:不返回
 */
- (BOOL)j_navigationShouldPopOnBackButton;

@end
@interface UIViewController (J)<JBackButtonHandlderProtocol>
/**
 *  触摸自动隐藏键盘
 */
- (void)j_tapDismissKeyboard;

/**
 *  快速跳转到UIImagePickerController
 *
 *  @param sourceType    [UIImagePickerControllerSourceTypePhotoLibrary, UIImagePickerControllerSourceTypeCamera, UIImagePickerControllerSourceTypeSavedPhotosAlbum]
 *  @param allowsEditing 是否裁剪
 *  @param completion    跳转完成回调
 *  @param finish        [UIImagePickerControllerMediaType,UIImagePickerControllerOriginalImage,UIImagePickerControllerCropRect,UIImagePickerControllerMediaURL,UIImagePickerControllerReferenceURL,UIImagePickerControllerMediaMetadata]
 *  @param cancel        取消回调
 *
 *  @return UIImagePickerController
 */
- (UIImagePickerController *)j_presentImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType allowsEditing:(BOOL)allowsEditing completion:(void (^)(void))completion didFinishPickingMedia:(JFinishPickingMedia)finish didCancelPickingMediaWithInfo:(JCancelPickingMedia)cancel;
@end
