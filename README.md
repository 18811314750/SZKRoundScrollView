# SZKRoundScrollView
两句代码调用实现无限轮播滚动视图（基于ScrollView封装）

详细介绍，简书博客：http://www.jianshu.com/p/d240bd977689

俩句代码调用
 ```
   //加载滚动视图
    _roundScrollView=[SZKRoundScrollView roundScrollViewWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200) imageArr:self.localImageArr timerWithTimeInterval:5 imageClick:^(NSInteger imageIndex) {
        NSLog(@"imageIndex:第%ld个",imageIndex);
        //在此添加点击图片后的操作
    }];
    [self.view addSubview:_roundScrollView];
```

API简介
```
typedef enum : NSUInteger {
    NSPageControlAlignmentCenter,//中间位置
    NSPageControlAlignmentRight,//右边位置
} NSPageControlAlignment;

@interface SZKRoundScrollView : UIView

/**
 *  小圆点控制器的位置
 */
@property(nonatomic)NSPageControlAlignment pageControlAlignment;
/**
 *  当前小圆点颜色
 */
@property(nonatomic,retain)UIColor *curPageControlColor;
/**
 *  其余小圆点颜色
 */
@property(nonatomic,retain)UIColor *otherPageControlColor;
/**
 *  暂停定时器
 */
-(void)pasueTimer;
/**
 *  开启定时器
 */
-(void)startTimer;

```
详细介绍，简书博客：http://www.jianshu.com/p/d240bd977689
