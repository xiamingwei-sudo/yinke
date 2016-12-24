//
//  StartImagesManager.h
//  yingke
//
//  Created by Sino on 16/7/26.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StartImage;
@class Group;

@interface StartImagesManager : NSObject
+ (instancetype)shareManager;

- (StartImage *)randomImage;
- (StartImage *)curImage;
- (void)handleStartLink;

- (void)refreshImagesPlist;
- (void)startDownloadImages;

@end

@interface StartImage : NSObject
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) Group *group;
@property (strong, nonatomic) NSString *fileName, *descriptionStr, *pathDisk;

+ (StartImage *)defautImage;
+ (StartImage *)midAutumnImage;
- (StartImage *)curImage;
- (UIImage *)image;
- (void)startDownloadImage;
@end

@interface Group : NSObject
@property (strong, nonatomic) NSString *name, *author, *link;
@end