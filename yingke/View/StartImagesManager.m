//
//  StartImagesManager.m
//  yingke
//
//  Created by Sino on 16/7/26.
//  Copyright © 2016年 夏明伟. All rights reserved.
//
#define kStartImageName @"start_image_name"
#import "StartImagesManager.h"
#import "YinkeNetAPIClicent.h"

@interface StartImagesManager ()
@property (nonatomic ,strong)NSMutableArray *imageLoadArray;
@property (nonatomic , strong)StartImage *startImage;


@end

@implementation StartImagesManager

+ (instancetype)shareManager{
    static StartImagesManager *shareManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareManager = [[self alloc]init];
    });
    
    return shareManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createFolder:[self downloadPath]];
        [self loadStartImages];
    }
    return self;
    
}

- (BOOL)createFolder:(NSString *)path{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    BOOL isCreated = NO;
    if (!(isDir == YES && existed == YES)) {
        isCreated = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        isCreated = YES;
    }
    if (isCreated) {
        [NSURL addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path isDirectory:YES]];
    }
    return isCreated;
    
}

- (NSString *)downloadPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *downloadPath = [documentPath stringByAppendingPathComponent:@"Coding_StartImages"];
    return downloadPath;
}
- (StartImage *)randomImage{
    if ([NSDate isDuringMidAutumn]) {
        _startImage = [StartImage midAutumnImage];
    }else{
        NSUInteger count = _imageLoadArray.count;
        if (count > 0) {
            NSUInteger index = arc4random()%count;
            _startImage = [_imageLoadArray objectAtIndex:index];
        }else{
            _startImage = [StartImage defautImage];
        }
    }
    
    [self saveDisplayImageName:_startImage.fileName];
    [self refreshImagesPlist];// 刷新图片
    return _startImage;
}

#pragma mark loadImag
- (void)loadStartImages{
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:[self pathOfSTPlist]];
    plistArray = [NSObject arrayFromJSON:plistArray ofObjects:@"StartImage"];
    NSMutableArray *loadImageArray = [[NSMutableArray alloc]init];
    NSFileManager *fm = [NSFileManager defaultManager];
    for (StartImage *curST in plistArray) {
        if ([fm fileExistsAtPath:curST.pathDisk]) {
            [loadImageArray addObject:curST];
        }
    }
    // 得到已经显示过得图片名
    NSString *preDisPlayName = [self getDisplayImageName];
    if (preDisPlayName && preDisPlayName.length>0) {
        NSInteger index = [loadImageArray indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[(StartImage*)obj fileName]isEqualToString:preDisPlayName]) {
                *stop = YES;
                return YES;
            }
            return NO;
           
        }];
        if (index !=0 && loadImageArray.count >1 && index <loadImageArray.count) {// 如果就一张照片就不删除
            [loadImageArray removeObjectAtIndex:index];
        }
    }
    self.imageLoadArray = loadImageArray;
}
- (NSString *)pathOfSTPlist{
    return [[self downloadPath] stringByAppendingPathComponent:@"STARTIMAGE.plist"];
}

- (void)saveDisplayImageName:(NSString *)name{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:kStartImageName];
    [defaults synchronize];
}

- (NSString *)getDisplayImageName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kStartImageName];
}
- (StartImage *)curImage{
    if (!_startImage) {
        _startImage = [StartImage defautImage];
    }
    return _startImage;
}

- (void)refreshImagesPlist{
    NSString *aPath = @"api/wallpaper/wallpapers";
    NSDictionary *params = @{@"type" : @"3"};
    
    [[YinkeNetAPIClicent sharedJsonClient] GET:aPath parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
        id error = [self handleResponse:responseObject];
        if (!error) {
            NSArray *resultA = [responseObject valueForKey:@"data"];
            if ([self createFolder:[self downloadPath]]) {
                if ([resultA writeToFile:[self pathOfSTPlist] atomically:YES]) {
                    [[StartImagesManager shareManager] startDownloadImages];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
    }];
    
    
}
- (void)startDownloadImages{
    
    if (![AFNetworkReachabilityManager sharedManager].reachableViaWiFi) {
        return;
    }
    
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:[self pathOfSTPlist]];
    plistArray = [NSObject arrayFromJSON:plistArray ofObjects:@"StartImage"];
    
    NSMutableArray *needToDownloadArray = [NSMutableArray array];
    NSFileManager *fm = [NSFileManager defaultManager];
    for (StartImage *curST in plistArray) {
        if (![fm fileExistsAtPath:curST.pathDisk]) {
            [needToDownloadArray addObject:curST];
        }
    }
    
    for (StartImage *curST in needToDownloadArray) {
        [curST startDownloadImage];
    }
}
@end


@implementation StartImage

- (NSString *)fileName{
    if (!_fileName && _url.length > 0) {
        _fileName = [[_url componentsSeparatedByString:@"/"] lastObject];
    }
    return _fileName;
}
-(NSString *)descriptionStr{
    if (!_descriptionStr && _group) {
        _descriptionStr = [NSString stringWithFormat:@"\"%@\" © %@", _group.name.length > 0? _group.name : @"今天天气不错", _group.author.length > 0? _group.author : @"作者"];
    }
    return _descriptionStr;
}

- (NSString *)pathDisk{
    if (!_pathDisk && _url) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _pathDisk = [[documentPath
                      stringByAppendingPathComponent:@"Coding_StartImages"]
                     stringByAppendingPathComponent:[[_url componentsSeparatedByString:@"/"] lastObject]];
    }
    return _pathDisk;
}


+ (StartImage *)defautImage{
    StartImage *st = [[StartImage alloc] init];
    st.descriptionStr = @"\"Light Returning\" © Scott summerville";
    st.fileName = @"STARTIMAGE.jpg";
    st.pathDisk = [[NSBundle mainBundle] pathForResource:@"STARTIMAGE" ofType:@"jpg"];
    return st;
}

+ (StartImage *)midAutumnImage{
    StartImage *st = [[StartImage alloc] init];
    st.descriptionStr = @"\"中秋快乐\" © Mango";
    st.fileName = @"MIDAUTUMNIMAGE.jpg";
    st.pathDisk = [[NSBundle mainBundle] pathForResource:@"MIDAUTUMNIMAGE" ofType:@"jpg"];
    return st;
}

- (UIImage *)image{
    return [UIImage imageWithContentsOfFile:self.pathDisk];
}

- (void)startDownloadImage{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *pathDisk = [[documentPath stringByAppendingPathComponent:@"Coding_StartImages"] stringByAppendingPathComponent:[response suggestedFilename]];
        return [NSURL fileURLWithPath:pathDisk];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        DebugLog(@"downloaded file_path is to: %@", filePath);
    }];
    [downloadTask resume];
}
@end


@implementation Group



@end
