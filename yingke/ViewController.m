//
//  ViewController.m
//  yingke
//
//  Created by Sino on 16/7/26.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // left
    self.parentViewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"card_search"] highImage:[UIImage imageNamed:@"card_search"] target:self action:@selector(search:)];
    
    // right
    self.parentViewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"card_message"] highImage:[UIImage imageNamed:@"card_message"] target:self action:@selector(message)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)search:(id)sender{
    DebugLog(@"搜索");
    SearchViewController *searchVc = [[SearchViewController alloc] init];
    
    [self.navigationController pushViewController:searchVc animated:YES];
}
- (void)message{
    ViewController *vc = [[ViewController alloc]init];
   
    [self.navigationController pushViewController:vc animated:YES];
}


@end
