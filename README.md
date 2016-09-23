###简单的跑马灯文字效果
	可支持左右移动和上下移动
	通过两个 label 的偏移来实现动画的无缝衔接
	
###注意:
	在设置为上下滚动的时候,滚动文字的宽度是和文字的大小有关的,在设置 label 的 frame 是没有作用的!
	
###使用方法:
```
self.marquee = [[MarqueeView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100) withTitle:@"拿啥啥便宜 买啥～～ " withDirection:MarqueeViewVerticalStyle];

self.marquee.backgroundColor = [UIColor purpleColor];
[self.view addSubview:self.marquee];


///修改滚动速度可以在.m中设置
///控制滚动速度;数值越大速度越快
#define ratio 2
```