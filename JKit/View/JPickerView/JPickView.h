//
//  JPickView.h
//  ActionSheet
//
//  Created by 陈杰 on 15/10/22.
//  Copyright © 2015年 chenjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMacro.h"
@class JPickView;
typedef void (^JPickViewSubmit)(NSString*selectStr);

@interface JPickView : UIView<UIPickerViewDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSArray *proTitleList;

@property (nonatomic, copy) NSString *selectedStr;

@property (nonatomic, assign) BOOL isDate;



/**
 *  DatePickerView
 *
 *  @param title title
 */
+ (void)j_createDatePickerWithTitle:(NSString *)title showPickView:(UIViewController *)vc andDatePickerMode:(UIDatePickerMode)mode andCallBack:(JPickViewSubmit)block;
/**
 *  PickerView
 *
 *  @param items 一维数组
 *  @param title title
 */
+ (void)j_createPickerWithItem:(NSArray *)items title:(NSString *)title showPickView:(UIViewController *)vc andCallBack:(JPickViewSubmit)block;;

@property(nonatomic,copy)JPickViewSubmit block;
@end
