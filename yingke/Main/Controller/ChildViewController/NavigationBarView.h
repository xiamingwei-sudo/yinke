//
//  NavigationBarView.h
//  Research
//
//  Created by pang on 15/2/3.
//  Copyright (c) 2015年 pang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationBarViewDelegate <NSObject>

@optional
-(void)summitBtnHaveClick;
- (void)backBtnHaveCLick;

@end

@interface NavigationBarView : UIView
{
    UIViewController * con;
    
}
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIButton * backBtn;
@property (nonatomic , strong)UIView *linView;
@property(nonatomic,strong)UIButton * summitBtn;
@property (nonatomic , strong)UIImageView *backImageV;

@property (nonatomic , weak)id<NavigationBarViewDelegate>delegate;


-(void)setController:(UIViewController *)controller;
- (void)setSummitBtnShow;
- (void)setSummitBtnEnabled;
- (void)setSummitBtnEnabledYES;

- (void)setSummitBtnChange:(NSString *)title;
@end
