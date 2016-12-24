//
//  YinkeNetForMiaowManager.h
//  yingke
//
//  Created by 夏明伟 on 2016/11/3.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>


typedef enum {
    Get = 0,
    Post,
    Put,
    Delete
} NetworkMethod;
@interface YinkeNetForMiaowManager : AFHTTPSessionManager

+ (YinkeNetForMiaowManager *)shareManager;

/** 为所有的get请求添加缓存 */
- (void)requestJsonDataForGetWithPath:(NSString *)aPath withParams:(NSDictionary *)params
                 withMethodType:(NetworkMethod )methodType andBlock:(void (^)(id data,NSError *error))block;
@end
