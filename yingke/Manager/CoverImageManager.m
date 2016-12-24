//
//  CoverImageManager.m
//  yingke
//
//  Created by Sino on 16/7/29.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "CoverImageManager.h"
#import "YinkeNetAPIClicent.h"

@interface CoverImageManager()

@property (nonatomic , strong)CoverImag *coverImag;
@end


@implementation CoverImageManager
+ (instancetype)shareManager{
    static CoverImageManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[CoverImageManager alloc]init];
    });
    
    return shareManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createFolder:[self downloadPath]];
    }
    return self;
}

- (BOOL)createFolder:(NSString *)path{
    BOOL isDir = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL existed = [fm fileExistsAtPath:path isDirectory:&isDir];//// isDir判断是否为文件夹
    BOOL isCreated = NO;
    if (!(isDir = YES && existed ==YES)) {
        isCreated = [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        isCreated = YES;
    }
    if (isCreated) {
        [NSURL addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path isDirectory:YES]];
    }
    return isCreated;
}
- (NSString *)downloadPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *downloadPth = [documentPath stringByAppendingPathComponent:@"Yinke_CoverImag"];
    return downloadPth;
}

- (void)startDownloadImage:(NSString *)path{
    CoverImag *newItem = [[CoverImag alloc]init];
    newItem.url = path;
    if ([self createFolder:[self downloadPath]]) {
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:newItem.pathDisk]) {
            [newItem startDownloadImage];
        }
    }
    
    _coverImag = newItem;
}

- (CoverImag *)currentCover{
    
    [self startDownloadImage:@"http://pic33.nipic.com/20131009/13623653_184958067345_2.jpg"];
    
    return _coverImag;
    
}

@end


@implementation CoverImag

- (NSString *)fileName{
    if (!_fileName && _url.length > 0) {
        _fileName = [[_url componentsSeparatedByString:@"/"] lastObject];
    }
    return _fileName;
}
- (NSString *)pathDisk{
    if (!_pathDisk && _url) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _pathDisk = [[documentPath
                      stringByAppendingPathComponent:@"Yinke_CoverImag"]
                     stringByAppendingPathComponent:[[_url componentsSeparatedByString:@"/"] lastObject]];
    }
    return _pathDisk;
}
- (UIImage *)image{
    return [UIImage imageWithContentsOfFile:self.pathDisk];
}
- (void)startDownloadImage{
    if (![AFNetworkReachabilityManager sharedManager].reachableViaWiFi) {
        return;
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *pathDisk = [[documentPath stringByAppendingPathComponent:@"Yinke_CoverImag"] stringByAppendingPathComponent:[response suggestedFilename]];
        return [NSURL fileURLWithPath:pathDisk];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        DebugLog(@"downloaded file_path is to: %@", filePath);
    }];
    [downloadTask resume];
}
@end
