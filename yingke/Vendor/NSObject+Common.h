//
//  NSObject+Common.h
//  yingke
//
//  Created by Sino on 16/7/26.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)
+ (NSString *)baseURLStr;
+ (BOOL)baseURLStrIsTest;

+ (BOOL)showError:(NSError *)error;
+ (void)showHudTipStr:(NSString *)tipStr;

+ (id)loadResponseWithPath:(NSString *)requestPath;
+ (NSString* )pathInCacheDirectory:(NSString *)fileName;

//网络请求缓存
+ (BOOL)saveResponseData:(NSDictionary *)data toPath:(NSString *)requestPath;
//创建缓存文件夹
+ (BOOL) createDirInCache:(NSString *)dirName;
#pragma mark NetError
-(id)handleResponse:(id)responseJSON;
-(id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError;
@end
