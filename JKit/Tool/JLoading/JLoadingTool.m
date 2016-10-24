//
//  JLoadingTool.m
//  JKitDemo
//
//  Created by elongtian on 16/2/29.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import "JLoadingTool.h"
#import "JKit.h"
#import <objc/runtime.h>


@interface JLoadingTool ()

@property (strong, nonatomic) UIView *view;

@property (nonatomic, strong)dispatch_block_t block;

@end

@implementation JLoadingTool

static char const JLoadingBlockKey;

- (void)setBlock:(dispatch_block_t)block{
    objc_setAssociatedObject(self, &JLoadingBlockKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
-(dispatch_block_t)block{
    return objc_getAssociatedObject(self, &JLoadingBlockKey);
}


JSingletonImplementation(LoadingTool)

- (UIView *)view {
    
    if (!_view) {
        
        _view = [[UIView alloc] initWithFrame:JScreenBounds];
    }
    
    return _view;
}
+ (void)j_startLoading
{
    [SVProgressHUD show];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    
}

+ (void)j_startLoadingWithNoSelect {
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

+ (void)j_startLoadingWithSVProgressHUDMaskType:(SVProgressHUDMaskType)type {
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:type];
}
+ (void)j_stopLoading {
    [[JLoadingTool sharedLoadingTool].view removeFromSuperview];
    [SVProgressHUD dismiss];
}

+ (void)j_showSuccessWithStatus:(NSString *)string {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showSuccessWithStatus:string];
    [[JLoadingTool sharedLoadingTool].view removeFromSuperview];
    
}

+ (void)j_showErrorWithStatus:(NSString *)string {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showErrorWithStatus:string];
    [[JLoadingTool sharedLoadingTool].view removeFromSuperview];
    
}

+ (void)j_showInfoWithStatus:(NSString *)string {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showInfoWithStatus:string];
    [[JLoadingTool sharedLoadingTool].view removeFromSuperview];
    
}

+ (void)j_showSuccessWithStatus:(NSString *)string andCallBack:(dispatch_block_t)block {
    
    [self j_status:string andStatusType:1 andCallBack:block];
    
}

+ (void)j_showErrorWithStatus:(NSString *)string andCallBack:(dispatch_block_t)block {
    
    [self j_status:string andStatusType:2 andCallBack:block];
    
}

+ (void)j_showInfoWithStatus:(NSString *)string andCallBack:(dispatch_block_t)block {
    
    [self j_status:string andStatusType:3 andCallBack:block];
    
}

+ (void)j_status:(NSString *)string andStatusType:(NSInteger)type andCallBack:(dispatch_block_t)block {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    
    if (type == 1) {
        [SVProgressHUD showSuccessWithStatus:string];
    } else if (type == 2) {
        [SVProgressHUD showErrorWithStatus:string];
    } else {
        [SVProgressHUD showInfoWithStatus:string];
    }
    
    
    [JLoadingTool sharedLoadingTool].block = block;
    __block int timeout = 1.5; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout == 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                JBlock([JLoadingTool sharedLoadingTool].block);
                [[JLoadingTool sharedLoadingTool].view removeFromSuperview];
                
            });
        }else{
            timeout --;
        }
    });
    dispatch_resume(_timer);
    
}


+ (void)j_startLoadingWithBackgroundColor:(UIColor *)backgroundColor
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:JScreenBounds];
    backgroundView.j_top = 64;
    backgroundView.j_height = backgroundView.j_height - backgroundView.j_top;
    backgroundView.backgroundColor = backgroundColor;
    
    [[JLoadingTool sharedLoadingTool].view insertSubview:backgroundView atIndex:0];
    [[UIApplication sharedApplication].keyWindow addSubview:[JLoadingTool sharedLoadingTool].view];
    
    [JLoadingTool j_startLoading];
}

+ (void)j_startLoadingWithGlobalBackgroundColor
{
    [JLoadingTool j_startLoadingWithBackgroundColor:JColorWithHex(0xf1f1f1)];
}

@end
