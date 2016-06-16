//
//  JCameraTool.m
//  JKitDemo
//
//  Created by SKiNN on 16/1/15.
//  Copyright © 2016年 Zebra. All rights reserved.
//

#import "JCameraTool.h"
#import "JLoadingTool.h"
#import "JMacro.h"
#import "ReactiveCocoa.h"
#import "RACDelegateProxy.h"
#import "UIView+J.h"
#import <objc/runtime.h>
#import "VPImageCropperViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface JCameraTool ()

@property (nonatomic, assign) BOOL isCropper;

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, strong) UIViewController *viewC;

@property (nonatomic, strong) CallBackBlock block;

@end

@implementation JCameraTool

JSingletonImplementation(JCameraTool);
+ (void)j_creatAlertController:(UIViewController *)viewC andisCropper:(BOOL)isCropper andScale:(CGFloat)scale callBack:(CallBackBlock)block{
    JCameraTool * SELF = [JCameraTool new];
    SELF.viewC = viewC;
    SELF.block = block;
    SELF.isCropper = isCropper;
    SELF.scale = scale;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if(IOS8){
        UIAlertController * sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * canle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction * camera = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                [JLoadingTool j_showInfoWithStatus:@"相机权限受限"];
            }
            else{
                BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
                if (!isCamera) {
                    JLog(@"没有摄像头");
                    [JLoadingTool j_showInfoWithStatus:@"抱歉,您的设备不具备拍照功能!"];
                    return ;
                }
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [SELF imagePickerDelegate:imagePicker];
            }

        }];
        UIAlertAction * pics = [UIAlertAction actionWithTitle:@"从手机相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [SELF imagePickerDelegate:imagePicker];
            
        }];
        [sheet addAction:canle];
        [sheet addAction:camera];
        [sheet addAction:pics];
        [SELF.viewC presentViewController:sheet animated:YES completion:nil];
    }else{
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
        
        [[sheet rac_buttonClickedSignal] subscribeNext:^(id x) {
            if ([x integerValue] == 1) {
                NSString *mediaType = AVMediaTypeVideo;
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                    [JLoadingTool j_showInfoWithStatus:@"相机权限受限"];
                }
                else{
                    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
                    if (!isCamera) {
                        JLog(@"没有摄像头");
                        [JLoadingTool j_showInfoWithStatus:@"抱歉,您的设备不具备拍照功能!"];
                        return ;
                    }
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [SELF imagePickerDelegate:imagePicker];
                }

            }else if([x integerValue] == 2){
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [SELF imagePickerDelegate:imagePicker];
            }
        }];
        [sheet showInView:SELF.viewC.view];
    }
}
#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerDelegate:(UIImagePickerController *)imagePicker{

    @weakify(self);
    RACDelegateProxy * delegateProxy = [[RACDelegateProxy alloc]initWithProtocol:@protocol(UIImagePickerControllerDelegate)];
    [[delegateProxy rac_signalForSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)] subscribeNext:^(RACTuple *arg) {
        @strongify(self);
        UIImagePickerController * picker = [arg first];
        NSDictionary * info = [arg second];
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        if(_isCropper){
            [self cropperDelegate:portraitImg andPickerController:picker];
        }else{
            [picker dismissViewControllerAnimated:YES completion:nil];
            JBlock(self.block, portraitImg);
        }
    }];
    imagePicker.delegate = (id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegateProxy;
    objc_setAssociatedObject(imagePicker, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.viewC  presentViewController:imagePicker animated:YES completion:^{
    }];
}
#pragma mark -VPImageCropperDelegate
- (void)cropperDelegate:(UIImage *)portraitImg andPickerController:(UIImagePickerController *)picker{
    
    VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.viewC.view.j_width, self.viewC.view.j_width * self.scale) limitScaleRatio:3.0];
    imgCropperVC.confirmTitle = @"确定";
    imgCropperVC.confirmBtnFont = [UIFont systemFontOfSize:15];
    imgCropperVC.cancelTitle = @"取消";
    
    imgCropperVC.cancelBtnFont = [UIFont systemFontOfSize:15];
    imgCropperVC.cropRectColor = [UIColor whiteColor];
    [picker pushViewController:imgCropperVC animated:YES];
    [imgCropperVC.navigationController setNavigationBarHidden:YES animated:YES];

    @weakify(self);
    RACDelegateProxy * delegateProxy = [[RACDelegateProxy alloc]initWithProtocol:@protocol(VPImageCropperDelegate)];
    [[delegateProxy rac_signalForSelector:@selector(imageCropper:didFinished:)] subscribeNext:^(RACTuple *arg) {
        @strongify(self);
        [imgCropperVC.navigationController setNavigationBarHidden:NO animated:YES];
        UIImage * image = [arg second];
        JBlock(self.block, image);
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
    [[delegateProxy rac_signalForSelector:@selector(imageCropperDidCancel:)] subscribeNext:^(RACTuple *arg) {
        [imgCropperVC.navigationController setNavigationBarHidden:NO animated:YES];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
    
    imgCropperVC.delegate = (id<VPImageCropperDelegate>)delegateProxy;
    objc_setAssociatedObject(imgCropperVC, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
