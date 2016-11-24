//
//  MarqueeView.m
//  MarqueeView
//
//  Created by Wang on 15/10/28.
//  Copyright © 2015年 Wang. All rights reserved.
//

#import "MarqueeView.h"

///控制滚动速度;数值越大速度越快
#define ratio 2
///显示文字的字体大小
#define MarqueeViewFontOfSize 17

@interface MarqueeView()
{
    //当前label的frame
    CGRect currentFrame;
    //后面label的frame
    CGRect behindFrame;
    //是否为暂停状态
    BOOL isStop;
    //单次循环的时间
    NSInteger time;
}
//存放左右label的数组
@property (strong, nonatomic) NSMutableArray *labelArray;

//展示的内容视图
@property (weak, nonatomic) UIView *contentView;

@end

@implementation MarqueeView

#pragma mark - 懒加载
- (NSMutableArray *)labelArray
{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withTextFontSize:(CGFloat)fontSize withDirection:(MarqueeViewOrientationStyle)style
{
    if (self = [super initWithFrame:frame]) {

        UIView *content = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        content.clipsToBounds = YES;
        self.contentView = content;
        content.backgroundColor = [UIColor blueColor];
        [self addSubview: self.contentView];
        
        CGFloat viewHeight = frame.size.height;
        CGFloat viewWidth = frame.size.width;
        //label的高度
        CGFloat labelHeight = viewHeight;
        //label的宽度
        CGFloat labelWidth = viewWidth;

        //循环的时间这里取的是4 此数越大速度越快
        time = title.length/ratio;
        
        UILabel *myLable = [[UILabel alloc]init];
        myLable.numberOfLines = 0;
        myLable.text = title;
//        myLable.font = [UIFont systemFontOfSize:MarqueeViewFontOfSize];
        myLable.font = [UIFont systemFontOfSize:fontSize];
        
        //计算文本的宽度
//        CGFloat textWidth = [self widthForTextString:title height:labelHeight fontSize:MarqueeViewFontOfSize];
        CGFloat textWidth = [self widthForTextString:title height:labelHeight fontSize:fontSize];
        //这两个frame很重要 分别记录的是左右两个label的frame 而且后面也会需要到这两个frame
        currentFrame = CGRectMake(0, 0, textWidth, labelHeight);
        if (style == MarqueeViewHorizontalStyle) {
            //如果文本的宽度小于等于视图的宽度时, label 的宽度和 view 的宽度大小一样
            if (textWidth <= frame.size.width){
                currentFrame = CGRectMake(0, 0, labelWidth, labelHeight);
                behindFrame = CGRectMake(currentFrame.origin.x + currentFrame.size.width, 0, labelWidth, labelHeight);
            }else{
                behindFrame = CGRectMake(currentFrame.origin.x + currentFrame.size.width, 0, textWidth, labelHeight);
            }
        }else{
//            CGFloat textHeight = [self heightForTextString:title width:labelWidth fontSize:MarqueeViewFontOfSize];
            CGFloat textHeight = [self heightForTextString:title width:labelWidth fontSize:fontSize];
            currentFrame = CGRectMake(0, 0, labelWidth, textHeight);
            behindFrame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y + currentFrame.size.height, labelWidth, textHeight);
            //当使用竖直滚动的时候 frame 的高度设置为文字的高度;外部设置不起作用;
            CGRect rect = self.frame;
            rect.size.height = textHeight;
            self.frame = rect;
            
            CGRect contentRect = self.contentView.frame;
            contentRect.size.height = textHeight;
            self.contentView.frame = contentRect;
        }
        myLable.frame = currentFrame;
        [self.contentView addSubview:myLable];
        [self.labelArray addObject:myLable];
        
        UILabel *behindLabel = [[UILabel alloc]init];
        behindLabel.numberOfLines = 0;
        behindLabel.frame = behindFrame;
        behindLabel.text = title;
//        behindLabel.font = [UIFont systemFontOfSize:MarqueeViewFontOfSize];
        behindLabel.font = [UIFont systemFontOfSize:fontSize];
        [self.labelArray addObject:behindLabel];
        [self.contentView addSubview:behindLabel];
        [self doAnimationWithDirection:style];
    }
    return self;
}

- (void)doAnimationWithDirection:(MarqueeViewOrientationStyle)style
{
    //取到两个label
    UILabel *lableOne = self.labelArray[0];
    UILabel *lableTwo = self.labelArray[1];
    //UIViewAnimationOptionCurveLinear是为了让lable做匀速动画
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    
        //让两个label向左平移
        if (style == MarqueeViewHorizontalStyle) {
            lableOne.transform = CGAffineTransformMakeTranslation(-currentFrame.size.width, 0);
            lableTwo.transform = CGAffineTransformMakeTranslation(-currentFrame.size.width, 0);
        }else{
            lableOne.transform = CGAffineTransformMakeTranslation(0, -currentFrame.size.height);
            lableTwo.transform = CGAffineTransformMakeTranslation(0, -currentFrame.size.height);
        }
    } completion:^(BOOL finished) {
        //两个label水平相邻摆放 内容一样 label1为初始时展示的 label2位于界面的右侧，未显示出来
        //当完成动画时，即第一个label在界面中消失，第二个label位于第一个label的起始位置时，把第一个label放置到第二个label的初始位置
        lableOne.transform = CGAffineTransformIdentity;
        lableOne.frame = behindFrame;

        lableTwo.transform = CGAffineTransformIdentity;
        lableTwo.frame = currentFrame;
        
        //在数组中将第一个label放置到右侧，第二个label放置到左侧（因为此时展示的就是labelTwo）
        [self.labelArray replaceObjectAtIndex:1 withObject:lableOne];
        [self.labelArray replaceObjectAtIndex:0 withObject:lableTwo];
        
        //递归调用
        [self doAnimationWithDirection:style];
    }];
}

//计算文字的宽度
- (CGFloat)widthForTextString:(NSString *)str height:(CGFloat)tHeight fontSize:(CGFloat)tSize{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:tSize]};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, tHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width + 5;
}
//计算文字的高度
- (CGFloat)heightForTextString:(NSString *)str width:(CGFloat)tWidth fontSize:(CGFloat)tSize{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:tSize]};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(tWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.height + 5;
}

- (void)start
{
    UILabel *lableOne = self.labelArray[0];
    [self resumeLayer:lableOne.layer];
    
    UILabel *lableTwo = self.labelArray[1];
    [self resumeLayer:lableTwo.layer];
    
    isStop = NO;
}

- (void)stop
{
    UILabel *lableOne = self.labelArray[0];
    [self pauseLayer:lableOne.layer];
    
    UILabel *lableTwo = self.labelArray[1];
    [self pauseLayer:lableTwo.layer];
    
    isStop = YES;
}

//暂停动画
- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    layer.speed = 0;
    
    layer.timeOffset = pausedTime;
}

//恢复动画
- (void)resumeLayer:(CALayer*)layer
{
    //当你是停止状态时，则恢复
    if (isStop) {
        CFTimeInterval pauseTime = [layer timeOffset];
        
        layer.speed = 1.0;
        
        layer.timeOffset = 0.0;
        
        layer.beginTime = 0.0;
        
        CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
        
        layer.beginTime = timeSincePause;
    }
}

@end
