//
//  JCameraTool.m
//  JKitDemo
//
//  Created by SKiNN on 16/1/15.
//  Copyright © 2016年 Zebra. All rights reserved.
//

#import "JCameraTool.h"
#import "JKit.h"
#import "ReactiveCocoa.h"
#import "RACDelegateProxy.h"
#import <objc/runtime.h>
#import "JImageCropperViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <QBImagePickerController/QBImagePickerController.h>


@interface JCameraTool () {
    UIStatusBarStyle _statusBarStyle;
}

@property (nonatomic, assign) BOOL isCropper;

@property (nonatomic, assign) BOOL isSystem;

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, strong) UIViewController *viewC;

@property (nonatomic, strong) CallBackBlock confirmBlock;

@property (nonatomic, strong) CallBackBlocks confirmBlocks;

@property (nonatomic, strong) dispatch_block_t cancelBlock;

@end

@implementation JCameraTool

#pragma mark -多选（不支持裁剪）
+ (void)j_creatAlertController:(UIViewController *)viewC
   andMinimumNumberOfSelection:(NSInteger)minNumber
   andMaximumNumberOfSelection:(NSInteger)maxNumber
    andAllowsMultipleSelection:(BOOL)allowsMultipleSelection
                   confirmBack:(CallBackBlocks)confirmBlocks
                 andCancelBack:(dispatch_block_t)cancelBlock {
    
    JCameraTool * SELF = [JCameraTool new];
    SELF.viewC = viewC;
    SELF.confirmBlocks = confirmBlocks;
    SELF.cancelBlock = cancelBlock;
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    
    [[sheet rac_buttonClickedSignal] subscribeNext:^(id x) {
        if ([x integerValue] == 0) {
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
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [SELF imagePickerDelegate:imagePicker];
            }
            
        }else if([x integerValue] == 1){
            
            QBImagePickerController *imagePickerController = [QBImagePickerController new];
            imagePickerController.allowsMultipleSelection = allowsMultipleSelection;
            imagePickerController.minimumNumberOfSelection = minNumber;
            imagePickerController.maximumNumberOfSelection = maxNumber;
            imagePickerController.showsNumberOfSelectedAssets = YES;
            
            [SELF QBImagePickerDelegate:imagePickerController];
        }
    }];
    [sheet showInView:SELF.viewC.view];
}

