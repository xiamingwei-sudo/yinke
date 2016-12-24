//
//  NavigationBarView.m
//  Research
//
//  Created by pang on 15/2/3.
//  Copyright (c) 2015年 pang. All rights reserved.
//

#import "NavigationBarView.h"

@implementation NavigationBarView

-(instancetype)init
{
    self = [super init];
    
    if (iOS7) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, self.frame.size.width - 120, 44)];
        self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 60, 44)];
//        self.linView = [[UIView alloc]initWithFrame:CGRectMake(0, 63, self.frame.size.width, 1)];
        
    }
    else
    {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60,0, self.frame.size.width - 120, 44)];
        self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
//        self.linView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
    }
    self.backImageV = [[UIImageView alloc]initWithFrame:self.frame];
    [self addSubview:self.backImageV];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:kNavTitleFontSize];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLabel];
    
    self.backBtn.backgroundColor = [UIColor clearColor];
    [self.backBtn setImage:[UIImage imageNamed:@"dingbufanhui"] forState:UIControlStateNormal];
    [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
    //    self.backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    self.backBtn.adjustsImageWhenHighlighted = NO;
    [self.backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backBtn];
    
    self.titleLabel.text = @"默认标题";

    [self setUPNavSummitBtnUnder];
//    self.linView.backgroundColor = [UIColor lightGrayColor];
//    self.linView.alpha = 0.5;
    [self addSubview:self.linView];
    return  self;
}

- (void)setUPNavSummitBtnUnder
{
    if (iOS7) {
        self.summitBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width -60,20, 60, 44)];
    }else{
        self.summitBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width -60, 20, 60, 44)];
    }
    self.summitBtn.backgroundColor = [UIColor clearColor];
    
    [self.summitBtn setTitle:@"提交" forState:UIControlStateNormal];
    //    self.summitBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    self.summitBtn.adjustsImageWhenHighlighted = NO;
    [self.summitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.summitBtn setTitleColor:[UIColor colorWithWhite:0.800 alpha:1.000] forState:UIControlStateDisabled];
    [self.summitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.summitBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.summitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:kNavTitleFontSize];
    [self addSubview:self.summitBtn];
    self.summitBtn.hidden = YES;
}
-(void)setController:(UIViewController *)controller
{
    [controller.view addSubview:self];
    con = controller;
    if (controller.navigationController.viewControllers.count < 2) {
        self.backBtn.hidden = YES;
    }
    
}
- (void)setSummitBtnShow
{
    self.summitBtn.hidden = NO;
}

- (void)setSummitBtnEnabled{
    self.summitBtn.enabled = NO;
}

- (void)setSummitBtnEnabledYES{
    self.summitBtn.enabled = YES;
}

- (void)setSummitBtnChange:(NSString *)title
{
    self.summitBtn.hidden = NO;
    [self.summitBtn setTitle:title forState:UIControlStateNormal];
}
- (void)dismiss
{
    if ([self.delegate respondsToSelector:@selector(summitBtnHaveClick)]) {
        [self.delegate performSelector:@selector(summitBtnHaveClick)];
    }
}

-(void)back
{
    if ([self.delegate respondsToSelector:@selector(backBtnHaveCLick)]) {
        [self.delegate performSelector:@selector(backBtnHaveCLick)];
    }
    [con.navigationController popViewControllerAnimated:YES];
    self.titleLabel = nil;
    self.backBtn = nil;
    con = nil;
    self.delegate = nil;
}

- (void)dealloc
{
    NSLog(@"navigationBar 已dealloc");
}

@end
