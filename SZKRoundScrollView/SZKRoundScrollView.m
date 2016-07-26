//
//  SZKRoundScrollView.m
//  SZKRoundScrollView
//
//  Created by sunzhaokai on 16/7/25.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "SZKRoundScrollView.h"
#import <UIImageView+WebCache.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SCREEN_COUNT 3

@interface SZKRoundScrollView ()<UIScrollViewDelegate>

@property(nonatomic,retain)UIScrollView *myScrollView;
@property(nonatomic,retain)UIImageView *leftImgView;
@property(nonatomic,retain)UIImageView *centerImgView;
@property(nonatomic,retain)UIImageView *rightImgView;

@property(nonatomic,assign)NSInteger imgCount;//图片总个数
@property(nonatomic,copy)NSArray *imageArr;//图片的数组
@property(nonatomic,assign)NSInteger leftCurIndex;//左边imageView当前的序号
@property(nonatomic,assign)NSInteger centerCurIndex;//中间imageView当前的序号
@property(nonatomic,assign)NSInteger rightCurIndex;//右边imageView当前的序号

@property(nonatomic,retain)UIPageControl *pageControl;//小圆点

@property(nonatomic,retain)NSTimer *timer;//定时器
@property(nonatomic,assign)NSTimeInterval timeInterVal;//图片滑动时间

@property(nonatomic,retain)UITapGestureRecognizer *tap;//图片上的点击手势
@property(nonatomic,copy)imageClick imgClick;//图片点击block

@end

@implementation SZKRoundScrollView


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
#pragma mark---添加定时器
-(void)addTimer
{
    if (_timer==nil) {
        //初始化定时器
        _timer = [NSTimer timerWithTimeInterval:_timeInterVal target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode: NSDefaultRunLoopMode];
        //NSRunLoopCommonModes _myScrollView手动拖动时，继续执行方法
        //NSDefaultRunLoopMode _myScrollView手动拖动时，不执行方法
    }
}
#pragma mark---定时器执行方法
-(void)timerAction
{
    NSLog(@"定时器运行");
    //scrollView滑动到下一个页面
    [UIView animateWithDuration:0.25 animations:^{
        _myScrollView.contentOffset=CGPointMake(SCREEN_WIDTH*2, 0);
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:_myScrollView];
    }];
}
#pragma mark---暂停定时器
-(void)pasueTimer
{
    [_timer invalidate];
    _timer=nil;
}
#pragma mark---开始定时器
-(void)startTimer
{
    [self addTimer];
}
#pragma mark---实现类方法
+(instancetype)roundScrollViewWithFrame:(CGRect)frame imageArr:(NSArray *)imageArr timerWithTimeInterval:(NSTimeInterval)timeInterVal imageClick:(imageClick)imgClick;
{
    SZKRoundScrollView *roundScrollView=[[SZKRoundScrollView alloc]initWithFrame:frame];
    roundScrollView.imageArr=imageArr;
    roundScrollView.timeInterVal=timeInterVal;
    roundScrollView.imgClick=imgClick;
    return roundScrollView;
}
#pragma mark---属性重新赋值
-(void)setImageArr:(NSArray *)imageArr
{
    //重新赋值给_imageArr
    _imageArr=imageArr;
    //图片总数量
    _imgCount=_imageArr.count;
    //添加滚动视图
    [self addScrollView];
    //添加图片控件
    [self addImageView];
    //添加小圆点控件
    [self addPageControl];
}
-(void)setTimeInterVal:(NSTimeInterval)timeInterVal
{
    _timeInterVal=timeInterVal;
    //添加定时器
    [self addTimer];
}
#pragma mark---添加滑动控件
-(void)addScrollView
{
    _myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _myScrollView.showsVerticalScrollIndicator=NO;
    _myScrollView.delegate=self;
    _myScrollView.bounces=NO;
    _myScrollView.pagingEnabled=YES;
    _myScrollView.showsHorizontalScrollIndicator=NO;
    _myScrollView.contentSize=CGSizeMake(SCREEN_COUNT*SCREEN_WIDTH, self.bounds.size.height);
    _myScrollView.contentOffset=CGPointMake(SCREEN_WIDTH, 0);
    [self addSubview:_myScrollView];
}
#pragma mark---添加小圆点控件
-(void)addPageControl
{
    _pageControl=[[UIPageControl alloc]init];
    //注意此方法可以根据页数返回UIPageControl合适的大小
    CGSize size= [_pageControl sizeForNumberOfPages:_imgCount];
    _pageControl.bounds=CGRectMake(0, 0, size.width, size.height);
    _pageControl.center=CGPointMake(SCREEN_WIDTH/2, self.bounds.size.height-size.height/2);
    //设置颜色
    _pageControl.pageIndicatorTintColor=[UIColor colorWithWhite:0.846 alpha:1.000];
    //设置当前页颜色
    _pageControl.currentPageIndicatorTintColor=[UIColor colorWithWhite:0.600 alpha:1.000];
    //设置总页数
    _pageControl.numberOfPages=_imgCount;
    [self addSubview:_pageControl];
}
#pragma mark---小圆点控制器位置
-(void)setPageControlAlignment:(NSPageControlAlignment)pageControlAlignment
{
    CGSize size= [_pageControl sizeForNumberOfPages:_imgCount];

    if (pageControlAlignment==NSPageControlAlignmentCenter) {
        _pageControl.center=CGPointMake(SCREEN_WIDTH/2, self.bounds.size.height-size.height/2);
    }else if(pageControlAlignment==NSPageControlAlignmentRight){
        _pageControl.center=CGPointMake(self.bounds.size.width-size.width/2-20, self.bounds.size.height-size.height/2);
    }
}
#pragma mark---当前小圆点颜色
-(void)setCurPageControlColor:(UIColor *)curPageControlColor
{
    //设置当前页颜色
    _pageControl.currentPageIndicatorTintColor=curPageControlColor;
}
#pragma mark---其余小圆点颜色
-(void)setOtherPageControlColor:(UIColor *)otherPageControlColor
{
    //其余小圆点颜色
    _pageControl.pageIndicatorTintColor=otherPageControlColor;
}
#pragma mark---添加图片控件
-(void)addImageView
{
    //默认第_imgCount-1个
    _leftCurIndex=_imgCount-1;
    //默认第0个
    _centerCurIndex=0;
    //默认第1个
    _rightCurIndex=1;
    //左边的imageView
    _leftImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _myScrollView.bounds.size.height)];
    _leftImgView.backgroundColor=[UIColor colorWithWhite:0.675 alpha:1.000];
    [_myScrollView addSubview:_leftImgView];
    
    //中间的imageView
    _centerImgView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _myScrollView.bounds.size.height)];
    //允许用户交互
    _centerImgView.userInteractionEnabled=YES;
    _centerImgView.backgroundColor=[UIColor colorWithWhite:0.675 alpha:1.000];
    NSURL *url_center=[NSURL URLWithString:[NSString stringWithFormat:@"%@",_imageArr[_centerCurIndex]]];
    [_centerImgView sd_setImageWithURL: url_center placeholderImage:[UIImage imageNamed:_imageArr[_centerCurIndex]]];
    [_myScrollView addSubview:_centerImgView];
    
    //添加点击手势
    _tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_centerImgView addGestureRecognizer:_tap];
    
    //右边的imageView
    _rightImgView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, _myScrollView.bounds.size.height)];
    _rightImgView.backgroundColor=[UIColor colorWithWhite:0.675 alpha:1.000];
    [_myScrollView addSubview:_rightImgView];
}
#pragma mark---图片点击事件
-(void)tap:(UIPanGestureRecognizer *)pan
{
    //将_centerCurIndex传递出去
    self.imgClick(_centerCurIndex);
}

