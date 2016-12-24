//
//  CoverImageManager.h
//  yingke
//
//  Created by Sino on 16/7/29.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CoverImag;
@interface CoverImageManager : NSObject
+ (instancetype)shareManager;

- (CoverImag *)currentCover;
@end


@interface CoverImag : NSObject
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *fileName, *pathDisk;

- (void)startDownloadImage;
- (UIImage *)image;
@end