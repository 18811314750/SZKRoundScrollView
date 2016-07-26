//
//  SZKRoundScrollView.h
//  SZKRoundScrollView
//
//  Created by sunzhaokai on 16/7/25.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^imageClick)(NSInteger imageIndex);

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
 *  简书号：iOS_凯  http://www.jianshu.com/users/86b0ddc92021/latest_articles
 *
 *  @param frame        frame
 *  @param imageArr     图片数组，网络图片或者本地图片
 *  @param timeInterVal 定时器间隔时间
 *  @param imgClick     图片点击事件
 *
 *  @return SZKRoundScrollView加定时器无限滚动视图
 */
+(instancetype)roundScrollViewWithFrame:(CGRect)frame
                               imageArr:(NSArray *)imageArr
                  timerWithTimeInterval:(NSTimeInterval)timeInterVal
                             imageClick:(imageClick)imgClick;
/**
 *  暂停定时器
 */
-(void)pasueTimer;
/**
 *  开启定时器
 */
-(void)startTimer;


@end
