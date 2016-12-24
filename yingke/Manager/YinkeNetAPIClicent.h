//
//  YinkeNetAPIClicent.h
//  yingke
//
//  Created by Sino on 16/7/26.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef enum {
    Get = 0,
    Post,
    Put,
    Delete
} NetworkMethod;

@interface YinkeNetAPIClicent : AFHTTPSessionManager
+ (YinkeNetAPIClicent *)sharedJsonClient;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                  autoShowError:(BOOL)autoShowError
                       andBlock:(void (^)(id data, NSError *error))block;
@end
