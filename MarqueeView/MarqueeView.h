//
//  MarqueeView.h
//  MarqueeView
//
//  Created by Wang on 16/09/18.
//  Copyright © 2015年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger,MarqueeViewOrientationStyle){
    MarqueeViewHorizontalStyle,
    MarqueeViewVerticalStyle,
};

@interface MarqueeView : UIView

///初始化
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withDirection:(MarqueeViewOrientationStyle)style;
///开始
- (void)start;
///停止
- (void)stop;

@end
