//
//  Yinke_NetAPIManager.h
//  yingke
//
//  Created by Sino on 16/7/28.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Yinke_NetAPIManager : NSObject

+(instancetype)shareManager;
- (void)requestGetHotDataWithPath:(NSString *)apth sucessBlock:(void(^)(id data,NSError *error))block;
@end
