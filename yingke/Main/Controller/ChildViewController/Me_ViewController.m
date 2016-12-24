//
//  Me_ViewController.m
//  yingke
//
//  Created by Sino on 16/7/28.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "Me_ViewController.h"
#import <APParallaxHeader/UIScrollView+APParallaxHeader.h>
#import "EaseUserHeaderView.h"
//#import "StartImagesManager.h"
#import "CoverImageManager.h"
#import "UserInfoIconCell.h"
#import "MJPhotoBrowser.h"
#import "ViewController.h"
#import "NavigationBarView.h"
#import "SettingViewController.h"
#import "Tweet_RootViewController.h"

@interface Me_ViewController ()<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate , NavigationBarViewDelegate>

@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) EaseUserHeaderView *headerView;
@property (nonatomic , weak)NavigationBarView *bar;


@end

@implementation Me_ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    NavigationBarView *bar = [[NavigationBarView alloc]init];
    bar.titleLabel.text = @"我的";
    bar.delegate =self;
    bar.backgroundColor = [UIColor clearColor];
    [bar setSummitBtnChange:@"设置"];
    [bar setController:self];
    self.bar = bar;

//     [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settingBtn_Nav"] style:UIBarButtonItemStylePlain target:self action:@selector(settingBtnClicked:)] animated:NO];
    
    //    添加myTableView
    _myTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = kColorTableSectionBg;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
         [tableView registerClass:[UserInfoIconCell class] forCellReuseIdentifier:kCellIdentifier_UserInfoIconCell];
        [self.view addSubview:tableView];
         [tableView addObserver: self forKeyPath: @"contentOffset" options: NSKeyValueObservingOptionNew context:nil];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 60, 0);
        tableView.contentInset = insets;
        tableView.scrollIndicatorInsets = insets;
        
        tableView;
    });
    
    _headerView = [EaseUserHeaderView userHeaderViewWithUser:nil imageUrl:[CoverImageManager shareManager].currentCover.url];
     __weak typeof(self) weakSelf = self;
    _headerView.userIconClicked = ^(){
        [weakSelf userIconClick];
    };
    _headerView.bgImageClicked = ^(){
        [weakSelf headBgViewClick];
    };
    
    [_myTableView addParallaxWithView:_headerView andHeight:CGRectGetHeight(_headerView.frame)];
    [self.view bringSubviewToFront:bar];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }else if (section == 2){
        return 1;
    }
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoIconCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserInfoIconCell forIndexPath:indexPath];
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
    if (indexPath.section == 0) {
       [cell setTitle: @"详细信息" icon:@"user_info_detail"];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [cell setTitle: @"我的冒泡" icon:@"user_info_tweet"];
        }else if(indexPath.row == 1){
            [cell setTitle: @"我的项目" icon:@"user_info_project"];
        }else if (indexPath.row == 2){
            [cell setTitle:@"我的话题" icon:@"user_info_topic"];
        }else{
            [cell setTitle:@"本地文件" icon:@"user_info_file"];
        }
    }else{
         [cell setTitle:@"我的码币" icon:@"user_info_point"];
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 20.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0)
        return 20;
    return 0.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
    footerView.backgroundColor = kColorTableSectionBg;
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1){
        if (indexPath.row ==0) {
            Tweet_RootViewController *tweet = [[Tweet_RootViewController alloc]init];
            [self.navigationController pushViewController:tweet animated:YES];
        }

    }else{
        ViewController *hotVC = [[ViewController alloc]init];
        [self.navigationController pushViewController:hotVC animated:YES];
    }
  
}

#pragma mark button Click
- (void)userIconClick
{
    // 显示大图
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:@"http://pic.58pic.com/58pic/14/00/69/66858PICNfJ_1024.jpg"];
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0;
    browser.photos = [NSArray arrayWithObject:photo];
    [browser show];
}

- (void)headBgViewClick{
    // 显示大图
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:[CoverImageManager shareManager].currentCover.url];
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0;
    browser.photos = [NSArray arrayWithObject:photo];
    [browser show];
}

- (void)summitBtnHaveClick{
    SettingViewController *setVC = [[SettingViewController alloc]init];
    
    [self.navigationController pushViewController:setVC animated:YES];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    CGFloat offset=_myTableView.contentOffset.y;
    if (offset< -64.0f ) {
        [UIView animateWithDuration:0.3 animations:^{
           self.bar.backgroundColor = [UIColor clearColor];
            self.bar.backImageV.alpha = 0;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.bar.backImageV.alpha = 1;
            self.bar.backImageV.image = [UIImage imageNamed:@"navBar_bg_414x70"];
        }];
    }
}
// 注册这里是 willShowViewController 不是didShow
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[self class]]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else {
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
}

@end
