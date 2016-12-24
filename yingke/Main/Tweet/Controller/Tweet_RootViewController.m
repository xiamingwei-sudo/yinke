//
//  Tweet_RootViewController.m
//  yingke
//
//  Created by 夏明伟 on 2016/11/21.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "Tweet_RootViewController.h"
#import "SMPageControl.h"

@interface Tweet_RootViewController ()<UIScrollViewDelegate >

@property (nonatomic , strong)UIScrollView *scrollView;

@property (nonatomic , strong)SMPageControl *pageControl;
@property (nonatomic , strong)UIView *navigationBarView;

@property (nonatomic , strong)NSArray *navTitles;
@end

@implementation Tweet_RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.navigationBarView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationBarView removeFromSuperview];
}

#pragma mark --scrollSetting

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateNavItems:scrollView.contentOffset.x];
    
    float mid   = [UIScreen mainScreen].bounds.size.width/2 - 45.0;
    float width = [UIScreen mainScreen].bounds.size.width;
    CGFloat xOffset = scrollView.contentOffset.x;
    DebugLog(@"********%f",xOffset);
    int i = 0;
    for(UILabel *v in _navTitles){
        CGFloat alpha = 0.0;
        if(v.frame.origin.x < mid)
            alpha = 1 - (xOffset - i*width) / width;
        else if(v.frame.origin.x >mid)
            alpha=(xOffset - i*width) / width + 1;
        else if(v.frame.origin.x == mid-5)
            alpha = 1.0;
        i++;
        v.alpha = alpha;
    }

    
}

-(void)updateNavItems:(CGFloat) xOffset{
    __block int i = 0;
    [_navTitles enumerateObjectsUsingBlock:^(UIView* v, NSUInteger idx, BOOL *stop) {
        CGFloat distance = (kScreen_Width/2) - 60;
        CGSize vSize     = CGSizeMake(100, 16);
        CGFloat originX  = ((kScreen_Width/2 - vSize.width/2) + i*distance) - xOffset/(kScreen_Width/distance);
        v.frame          = (CGRect){originX, 8, vSize.width, vSize.height};
        i++;
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self sendNewIndex:scrollView];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self sendNewIndex:scrollView];
}

-(void)sendNewIndex:(UIScrollView *)scrollView{
    CGFloat xOffset    = scrollView.contentOffset.x;
    NSInteger index = ((int) roundf(xOffset) % (self.navTitles.count * (int)kScreen_Width)) / kScreen_Width;
    
    if (self.pageControl.currentPage != index)
    {
        self.pageControl.currentPage = index;
    }
}
- (void)setupUI{
    self.navigationItem.title = @"";
    UILabel *la1 = [self setupNavlabelWithTitle:@"冒泡广场" andIndex:0 alpha:1];
    UILabel *la2 = [self setupNavlabelWithTitle:@"朋友圈" andIndex:1 alpha:0];
    UILabel *la3 = [self setupNavlabelWithTitle:@"热门冒泡" andIndex:2 alpha:0];
   
    _navTitles = @[la1,la2,la3];
    
    CGRect frame = CGRectMake(0, 0, kScreen_Width, self.view.bounds.size.height);
    self.scrollView = [[UIScrollView alloc]initWithFrame:frame];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.scrollView .clipsToBounds = YES;
    self.scrollView.contentSize = CGSizeMake(kScreen_Width * self.navTitles.count, 0);

    
    _navigationBarView                 = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreen_Width, 44}];
    _navigationBarView.backgroundColor = [UIColor clearColor];
    
    // Make the page control
    self.pageControl = ({
        SMPageControl *pgC = [[SMPageControl alloc] init];
        pgC.userInteractionEnabled = NO;
        pgC.backgroundColor = [UIColor clearColor];
        pgC.pageIndicatorImage = [UIImage imageNamed:@"nav_page_unselected"];
        pgC.currentPageIndicatorImage = [UIImage imageNamed:@"nav_page_selected"];
        pgC.frame = CGRectMake(0, 32.0, kScreen_Width, 7.0);
        pgC.numberOfPages = _navTitles.count;
        pgC.currentPage = 0;
        pgC;
    });
    
    _navigationBarView.userInteractionEnabled = NO;
    [_navigationBarView addSubview:self.pageControl];
    
    [_navigationBarView addSubview:la1];
    [_navigationBarView addSubview:la2];
    [_navigationBarView addSubview:la3];
    
    UIView *hotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.view.height - 50)];
    hotView.backgroundColor = [UIColor redColor];
    
    UIView *friendView = [[UIView alloc]initWithFrame:CGRectMake(kScreen_Width+1, 0, kScreen_Width, self.view.height - 50)];
    friendView.backgroundColor = [UIColor greenColor];
    
    [self.scrollView addSubview:hotView];
    [self.scrollView addSubview:friendView];
}
- (UILabel *)setupNavlabelWithTitle:(NSString *)tit andIndex:(NSInteger)index alpha:(BOOL)alpha{
    CGFloat titleWidth = 100;
    CGFloat distance = (kScreen_Width/2) - 60;
    UILabel *la2 = [[UILabel alloc] initWithFrame:CGRectMake((kScreen_Width/2 - titleWidth/2) + index*distance, 8, titleWidth, 16)];
    la2.text = tit;
    la2.textAlignment = NSTextAlignmentCenter;
    la2.font = [UIFont boldSystemFontOfSize:18];
    la2.textColor = [UIColor whiteColor];
    
    la2.alpha = alpha;
    return la2;
}

@end
