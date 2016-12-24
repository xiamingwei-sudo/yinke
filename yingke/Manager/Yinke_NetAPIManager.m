//
//  Yinke_NetAPIManager.m
//  yingke
//
//  Created by Sino on 16/7/28.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "Yinke_NetAPIManager.h"
#import "YinkeNetAPIClicent.h"

@implementation Yinke_NetAPIManager

+(instancetype)shareManager{
    static Yinke_NetAPIManager *shared_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_manager = [[Yinke_NetAPIManager alloc]init];
        
    });
    return shared_manager;
}

- (void)requestGetHotDataWithPath:(NSString *)apth sucessBlock:(void(^)(id data,NSError *error))block{
    if (!apth || apth.length <=0) {
        return;
    }
     NSDictionary * dic = @{@"format":@"json"};
    [[YinkeNetAPIClicent sharedJsonClient]requestJsonDataWithPath:apth withParams:dic withMethodType:Get andBlock:^(id data, NSError *error) {
        
        block(data,error);
       
    }];
    
    
}

@end
