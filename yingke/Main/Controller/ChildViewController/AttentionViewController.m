//
//  AttentionViewController.m
//  高仿映客
//
//  Created by JIAAIR on 16/7/2.
//  Copyright © 2016年 JIAAIR. All rights reserved.
//

#import "AttentionViewController.h"

@interface AttentionViewController ()

@end

@implementation AttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome_1"]];
    imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.height - 50);
    [self.view addSubview:imageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
