//
//  HotViewController.m
//  高仿映客
//
//  Created by JIAAIR on 16/7/2.
//  Copyright © 2016年 JIAAIR. All rights reserved.
//

#import "HotViewController.h"
//#import "PlayerViewController.h"
#import "PlayerTableViewCell.h"
#import "ODRefreshControl.h"

#import "PlayerModel.h"
#import "Yinke_NetAPIManager.h"
#import "SVPullToRefresh.h"
#import "PlayerViewController.h"

// 映客接口
#define MainData [NSString stringWithFormat:@"http://service.ingkee.com/api/live/gettop?imsi=&uid=17800399&proto=5&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_9.300000&count=5&multiaddr=1"]
#define Ratio 618/480
@interface HotViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic , assign)BOOL willLoadMore;

@end

@implementation HotViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    // 添加下拉刷新
    [self addRefresh];
 
    [self refreshLoad];
}

- (void)refreshLoad{
    _willLoadMore = NO;
    [self loadData];
}

- (void)loadMore{
    _willLoadMore = YES;
    [self loadData];
}
#pragma mark ---- <加载数据>
- (void)loadData {
    
    if (!_willLoadMore) {//刷新
        [self.dataArray removeAllObjects];
    }

    __weak __typeof(self)vc = self;
    [[Yinke_NetAPIManager shareManager]requestGetHotDataWithPath:MainData sucessBlock:^(id data, NSError *error) {
        [vc.tableView.infiniteScrollingView stopAnimating];
        NSArray *listArray = [data objectForKey:@"lives"];
        for (NSDictionary *dic in listArray) {
            
            PlayerModel *playerModel = [[PlayerModel alloc] initWithDictionary:dic];
            playerModel.city = dic[@"city"];
            playerModel.portrait = dic[@"creator"][@"portrait"];
            playerModel.name = dic[@"creator"][@"nick"];
            playerModel.online_users = [dic[@"online_users"] intValue];
            playerModel.url = dic[@"stream_addr"];
            [vc.dataArray addObject:playerModel];
        }
        [vc.tableView reloadData];
    }];
    
}



#pragma mark ---- <setupTableView>
- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-115) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = [UIScreen mainScreen].bounds.size.width * Ratio + 1;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    __weak typeof(self) weakSelf = self;
    [_tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    
}

#pragma mark ---- <添加下拉刷新>
- (void)addRefresh {
    ODRefreshControl *refreshController = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    refreshController.tintColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    [refreshController addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshController {
    
    double delayInSecinds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSecinds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [refreshController endRefreshing];
        [self refreshLoad];
    });
}

#pragma mark ---- <数据源方法>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell";
    PlayerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        
        cell = [[PlayerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PlayerModel * playerModel = [self.dataArray objectAtIndex:indexPath.row];
    cell.playerModel = playerModel;
    
    return cell;
    
    
}

#pragma mark ---- <点击跳转直播>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerViewController * playerVc = [[PlayerViewController alloc] init];
    PlayerModel * PlayerModel = self.dataArray[indexPath.row];
    // 直播url
    playerVc.liveUrl = PlayerModel.url;
    // 直播图片
    playerVc.imageUrl = PlayerModel.portrait;
    [self.navigationController pushViewController:playerVc animated:true];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

@end