#pragma mark---滑动结束后触发事件
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX=scrollView.contentOffset.x;
    //图片向左滑动，展示下一张图片
    if (offsetX>SCREEN_WIDTH) {
        _leftCurIndex++;
        _centerCurIndex++;
        _rightCurIndex++;
        if (_leftCurIndex>_imgCount-1) {
            _leftCurIndex=0;
        }
        if (_centerCurIndex>_imgCount-1) {
            _centerCurIndex=0;
        }
        if (_rightCurIndex>_imgCount-1) {
            _rightCurIndex=0;
        }
    //图片向右滑动，展示上一张图片
    }else if (offsetX<SCREEN_WIDTH){
        _leftCurIndex--;
        _centerCurIndex--;
        _rightCurIndex--;
        if (_leftCurIndex<0) {
            _leftCurIndex=_imgCount-1;
        }
        if (_centerCurIndex<0) {
            _centerCurIndex=_imgCount-1;
        }
        if (_rightCurIndex<0) {
            _rightCurIndex=_imgCount-1;
        }
    }
    //设置小圆点控制器的位置
    _pageControl.currentPage=_centerCurIndex;
    //切换左，中，右三个位置上面的图片
    NSURL *url_left=[NSURL URLWithString:[NSString stringWithFormat:@"%@",_imageArr[_leftCurIndex]]];
    [_leftImgView sd_setImageWithURL: url_left placeholderImage:[UIImage imageNamed:_imageArr[_leftCurIndex]]];
    NSURL *url_center=[NSURL URLWithString:[NSString stringWithFormat:@"%@",_imageArr[_centerCurIndex]]];
    [_centerImgView sd_setImageWithURL: url_center placeholderImage:[UIImage imageNamed:_imageArr[_centerCurIndex]]];
    NSURL *url_right=[NSURL URLWithString:[NSString stringWithFormat:@"%@",_imageArr[_rightCurIndex]]];
    [_rightImgView sd_setImageWithURL: url_right placeholderImage:[UIImage imageNamed:_imageArr[_rightCurIndex]]];
    //scrollView滑动之后始终保持_centerImgView在正中间
    scrollView.contentOffset=CGPointMake(SCREEN_WIDTH, 0);
}



@end
