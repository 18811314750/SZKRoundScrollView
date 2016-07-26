//
//  ViewController.m
//  SZKRoundScrollView
//
//  Created by sunzhaokai on 16/7/25.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ViewController.h"
#import "SZKRoundScrollView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface ViewController ()

@property(nonatomic,copy)SZKRoundScrollView *roundScrollView;
@property(nonatomic,copy)NSArray *localImageArr;
@property(nonatomic,copy)NSArray *netImageArr;

@end

@implementation ViewController

//本地图片
-(NSArray *)localImageArr
{
    _localImageArr=@[@"xiangqing_pic_car1",@"xiangqing_pic_car2",@"xiangqing_pic_jiu1",
                @"xiangqing_pic_jiu2"];
    //轮播图图片数组
    return _localImageArr;
}
//网络图片
-(NSArray *)netImageArr
{
    _netImageArr=@[@"http://elec2016data.oss-cn-qingdao.aliyuncs.com/advimage/2014122915442363329665.jpg",@"http://elec2016data.oss-cn-qingdao.aliyuncs.com/advimage/2014122915462117451138.jpg",@"http://elec2016data.oss-cn-qingdao.aliyuncs.com/advimage/2014122915540457014500.jpg"];
    return _netImageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //加载滚动视图
    _roundScrollView=[SZKRoundScrollView roundScrollViewWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200) imageArr:self.localImageArr timerWithTimeInterval:5 imageClick:^(NSInteger imageIndex) {
        NSLog(@"imageIndex:第%ld个",imageIndex);
    }];
    [self.view addSubview:_roundScrollView];

    //可以修改的属性
    //小圆点控制器位置
    _roundScrollView.pageControlAlignment=NSPageControlAlignmentCenter;
    //当前小圆点颜色
    _roundScrollView.curPageControlColor=[UIColor yellowColor];
    //其余小圆点颜色
    _roundScrollView.otherPageControlColor=[UIColor orangeColor];
    
    //暂停定时器
    UIButton *pauseBt=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-90, CGRectGetMaxY(_roundScrollView.frame)+50, 60, 60)];
    pauseBt.backgroundColor=[UIColor orangeColor];
    [pauseBt setTitle:@"暂停" forState:UIControlStateNormal];
    [pauseBt addTarget:self action:@selector(pauseBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseBt];
    //开启定时器
    UIButton *startBt=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pauseBt.frame)+60, CGRectGetMinY(pauseBt.frame), 60, 60)];
    startBt.backgroundColor=[UIColor orangeColor];
    [startBt setTitle:@"开启" forState:UIControlStateNormal];
    [startBt addTarget:self action:@selector(startBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBt];
}
-(void)pauseBtClick
{
    NSLog(@"定时器暂停");
    [_roundScrollView pasueTimer];
}
-(void)startBtClick
{
    NSLog(@"定时器开启");
    [_roundScrollView startTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
