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
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    
    NSMutableArray *arr3 = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 7; i++) {
        [arr2 addObject:[NSString stringWithFormat:@"%d.jpg",i]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
