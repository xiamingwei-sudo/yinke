//
//  AppDelegate.m
//  yingke
//
//  Created by Sino on 16/7/26.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "EasyStartView.h"

#import "ViewController.h"

#import "MainTabBarViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma lifeCycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //网络
    [[AFNetworkActivityIndicatorManager sharedManager]setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    //sd加载的数据类型
    [[[SDWebImageManager sharedManager] imageDownloader] setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [self customizeInterface];
   
    // show Root
 
    self.window.rootViewController = [[MainTabBarViewController alloc]init];

    [self.window makeKeyAndVisible];

    EasyStartView *startView = [EasyStartView startView];
    [startView startAnimationWithCompletionBlock:^(EasyStartView *easeStartView) {
    }];

    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
}
- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)customizeInterface {
    //设置状态栏属性(还要在info,plist文件中设置View controller-based status bar appearance = NO)
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //设置Nav的背景色和title色
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
//    [navigationBarAppearance setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:[NSObject baseURLStrIsTest]? @"0x3bbd79" : @"0x28303b"]] forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];//返回按钮的箭头颜色
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     };
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    
    [[UITextField appearance] setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];//设置UITextField的光标颜色
    [[UITextView appearance] setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];//设置UITextView的光标颜色
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:kColorTableSectionBg] forBarPosition:0 barMetrics:UIBarMetricsDefault];
}
@end
