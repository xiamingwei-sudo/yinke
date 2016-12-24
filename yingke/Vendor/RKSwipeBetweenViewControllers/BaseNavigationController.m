//
//  BaseNavigationController.m
//  Coding_iOS
//
//  Created by Ease on 15/2/5.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

#import "BaseNavigationController.h"

@implementation BaseNavigationController

//设置navigation背景
+ (void)initialize {
    
    if (self == [BaseNavigationController class]) {
        UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
        [bar setBackgroundImage:[UIImage imageNamed:@"navBar_bg_414x70"] forBarMetrics:UIBarMetricsDefault];
        
    }
}

- (BOOL)shouldAutorotate{
    return [self.visibleViewController shouldAutorotate];

}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (![self.visibleViewController isKindOfClass:[UIAlertController class]]) {//iOS9 UIWebRotatingAlertController
        return [self.visibleViewController supportedInterfaceOrientations];
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle {
        return UIStatusBarStyleLightContent;
//    return UIStatusBarStyleDefault;
}

#pragma mark ---- <非根控制器隐藏底部tabbar>
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
}
@end
