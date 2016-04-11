//
//  UIViewController+JPlaceholderView.m
//  JKitDemo
//
//  Created by Zebra on 16/4/11.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import "UIViewController+JPlaceholderView.h"
#import "JKit.h"
#import <objc/runtime.h>

@interface UIViewController ()

@property (copy, nonatomic) dispatch_block_t refreshBlock;

@end

static char const JPlaceholderViewKey, JRefreshKey;

@implementation UIViewController (JPlaceholderView)
- (void)setJ_placeholderView:(JPlaceholderView *)j_placeholderView {
    
    objc_setAssociatedObject(self, &JPlaceholderViewKey, j_placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JPlaceholderView *)j_placeholderView {
    
    return objc_getAssociatedObject(self, &JPlaceholderViewKey);
}

- (void)setRefreshBlock:(dispatch_block_t)refreshBlock {
    
    objc_setAssociatedObject(self, &JRefreshKey, refreshBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (dispatch_block_t)refreshBlock {
    
    return objc_getAssociatedObject(self, &JRefreshKey);
}

- (void)j_showPlaceholderInitWithBackgroundColor:(UIColor *)color imageName:(NSString *)imageName andTitle:(NSString *)title andFrame:(CGRect)frame andRefresBlock:(dispatch_block_t)block
{
    [self j_showPlaceholderInitWithImageName:imageName andTitle:title andFrame:frame andRefresBlock:block];
    
    self.j_placeholderView.backgroundColor = color;
}

- (void)j_showPlaceholderInitWithBackgroundColor:(UIColor *)color imageName:(NSString *)imageName andTitle:(NSString *)title andRefresBlock:(dispatch_block_t)block
{
    [self j_showPlaceholderInitWithImageName:imageName andTitle:title andRefresBlock:block];
    
    self.j_placeholderView.backgroundColor = color;
}

- (void)j_showPlaceholderInitWithImageName:(NSString *)imageName andTitle:(NSString *)title andRefresBlock:(dispatch_block_t)block
{
    [self j_showPlaceholderInitWithImageName:imageName andTitle:title andFrame:CGRectMake(0, 0, JScreenWidth, JScreenHeight) andRefresBlock:block];
}

- (void)j_showPlaceholderInitWithImageName:(NSString *)imageName andTitle:(NSString *)title andFrame:(CGRect)frame andRefresBlock:(dispatch_block_t)block
{
    self.refreshBlock = block;
    
    if (!self.j_placeholderView) {
        
        self.j_placeholderView = [[JPlaceholderView alloc] initWithFrame:frame];
        
//        if ([self respondsToSelector:@selector(setTableView:)]) {
//            
//            if ([((UITableViewController *)self).tableView respondsToSelector:@selector(setScrollEnabled:)]) {
//                
//                self.j_placeholderView.j_top = self.j_placeholderView.j_top - 30;
//            }
//        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshAction)];
        [self.j_placeholderView addGestureRecognizer:tap];
        
        [self.view addSubview:self.j_placeholderView];
    }
    
    [self setScrollEnabled:NO];
    
    [self.j_placeholderView j_showViewWithImageName:imageName andTitle:title];
}

- (void)refreshAction
{
    if (self.refreshBlock) {
        
//        [self j_hidePlaceholder];
        
        self.refreshBlock();
    }
}

- (void)j_hidePlaceholder
{
    [self.j_placeholderView j_hide];
    
    [self setScrollEnabled:YES];
}

- (void)setScrollEnabled:(BOOL)enabled
{
    if ([self respondsToSelector:@selector(setTableView:)]) {
        if ([((UITableViewController *)self).tableView respondsToSelector:@selector(setScrollEnabled:)]) {
            
            [((UITableViewController *)self).tableView setScrollEnabled:enabled];
        }
    }
    
    if ([self respondsToSelector:@selector(setCollectionView:)]) {
        if ([((UICollectionViewController *)self).collectionView respondsToSelector:@selector(setScrollEnabled:)]) {
            
            [((UICollectionViewController *)self).collectionView setScrollEnabled:enabled];
        }
    }
}

@end
