//
//  MW_TabBar.h
//  yingke
//
//  Created by Sino on 16/7/27.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MW_TabBar;
@protocol MW_TabBarDelegate <NSObject>

@optional
- (void)tabBar:(MW_TabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;
- (void)tabBarDidClickedPlusButton:(MW_TabBar *)tabBar;

@end


@interface MW_TabBar : UIView

- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@property (nonatomic, weak) id<MW_TabBarDelegate> delegate;

@end
