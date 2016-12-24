//
//  HtmlMedia.h
//  yingke
//
//  Created by Sino on 16/7/26.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, HtmlMediaItemType) {
    HtmlMediaItemType_Image = 0,
    HtmlMediaItemType_Code,
    HtmlMediaItemType_EmotionEmoji,
    HtmlMediaItemType_EmotionMonkey,
    HtmlMediaItemType_ATUser,
    HtmlMediaItemType_AutoLink,
    HtmlMediaItemType_CustomLink
};

typedef NS_ENUM(NSInteger, MediaShowType) {
    MediaShowTypeNone = 1,
    MediaShowTypeCode = 2,
    MediaShowTypeImage = 3,
    MediaShowTypeMonkey = 5,
    MediaShowTypeImageAndMonkey = 15,
    MediaShowTypeAll = 30
};

@class HtmlMediaItem;

@interface HtmlMedia : NSObject
@property (readwrite, nonatomic, copy) NSString *contentOrigional;
@property (readwrite, nonatomic, strong) NSMutableString *contentDisplay;
@property (readwrite, nonatomic, strong) NSMutableArray *mediaItems;
@property (strong, nonatomic) NSArray *imageItems;
- (void)removeItem:(HtmlMediaItem *)item;

+ (instancetype)htmlMediaWithString:(NSString *)htmlString showType:(MediaShowType)showType;
- (instancetype)initWithString:(NSString *)htmlString showType:(MediaShowType)showType;


//在curString的末尾添加一个media元素
+ (void)addMediaItem:(HtmlMediaItem *)curItem toString:(NSMutableString *)curString andMediaItems:(NSMutableArray *)itemList;
+ (void)addLinkStr:(NSString *)linkStr type:(HtmlMediaItemType)type toString:(NSMutableString *)curString andMediaItems:(NSMutableArray *)itemList;


@end



@interface HtmlMediaItem : NSObject
@property (assign, nonatomic) HtmlMediaItemType type;
@property (assign, nonatomic) MediaShowType showType;
@property (readwrite, nonatomic, strong) NSString *src, *title, *href, *name, *code, *linkStr;
@property (assign, nonatomic) NSRange range;

+ (instancetype)htmlMediaItemWithType:(HtmlMediaItemType)type;

- (NSString *)displayStr;
- (BOOL)isGif;
@end