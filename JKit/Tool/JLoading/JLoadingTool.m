//
//  JLoadingTool.m
//  JKitDemo
//
//  Created by elongtian on 16/2/29.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import "JLoadingTool.h"
#import "JMacro.h"
#import "UIColor+J.h"
#import "UIView+J.h"

@interface JLoadingTool ()

@property (strong, nonatomic) UIView *view;

@end

@implementation JLoadingTool

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

+ (void)j_startLoadingWithNoSelect
{
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}
+ (void)j_startLoadingWithSVProgressHUDMaskType:(SVProgressHUDMaskType)type
{
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:type];
}
+ (void)j_stopLoading
{
    [[JLoadingTool sharedLoadingTool].view removeFromSuperview];
    [SVProgressHUD dismiss];
}

+ (void)j_showSuccessWithStatus:(NSString *)string
{
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showSuccessWithStatus:string];
    [[JLoadingTool sharedLoadingTool].view removeFromSuperview];
    
}

+ (void)j_showErrorWithStatus:(NSString *)string
{
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showErrorWithStatus:string];
    [[JLoadingTool sharedLoadingTool].view removeFromSuperview];
    
}

+ (void)j_showInfoWithStatus:(NSString *)string
{
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showInfoWithStatus:string];
    [[JLoadingTool sharedLoadingTool].view removeFromSuperview];
    
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
    [JLoadingTool j_startLoadingWithBackgroundColor:JColorWithHex(0xf2f2f2)];
}

@end
