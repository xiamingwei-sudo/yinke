//
//  YinkeNetAPIClicent.m
//  yingke
//
//  Created by Sino on 16/7/26.
//  Copyright © 2016年 夏明伟. All rights reserved.
//
#define kNetworkMethodName @[@"Get", @"Post", @"Put", @"Delete"]
#import "YinkeNetAPIClicent.h"

@implementation YinkeNetAPIClicent

static YinkeNetAPIClicent *_sharedClient = nil;
static dispatch_once_t onceToken;
+ (YinkeNetAPIClicent *)sharedJsonClient {
    dispatch_once(&onceToken, ^{
        _sharedClient = [[YinkeNetAPIClicent alloc] initWithBaseURL:[NSURL URLWithString:[NSObject baseURLStr]]];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    /**
     * 初始化IP
     */
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    self.responseSerializer = [AFJSONResponseSerializer serializer];
//    设置超时时间
    self.requestSerializer.timeoutInterval = 20.0f;
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    
    return self;
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block{
    [self requestJsonDataWithPath:aPath withParams:params withMethodType:method autoShowError:YES andBlock:block];
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                  autoShowError:(BOOL)autoShowError
                       andBlock:(void (^)(id data, NSError *error))block{
    if (!aPath || aPath.length <= 0) {
        return;
    }
    //log请求数据
    DebugLog(@"\n===========request===========\n%@\n%@:\n%@", kNetworkMethodName[method], aPath, params);
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 发起请求
    switch (method) {
        case Get:{
            //所有 Get 请求，增加缓存机制
            NSMutableString *localPath = [aPath mutableCopy];
            if (params) {
                [localPath appendString:params.description];
            }
            [self GET:aPath parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                DebugLog(@"-----progress:%@-----",downloadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    // 如果出错，就获取缓存里的数据
                    responseObject = [NSObject loadResponseWithPath:localPath];
                    block(responseObject, error);
                }else{
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        //判断数据是否符合预期，给出提示
                        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                            if (responseObject[@"data"][@"too_many_files"]) {
                                if (autoShowError) {
                                    [NSObject showHudTipStr:@"文件太多，不能正常显示"];
                                }
                            }
                        }
                        // 缓存已请求的数据
                        [NSObject saveResponseData:responseObject toPath:localPath];
                    }
                    block(responseObject, nil);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                DebugLog(@"\n===========Failure_Response===========\n%@:\n%@\n%@", aPath, error, task.taskDescription);
                !autoShowError || [NSObject showError:error];
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
