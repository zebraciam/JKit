//
//  ViewController.m
//  JKitDemo
//
//  Created by elongtian on 16/1/5.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import "ViewController.h"
#import "JKit.h"

@interface ViewController (){
    JPicScrollerView  *_picView;
    JPicScrollerLabel  *_picLabel;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self JPicScrollerLabelDemo];
    [self JTopClassificationDemo];
}
#pragma mark -轮播图
- (void)JPicScrollerViewDeme{
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    
    NSMutableArray *arr3 = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 7; i++) {
        [arr2 addObject:[NSString stringWithFormat:@"%d",i]];
        [arr3 addObject:[NSString stringWithFormat:@"我是第%d张图片啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊",i]];
    };
    
    
    //    _picView = [JPicScrollerView j_picScrollViewWithFrame:CGRectMake(0,100,self.view.frame.size.width, 200) WithImageUrls:nil];
    _picView = [JPicScrollerView j_picScrollViewWithFrame:CGRectMake(0,100,self.view.frame.size.width, 200)];
    [_picView setImageUrlStrings:arr2];
    //    _picView.titleData = arr3;
    _picView.backgroundColor = [UIColor clearColor];
    [_picView setImageViewDidTapAtIndex:^(NSInteger index) {
        JLog("你点到我了😳index:%zd\n",index);
    }];
    
    _picView.AutoScrollDelay = 2.0f;
    
    [self.view addSubview:_picView];
}
#pragma mark -topTab
- (void)JTopClassificationDemo{
    NSMutableArray * titleArr = [NSMutableArray arrayWithObjects:@"待处理",@"待处理",@"待处理",@"待处理",@"待处理",@"待处理",@"待处理",@"配送",@"已完成",@"已关闭", nil];
    JTopClassification *top = [JTopClassification j_topClassificationWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 44) andTitleArr:titleArr andTitleBtnWidth:100 andIsSliding:YES];
    [top j_setSelectedTitleColor:[UIColor redColor] andNormalTitleColor:[UIColor blackColor]];
    [top j_setBackgroundSelectedImage:[UIImage imageNamed:@"tabcr"] andBackgroundNormalImage:nil];
    [self.view addSubview:top];
    [top j_getTopClassificationCallBackBlock:^(NSInteger index) {
        JLog("你点到我了😳index:%zd\n",index);
    }];
}

#pragma mark -轮播图
- (void)JPicScrollerLabelDemo{
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    
    NSMutableArray *arr3 = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 7; i++) {
        [arr2 addObject:[NSString stringWithFormat:@"%d",i]];
        [arr3 addObject:[NSString stringWithFormat:@"我是第%d张图片啊",i]];
    };
    
    
    //    _picView = [JPicScrollerView j_picScrollViewWithFrame:CGRectMake(0,100,self.view.frame.size.width, 200) WithImageUrls:nil];
    _picLabel = [JPicScrollerLabel j_picScrollLabelWithFrame:CGRectMake(0,100,self.view.frame.size.width, 60)];
    [_picLabel setImageUrlStrings:arr2];
    _picLabel.titleData = arr3;
    _picLabel.textColors = @[JColorWithGray,JColorWithRed,JColorWithGray];
    _picLabel.fonts = @[JFont(12),JFont(14),JFont(12)];
    _picLabel.backgroundColor = [UIColor clearColor];
    [_picLabel setImageViewDidTapAtIndex:^(NSInteger index) {
        JLog("你点到我了😳index:%zd\n",index);
    }];
    
    _picLabel.AutoScrollDelay = 3.0f;
    
    [self.view addSubview:_picLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
