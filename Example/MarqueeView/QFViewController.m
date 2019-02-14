//
//  QFViewController.m
//  MarqueeView
//
//  Created by OneWang on 02/14/2019.
//  Copyright (c) 2019 OneWang. All rights reserved.
//

#import "QFViewController.h"
#import <MarqueeView/MarqueeView.h>

@interface QFViewController ()
@property (weak, nonatomic) MarqueeView *marquee;
@end

@implementation QFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MarqueeView *marquee = [[MarqueeView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100) withTitle:@"拿啥啥便宜 买啥～～ " withTextFontSize:20 witTimeInteval:2 withDirection:MarqueeViewVerticalStyle];
    self.marquee = marquee;
    self.marquee.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.marquee];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.view.frame.size.width-100)/2, 200, 100, 50);
    [button addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"停止" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:button];
    
    UIButton *buttona = [UIButton buttonWithType:UIButtonTypeCustom];
    buttona.frame = CGRectMake((self.view.frame.size.width-100)/2, 300, 100, 50);
    [buttona addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [buttona setTitle:@"开始" forState:UIControlStateNormal];
    [buttona setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:buttona];
}

- (void)stop:(UIButton*)sender
{
    [self.marquee stop];
}

- (void)start:(UIButton*)sender
{
    [self.marquee start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
