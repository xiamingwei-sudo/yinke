//
//  SettingViewController.m
//  yingke
//
//  Created by 夏明伟 on 2016/10/19.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "SettingViewController.h"
#import "UserInfoIconCell.h"
#import "YinkeShareView.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic ,strong)UITableView *listTab;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    _listTab = ({
        UITableView *tab = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tab.backgroundColor = kColorTableSectionBg;
        tab.dataSource = self;
        tab.delegate = self;
        tab.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tab registerClass:[UserInfoIconCell class] forCellReuseIdentifier:kCellIdentifier_UserInfoIconCell];
        [self.view addSubview:tab];
        [tab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        tab;
    
    });
}
- (void)dealloc{
    _listTab.delegate = nil;
    _listTab.dataSource = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = (section == 1? 3:
                     section == 3? 2:
                     1);
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserInfoIconCell forIndexPath:indexPath ];
    NSString *titleStr = (indexPath.section ==0 ? @"账号设置":
                          indexPath.section == 1? (indexPath.row == 0 ? @"意见反馈" :
                                                   indexPath.row == 1 ? @"去评分" :
                                                   @"推荐 我的映客"
                                                   ):
                          indexPath.section == 2? @"清除缓存":
                          indexPath.row == 0 ? @"帮助中心" : @"关于我的映客"
                          );
    
    [(UserInfoIconCell *)cell setTitle:titleStr icon:@"user_info_topic" ];
    
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
    headerView.backgroundColor = kColorTableSectionBg;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            [YinkeShareView showShareViewWIthObj:nil];
        }
    }
    
    
}
@end
