//
//  MW_TabBar.m
//  yingke
//
//  Created by Sino on 16/7/27.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "MW_TabBar.h"
#import "MW_TabBarButton.h"

@interface MW_TabBar ()

@property (nonatomic , weak)UIImageView *bgImageView;
@property (nonatomic , strong)NSMutableArray *tabBarButtons;
@property (nonatomic ,weak)UIButton *plusButton;
@property (nonatomic, weak) MW_TabBarButton *selectedButton;


@end


@implementation MW_TabBar
- (NSMutableArray *)tabBarButtons{
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat top = 40; // 顶端盖高度
        CGFloat bottom = 40 ; // 底端盖高度
        CGFloat left = 100; // 左端盖宽度
        CGFloat right = 100; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        UIImage *image = [UIImage imageNamed:@"tab_bg"];
        UIImage *TabBgImage = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
        UIImageView *bgimagV = [[UIImageView alloc]initWithFrame:self.bounds];
        bgimagV.image = TabBgImage;
        [self addSubview:bgimagV];
        
        self.bgImageView = bgimagV;
        // 添加一个加号按钮
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusButton setImage:[UIImage imageNamed:@"toolbar_live"] forState:UIControlStateNormal];
        [plusButton setImage:[UIImage imageNamed:@"toolbar_live"] forState:UIControlStateHighlighted];
       
        plusButton.bounds = CGRectMake(0, 0, plusButton.currentImage.size.width, plusButton.currentImage.size.height);
        [plusButton addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusButton];
        self.plusButton = plusButton;
    }
    
    return self;
}


- (void)plusButtonClick
{
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickedPlusButton:)]) {
        [self.delegate tabBarDidClickedPlusButton:self];
    }
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    // 1.创建按钮
    MW_TabBarButton *button = [[MW_TabBarButton alloc] init];
    [self addSubview:button];
    // 添加按钮到数组中
    [self.tabBarButtons addObject:button];
    
    // 2.设置数据
    button.item = item;
    
    // 3.监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    // 4.默认选中第0个按钮
    if (self.tabBarButtons.count == 1) {
        [self buttonClick:button];
    }
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(MW_TabBarButton *)button
{
    // 1.通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:(int)self.selectedButton.tag to:(int)button.tag];
    }
    
    // 2.设置按钮的状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整加号按钮的位置
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    self.plusButton.center = CGPointMake(w * 0.5, h * 0.55);
    self.bgImageView.frame = CGRectMake(0, 0, self.width, self.height);
    // 按钮的frame数据
    CGFloat buttonH = h;
    CGFloat buttonW = (w - self.plusButton.width)/2;
    CGFloat buttonY = 0;
    
    for (int index = 0; index<self.tabBarButtons.count; index++) {
        // 1.取出按钮
        MW_TabBarButton *button = self.tabBarButtons[index];
        
        // 2.设置按钮的frame
        CGFloat buttonX = index * buttonW -20;
        if (index > 0) {
            buttonX += (self.plusButton.width +40);
        }
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 3.绑定tag
        button.tag = index;
    }
}
@end
