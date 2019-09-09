//
//  ViewController.m
//  中间大2边小轮播
//
//  Created by 郭朝顺 on 2019/5/20星期一.
//  Copyright © 2019年 智网易联. All rights reserved.
//

#import "ViewController.h"
#import "MainADView.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    // 主要参考代码 : https://github.com/orzzh/WLScrollView , 这个是用scrollview做的,然后自己写的cell复用,干嘛这么复杂啊,所以我的例子直接用了UICollectionView
    MainADView * main = [[MainADView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    main.dataSourse = @[@"1",@"2",@"3",@"4",];
    main.timerInterval = 5;
    [main setCallBack:^(id  _Nonnull data) {
        NSLog(@"对应的model数据 :%@ %@",self,data);
    }];
    [self.view addSubview:main];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(600 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [main removeFromSuperview];
    });
    
}




@end
