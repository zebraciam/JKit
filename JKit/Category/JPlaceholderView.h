//
//  JPlaceholderView.h
//  JKitDemo
//
//  Created by Zebra on 16/4/11.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPlaceholderView : UIView

@property (strong, nonatomic) UIImageView *imageView;

- (void)j_showViewWithImageName:(NSString *)imageName andTitle:(NSString *)title;

- (void)j_hide;

@end
