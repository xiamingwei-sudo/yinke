//
//  NSObject+Common.m
//  yingke
//
//  Created by Sino on 16/7/26.
//  Copyright © 2016年 夏明伟. All rights reserved.
//
#define kPath_ImageCache @"ImageCache"
#define kPath_ResponseCache @"ResponseCache02"
#define kTestKey @"BaseURLIsTest"
#define kHUDQueryViewTag 101

#define YinkeGlobelToken @"yinkeappglobelkey"

#import "NSObject+Common.h"
#import "JDStatusBarNotification.h"
#import "MBProgressHUD+Add.h"
#import <SDCAlertView/SDCAlertController.h>

@implementation NSObject (Common)
#pragma mark Tip M
+ (NSString *)tipFromError:(NSError *)error{
    if (error && error.userInfo) {
        NSMutableString *tipStr = [[NSMutableString alloc] init];
        if ([error.userInfo objectForKey:@"msg"]) {
            NSArray *msgArray = [[error.userInfo objectForKey:@"msg"] allValues];
            NSUInteger num = [msgArray count];
            for (int i = 0; i < num; i++) {
                NSString *msgStr = [msgArray objectAtIndex:i];
                HtmlMedia *media = [HtmlMedia htmlMediaWithString:msgStr showType:MediaShowTypeAll];
                msgStr = media.contentDisplay;
                if (i+1 < num) {
                    [tipStr appendString:[NSString stringWithFormat:@"%@\n", msgStr]];
                }else{
                    [tipStr appendString:msgStr];
                }
            }
        }else{
            if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                tipStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            }else{
                [tipStr appendFormat:@"ErrorCode%ld", (long)error.code];
            }
        }
        return tipStr;
    }
    return nil;
}
+ (BOOL)showError:(NSError *)error{
    if ([JDStatusBarNotification isVisible]) {//如果statusBar上面正在显示信息，则不再用hud显示error
        NSLog(@"如果statusBar上面正在显示信息，则不再用hud显示error");
        return NO;
    }
    NSString *tipStr = [NSObject tipFromError:error];
    [NSObject showHudTipStr:tipStr];
    return YES;
}
+ (void)showHudTipStr:(NSString *)tipStr{
    if (tipStr && tipStr.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15.0];
        hud.detailsLabelText = tipStr;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.0];
    }
}
#pragma mark BaseURL
+ (NSString *)baseURLStr{
    NSString *baseURLStr;
    if ([self baseURLStrIsTest]) {
        //staging
        baseURLStr = kBaseUrlStr_Test;
    }else{
        //生产
        baseURLStr = @"https://coding.net/";
    }
    
    return baseURLStr;
}

+ (BOOL)baseURLStrIsTest{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    return [[defaults valueForKey:kTestKey] boolValue];
    return YES;
}
+ (id)loadResponseWithPath:(NSString *)requestPath{//返回一个NSDictionary类型的json数据
//    User *loginUser = [Login curLoginUser];
//    if (!loginUser) {
//        return nil;
//    }else{
        requestPath = [NSString stringWithFormat:@"%@_%@", YinkeGlobelToken, requestPath];
//    }
    NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kPath_ResponseCache], [requestPath md5Str]];
    NSData * data = [NSData dataWithContentsOfFile:abslutePath];
    return  [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

//获取fileName的完整地址
+ (NSString* )pathInCacheDirectory:(NSString *)fileName
{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    return [cachePath stringByAppendingPathComponent:fileName];
}

//网络请求缓存
+ (BOOL)saveResponseData:(NSDictionary *)data toPath:(NSString *)requestPath{
//    User *loginUser = [Login curLoginUser];
//    if (!loginUser) {
//        return NO;
//    }else{
        requestPath = [NSString stringWithFormat:@"%@_%@", YinkeGlobelToken, requestPath];
//    }
    if ([self createDirInCache:kPath_ResponseCache]) {
        NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kPath_ResponseCache], [requestPath md5Str]];
        
        return [data writeToPlistFile:abslutePath];
    }else{
        return NO;
    }
}

//创建缓存文件夹
+ (BOOL) createDirInCache:(NSString *)dirName
{
    NSString *dirPath = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    BOOL isCreated = NO;
    if ( !(isDir == YES && existed == YES) )
    {
        isCreated = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}
#pragma mark NetError
-(id)handleResponse:(id)responseJSON{
    return [self handleResponse:responseJSON autoShowError:YES];
}
-(id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError{
    NSError *error = nil;
    //code为非0值时，表示有错
    NSInteger errorCode = [(NSNumber *)[responseJSON valueForKeyPath:@"code"] integerValue];
    
    if (errorCode != 0) {
        error = [NSError errorWithDomain:[NSObject baseURLStr] code:errorCode userInfo:responseJSON];
        if (errorCode == 1000 || errorCode == 3207) {//用户未登录
          
            //更新 UI 要延迟 >1.0 秒，否则屏幕可能会不响应触摸事件。。暂不知为何
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                kTipAlert(@"%@", [NSObject tipFromError:error]);
            });
            
        }else{
            //错误提示
            if (autoShowError) {
                [NSObject showError:error];
            }
        }
    }
    return error;
}


@end
