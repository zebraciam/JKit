//
//  UIViewController+JAlertView.m
//  JKitDemo
//
//  Created by Zebra on 16/5/17.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import "UIViewController+JAlertView.h"
#import <objc/runtime.h>
#import "JKit.h"

@interface UIViewController ()
@property (nonatomic, strong)UIAlertView *alertView;

@property (nonatomic, strong)dispatch_block_t block;

@property (nonatomic, strong)NSString *allowPlayCount;

@end

static char const JAlertViewKey, JBlockKey, JAllowPlayCountKey;

@implementation UIViewController (JAlertView)

- (void)setAlertView:(UIAlertView *)alertView{
    objc_setAssociatedObject(self, &JAlertViewKey, alertView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIAlertView *)alertView{
    return objc_getAssociatedObject(self, &JAlertViewKey);
}


- (void)setBlock:(dispatch_block_t)block{
    objc_setAssociatedObject(self, &JBlockKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
-(dispatch_block_t)block{
    return objc_getAssociatedObject(self, &JBlockKey);
}

- (void)setAllowPlayCount:(NSString *)allowPlayCount{
    objc_setAssociatedObject(self, &JAllowPlayCountKey, allowPlayCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)allowPlayCount{
    return objc_getAssociatedObject(self, &JAllowPlayCountKey);
}

- (void)j_isAllowPlay:(BOOL)isAllowPlay{
    if (isAllowPlay) {
        self.allowPlayCount = @"1";
    }else{
        self.allowPlayCount = @"0";
    }
}

- (void)j_showAlert:(NSString *)message{
    
    [JKeyWindow endEditing:YES];
    if ([self.allowPlayCount integerValue] == 1 || [self.allowPlayCount integerValue] == 0) {
        if ([self.allowPlayCount integerValue] == 1) {
            self.allowPlayCount = @"2";
        }
        self.alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        
        [self.alertView show];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(alertDismiss) userInfo:nil repeats:NO];
    }
}

- (void)j_showAlert:(NSString *)message andBlock:(dispatch_block_t)block{
    [JKeyWindow endEditing:YES];
    if ([self.allowPlayCount integerValue] == 1 || [self.allowPlayCount integerValue] == 0) {
        if ([self.allowPlayCount integerValue] == 1) {
            self.allowPlayCount = @"2";
        }
        self.block = block;
        self.alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        
        [self.alertView show];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(alertDismissWithBlock) userInfo:nil repeats:NO];
    }
}

- (void)j_showAlert:(NSString *)message
           andTitle:(NSString *)title
       andDoneTitle:(NSString *)doneTitle
     andCancleTitle:(NSString *)cancleTitle
           andBlock:(dispatch_block_t)block{
    
    [JKeyWindow endEditing:YES];
    if ([self.allowPlayCount integerValue] == 1 || [self.allowPlayCount integerValue] == 0) {
        if ([self.allowPlayCount integerValue] == 1) {
            self.allowPlayCount = @"2";
        }
        self.block = block;
        self.alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancleTitle otherButtonTitles:doneTitle, nil];
    
        [self.alertView show];
        
        [[self.alertView rac_buttonClickedSignal] subscribeNext:^(id x) {
            if ([x boolValue]) {
                JBlock(block);
            }
        }];
        
    }
}

- (void)alertDismissWithBlock{
    JBlock(self.block);
    [self alertDismiss];
}

- (void)alertDismiss{
    [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
}
@end