#pragma mark -单选（支持裁剪）
+ (void)j_creatAlertController:(UIViewController *)viewC
        andCropperTypeIsSystem:(BOOL)isSystem
                    andCropper:(BOOL)isCropper
                      andScale:(CGFloat)scale
                   confirmBack:(CallBackBlock)confirmBlock
                 andCancelBack:(dispatch_block_t)cancelBlock {
    
    JCameraTool * SELF = [JCameraTool new];
    SELF.viewC = viewC;
    SELF.confirmBlock = confirmBlock;
    SELF.cancelBlock = cancelBlock;
    SELF.isCropper = isCropper;
    SELF.isSystem = isSystem;
    SELF.scale = scale;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if (isSystem) {
        if(isCropper){
            imagePicker.allowsEditing = YES;
        }else{
            imagePicker.allowsEditing = NO;
        }
    }
    
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
            if ([x integerValue] == 0) {
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
                
            }else if([x integerValue] == 1){
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [SELF imagePickerDelegate:imagePicker];
            }
        }];
        [sheet showInView:SELF.viewC.view];
    }
}
#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerDelegate:(UIImagePickerController *)imagePicker{
    
    RACDelegateProxy * delegateProxy = [[RACDelegateProxy alloc]initWithProtocol:@protocol(UIImagePickerControllerDelegate)];
    [[delegateProxy rac_signalForSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)] subscribeNext:^(RACTuple *arg) {
        
        UIImagePickerController * picker = [arg first];
        NSDictionary * info = [arg second];
        if(_isCropper){
            
            if (_isSystem) {
                UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerEditedImage"];
                JBlock(self.confirmBlock, portraitImg);
                JBlock(self.confirmBlocks, [NSMutableArray arrayWithObject:portraitImg]);
                [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle];

                [self.viewC dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self cropperDelegate:[info objectForKey:@"UIImagePickerControllerOriginalImage"] andPickerController:picker];
            }
            
        }else{
            UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            JBlock(self.confirmBlock, portraitImg);
            JBlock(self.confirmBlocks, [NSMutableArray arrayWithObject:portraitImg]);
            [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle];
            [self.viewC dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [[delegateProxy rac_signalForSelector:@selector(imagePickerControllerDidCancel:)] subscribeNext:^(RACTuple *arg) {
        UIImagePickerController * picker = [arg first];
        JBlock(self.cancelBlock);
        [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle];
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }];
    
    imagePicker.delegate = (id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegateProxy;
    objc_setAssociatedObject(imagePicker, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self.viewC  presentViewController:imagePicker animated:YES completion:^{
        if ([[UIApplication sharedApplication] statusBarStyle] != UIStatusBarStyleDefault) {
            _statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
        
    }];
}
#pragma mark -JImageCropperDelegate
- (void)cropperDelegate:(UIImage *)portraitImg andPickerController:(UIImagePickerController *)picker{
    
    JImageCropperViewController *imgCropperVC = [[JImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.viewC.view.j_width, self.viewC.view.j_width * self.scale) limitScaleRatio:3.0];
    imgCropperVC.confirmTitle = @"确定";
    imgCropperVC.confirmBtnFont = [UIFont systemFontOfSize:15];
    imgCropperVC.cancelTitle = @"取消";
    
    imgCropperVC.cancelBtnFont = [UIFont systemFontOfSize:15];
    imgCropperVC.cropRectColor = [UIColor whiteColor];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.viewC presentViewController:imgCropperVC animated:YES completion:nil];
    }];
    
    
    [imgCropperVC.navigationController setNavigationBarHidden:YES animated:YES];
    
    RACDelegateProxy * delegateProxy = [[RACDelegateProxy alloc]initWithProtocol:@protocol(JImageCropperDelegate)];
    [[delegateProxy rac_signalForSelector:@selector(imageCropper:didFinished:)] subscribeNext:^(RACTuple *arg) {
        
        [imgCropperVC.navigationController setNavigationBarHidden:NO animated:YES];
        UIImage * image = [arg second];
        JBlock(self.confirmBlock, image);
        [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle];
        [imgCropperVC dismissViewControllerAnimated:NO completion:nil];
    }];
    [[delegateProxy rac_signalForSelector:@selector(imageCropperDidCancel:)] subscribeNext:^(RACTuple *arg) {
        JBlock(self.cancelBlock);
        [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle];
        [imgCropperVC.navigationController setNavigationBarHidden:NO animated:YES];
        [imgCropperVC dismissViewControllerAnimated:NO completion:nil];
        
    }];
    
    imgCropperVC.delegate = (id<JImageCropperDelegate>)delegateProxy;
    objc_setAssociatedObject(imgCropperVC, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -QBImagePickerControllerDelegate
- (void)QBImagePickerDelegate:(QBImagePickerController *)imagePicker{
    
    RACDelegateProxy * delegateProxy = [[RACDelegateProxy alloc]initWithProtocol:@protocol(QBImagePickerControllerDelegate)];
    [[delegateProxy rac_signalForSelector:@selector(qb_imagePickerControllerDidCancel:)] subscribeNext:^(RACTuple *arg) {
        QBImagePickerController * picker = [arg first];
        JBlock(self.cancelBlock);
        [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle];
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }];
    
    [[delegateProxy rac_signalForSelector:@selector(qb_imagePickerController:didSelectAssets:)] subscribeNext:^(RACTuple *arg) {
        QBImagePickerController * picker = [arg first];
        NSArray *info = [arg second];
        
        NSMutableArray *dataImgs = [NSMutableArray array];
        
        for (ALAsset *asset in info) {
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            [dataImgs addObject:[UIImage imageWithCGImage:[representation fullResolutionImage]]];
        }
        
        JBlock(self.confirmBlocks, dataImgs);
        [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle];
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }];
    
    [[delegateProxy rac_signalForSelector:@selector(qb_imagePickerController:didSelectAsset:)] subscribeNext:^(RACTuple *arg) {
        QBImagePickerController * picker = [arg first];
        
        NSMutableArray *dataImgs = [NSMutableArray array];
        
        ALAssetRepresentation *representation = [[arg second] defaultRepresentation];
        [dataImgs addObject:[UIImage imageWithCGImage:[representation fullResolutionImage]]];
        
        JBlock(self.confirmBlocks, dataImgs);
        [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle];
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }];
    
    imagePicker.delegate = (id<QBImagePickerControllerDelegate>)delegateProxy;
    objc_setAssociatedObject(imagePicker, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.viewC  presentViewController:imagePicker animated:YES completion:^{
        if ([[UIApplication sharedApplication] statusBarStyle] != UIStatusBarStyleDefault) {
            _statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
    }];
}

@end
