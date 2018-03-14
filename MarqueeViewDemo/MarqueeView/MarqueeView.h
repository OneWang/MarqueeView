//
//  MarqueeView.h
//  MarqueeView
//
//  Created by Wang on 15/10/28.
//  Copyright © 2015年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger,MarqueeViewOrientationStyle){
    MarqueeViewHorizontalStyle,
    MarqueeViewVerticalStyle,
};

@interface MarqueeView : UIView

/** 设置文字颜色 */
@property (strong, nonatomic) UIColor *textColor;
/**
 初始化方法
 @param frame 当滚动方式为竖直滚动的时候会将设置的frame自动切割为文字的高度,当滚动方式为水平滚动的时候则不会;
 @param title 滚动的内容
 @param fontSize 字体大小
 @param style 滚动样式
 @param interval 时长
 @return instancetype
 */
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withTextFontSize:(CGFloat)fontSize witTimeInteval:(NSInteger)interval withDirection:(MarqueeViewOrientationStyle)style;
/**
 开始
 */
- (void)start;

/**
 暂停
 */
- (void)stop;

@end
