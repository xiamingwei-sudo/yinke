//
//  MainTabBarViewController.m
//  yingke
//
//  Created by Sino on 16/7/27.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "MW_TabBar.h"
#import "ViewController.h"
#import "RKSwipeBetweenViewControllers.h"
#import "AttentionViewController.h"
//#import "HotViewController.h"
#import "HotListViewController.h"
#import "NewViewController.h"
#import "CameraViewController.h"
#import "Me_ViewController.h"

@interface MainTabBarViewController ()<MW_TabBarDelegate>
/**
 *  自定义的tabbar
 */
@property (nonatomic, weak) MW_TabBar *customTabBar;
@end

@implementation MainTabBarViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化tabbar
    [self setupTabbar];
    
    [self setupAllChildViewControllers];
}
/**
 *  初始化tabbar
 */
- (void)setupTabbar
{
    [self LayoutTabBarViews];
    MW_TabBar *customTabBar = [[MW_TabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
    
    [self setupTabBarBackgroundImage];
}

#pragma mark ---- 去掉分割线
- (void)setupTabBarBackgroundImage {
    
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
}

//自定义TabBar高度
- (void)LayoutTabBarViews {
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 60;
    tabFrame.origin.y = self.view.frame.size.height - 60;
    self.tabBar.frame = tabFrame;
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 60;
    tabFrame.origin.y = self.view.frame.size.height - 60;
    self.tabBar.frame = tabFrame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tabbar的代理方法
/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(MW_TabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to
{
    self.selectedIndex = to;
   
}

/**
 *  监听加号按钮点击
 */
- (void)tabBarDidClickedPlusButton:(MW_TabBar *)tabBar
{
    CameraViewController *cameraVc = [[CameraViewController alloc] init];
    [self presentViewController:cameraVc animated:YES completion:nil];
}

/**
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers
{
    // 1.首页
    ViewController *home = [[ViewController alloc] init];

    [self setupChildViewController:home title:@"首页" imageName:@"toolbar_home" selectedImageName:@"toolbar_home_sel"];
    
    // 1.设置
    Me_ViewController *setting = [[Me_ViewController alloc] init];
    [self setupChildViewController:setting title:@"我的" imageName:@"toolbar_me" selectedImageName:@"toolbar_me_sel"];

}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (iOS7) {
        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = selectedImage;
    }
    
//    // 2.包装一个导航控制器
    if ([title isEqualToString:@"首页"] ) {
        RKSwipeBetweenViewControllers *nav_tweet = [RKSwipeBetweenViewControllers newSwipeBetweenViewControllers];
        AttentionViewController *chiledVC02 = [[AttentionViewController alloc]init];
        HotListViewController *chiledVC03 = [[HotListViewController alloc]init];
        NewViewController *chiledVC04 = [[NewViewController alloc]init];
        [nav_tweet.viewControllerArray addObjectsFromArray:@[chiledVC02,
                                                             chiledVC03,
                                                             chiledVC04]];
        nav_tweet.buttonText = @[@"关  注", @"热  门", @"最  新"];
        [self addChildViewController:nav_tweet];
    }else{
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:childVc];
//        childVc.navigationController.navigationBar.hidden = YES;
        [self addChildViewController:nav];
    }
//     childVc.tabBarItem.badgeValue = @"33";
    
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

@end
