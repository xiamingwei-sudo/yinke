//
//  HotListViewController.m
//  yingke
//
//  Created by 夏明伟 on 2016/11/3.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "HotListViewController.h"
#import "PlayerTableViewCell.h"
#import "MW_RefreshGifHeader.h"
#import "YinkeNetForMiaowManager.h"
#import "MiaowLiveModel.h"
#import "TopADModel.h"
#import "TopADCell.h"
#import "PlayerViewController.h"
#import "MW_WebViewController.h"

#define Ratio 618/480

@interface HotListViewController ()<UITableViewDelegate , UITableViewDataSource>

/** 当前页 */
@property (nonatomic,assign)NSInteger currentPage;
/** 直播数据源 */
@property (nonatomic , strong)NSMutableArray *lives;
/** 广告 */
@property (nonatomic , strong)NSArray *topADs;

/** 列表 */
@property (nonatomic, strong)UITableView * tableView;
@end

static NSString *ADReuseIdentifier = @"MWHomeADCellID";
@implementation HotListViewController

- (NSMutableArray *)lives{
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    
    return _lives;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    
    
}
#pragma mark ---- <setupTableView>
- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-115) style:UITableViewStylePlain];
    [self.tableView registerClass:[TopADCell class] forCellReuseIdentifier:ADReuseIdentifier];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.rowHeight = [UIScreen mainScreen].bounds.size.width * Ratio + 1;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
   
    self.tableView.mj_header = [MW_RefreshGifHeader headerWithRefreshingBlock:^{
        self.lives = [NSMutableArray array];
        self.currentPage = 1;
        [self getTopAD];
        [self getHotLiveList];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getHotLiveList];
    }];
    [self.tableView.mj_header beginRefreshing];
   
}
- (void)getTopAD
{
    [[YinkeNetForMiaowManager shareManager]requestJsonDataForGetWithPath:@"http://live.9158.com/Living/GetAD" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        NSArray *result = data[@"data"];
        if ([self isNotEmpty:result]) {
            self.topADs = [TopADModel mj_objectArrayWithKeyValuesArray:result];
            [self.tableView reloadData];
        }
    }];
    
}

- (void)getHotLiveList{
    [[YinkeNetForMiaowManager shareManager]requestJsonDataForGetWithPath:[NSString stringWithFormat:@"http://live.9158.com/Fans/GetHotLive?page=%ld", self.currentPage] withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSArray *result = [MiaowLiveModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
        if ([self isNotEmpty:result]) {
            [self.lives addObjectsFromArray:result];
            [self.tableView reloadData];
        }else{
            // 恢复当前页
            self.currentPage--;
        }
        
    }];
}

#pragma mark ---- <数据源方法>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lives.count +1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        TopADCell *cell = [tableView dequeueReusableCellWithIdentifier:ADReuseIdentifier];
        if (self.topADs.count) {
            cell.topADArray = self.topADs;
            [cell setImageClickBlock:^(TopADModel *topAD) {
                if (topAD.link.length) {
                    //网页
                    MW_WebViewController *webVC = [MW_WebViewController webVCWithUrlStr:topAD.link];
                    [self.navigationController pushViewController:webVC animated:YES];
                }
            }];
        }
        return cell;
    }
    static NSString * cellIdentifier = @"cell";
    PlayerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[PlayerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MiaowLiveModel * playerModel = [self.lives objectAtIndex:indexPath.row-1];
    cell.playerModel = playerModel;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==0) {
        return 100 *(Ratio) +1;
    }else{
        return ([UIScreen mainScreen].bounds.size.width ) * (Ratio) +1 +65;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayerViewController * playerVc = [[PlayerViewController alloc] init];
    MiaowLiveModel *liveModel = self.lives[indexPath.row -1];
    // 直播url
    playerVc.liveUrl = liveModel.flv;
    // 直播图片
    playerVc.imageUrl = liveModel.bigpic;
    [self.navigationController pushViewController:playerVc animated:true];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
@end
