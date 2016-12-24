//
//  YinkeNetForMiaowManager.m
//  yingke
//
//  Created by 夏明伟 on 2016/11/3.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "YinkeNetForMiaowManager.h"
#import "MiaowLiveModel.h"

#define kNetworkMethodName @[@"Get", @"Post", @"Put", @"Delete"]

@implementation YinkeNetForMiaowManager
static YinkeNetForMiaowManager *_sharedManager = nil;

+ (YinkeNetForMiaowManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [YinkeNetForMiaowManager manager];
        _sharedManager.requestSerializer.timeoutInterval = 5.0f;
        _sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    });
    return _sharedManager;
}

- (void)requestJsonDataForGetWithPath:(NSString *)aPath withParams:(NSDictionary *)params withMethodType:(NetworkMethod)methodType andBlock:(void (^)(id, NSError *))block{
    if (!aPath || aPath.length <=0) {
        return;
    }
    //log请求数据
    DebugLog(@"\n===========request===========\n%@\n%@:\n%@", kNetworkMethodName[methodType], aPath, params);
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = @{@"format":@"json"};
    params = [dic mutableCopy];
    switch (methodType) {
        case Get:{
            NSMutableString *localPath = [aPath mutableCopy];
            if (params) {
                [localPath appendString:params.description];
            }
            [self GET:aPath parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                DebugLog(@"-----progress:%@-----",downloadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                NSInteger errorCode = [(NSNumber *)[responseObject valueForKeyPath:@"code"] integerValue];
                if (errorCode !=100) {
                    NSError *error = [NSError errorWithDomain:aPath code:errorCode userInfo:responseObject];
                    // 如果出错，就获取缓存里的数据
                    responseObject = [NSObject loadResponseWithPath:localPath];
                    block(responseObject, error);
                }else{
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        // 缓存已请求的数据
                        if([NSObject saveResponseData:responseObject toPath:localPath] == NO){
                            DebugLog(@"缓存失败");
                        };
                    }
                    block(responseObject, nil);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                DebugLog(@"\n===========Failure_Response===========\n%@:\n%@\n%@", aPath, error, task.taskDescription);
                [NSObject showError:error];
                // 如果出错 ，就显示已缓存的数据
                id responseObject = [NSObject loadResponseWithPath:localPath];
                block(responseObject, error);
            }];
            break;}
        default:
            break;
    }
    
}

@end
