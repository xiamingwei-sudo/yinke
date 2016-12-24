//
//  YinkeShareView.m
//  yingke
//
//  Created by Sino on 16/8/3.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "YinkeShareView.h"
#import "SMPageControl.h"

#define YinkeShareView_NumPerLine 4
#define YinkeShareView_NumPerScroll (2 * kCodingShareView_NumPerLine)
#define YinkeShareView_TopHeight 60.0
#define YinkeShareView_BottomHeight 65.0

@interface YinkeShareView()
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UILabel *titLabel;
@property (nonatomic, strong)UIButton *dismissButton;
@property (nonatomic, strong)UIScrollView *itemScrollView;
@property (nonatomic, strong)SMPageControl *pageControl;

@property (weak, nonatomic) NSObject *objToShare;
@end

@implementation YinkeShareView
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = kScreen_Bounds;
        
        if (!_bgView) {
            _bgView = ({
                UIView *view = [[UIView alloc]initWithFrame:kScreen_Bounds];
                view.backgroundColor = [UIColor blackColor];
                view.alpha = 0;
                view;
            });
            [self addSubview:_bgView];
        }
        
        if (!_contentView) {
            _contentView = ({
                UIView *view = [UIView new];
                view.backgroundColor = [UIColor colorWithHexString:@"0xF0F0F0"];
                view;
            });
            if (!_titLabel) {
                _titLabel = ({
                    UILabel *labe = [UILabel new];
                    labe.textAlignment = NSTextAlignmentCenter;
                    labe.font = [UIFont systemFontOfSize:14];
                    labe.textColor = [UIColor colorWithHexString:@"0x666666"];
                    labe;
                });
                
                [_contentView addSubview:_titLabel];
                [_titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_contentView).offset(10);
                    make.left.right.equalTo(_contentView);
                    make.height.mas_equalTo(20);
                }];
            }
            if (!_dismissButton) {
                _dismissButton = ({
                
                    UIButton *button = [UIButton new];
                    button.backgroundColor = [UIColor whiteColor];
                    button.layer.masksToBounds = YES;
                    button.layer.cornerRadius = 2.0;
                    button.titleLabel.font = [UIFont systemFontOfSize:15];
                    [button setTitle:@"取消" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithHexString:@"0x808080"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithHexString:@"0x3bbd79"] forState:UIControlStateHighlighted];
                    button;
                });
                [_contentView addSubview:_dismissButton];
                [_dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_contentView).offset(kPaddingLeftWidth);
                    make.right.equalTo(_contentView).offset(-kPaddingLeftWidth);
                    make.bottom.equalTo(_contentView).offset(-kPaddingLeftWidth);
                    make.height.mas_equalTo(40);
                }];
            }
            if (!_itemScrollView) {
                _itemScrollView = ({
                    UIScrollView *scroll = [UIScrollView new];
                    scroll.pagingEnabled = YES;
                    scroll.showsVerticalScrollIndicator = NO;
                    scroll.showsHorizontalScrollIndicator = NO;
                    scroll;
                });
                [_contentView addSubview:_itemScrollView];
                [_itemScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(_contentView);
                    make.top.equalTo(_contentView).offset(YinkeShareView_TopHeight);
                    make.bottom.equalTo(_contentView).offset(-YinkeShareView_BottomHeight);
                }];
            }
            [_contentView setY:kScreen_Height];
            [self addSubview:_contentView];
        }
    }
    return self;
}
- (SMPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = ({
            SMPageControl *page = [[SMPageControl alloc]init];
            page.backgroundColor = [UIColor clearColor];
            page.userInteractionEnabled = NO;
            page.pageIndicatorMaskImage = [UIImage imageNamed:@"banner__page_unselected"];
            page.currentPageIndicatorImage = [UIImage imageNamed:@"banner__page_selected"];
            page;
        });
        [self addSubview:_pageControl];
    }
    [self addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contentView);
        make.height.mas_equalTo(10);
        make.bottom.equalTo(_dismissButton.mas_top).offset(-10);
    }];
    // 响应式编程 类似于KVO
    [RACObserve(self, itemScrollView.contentOffset) subscribeNext:^(NSValue *point) {
        CGPoint contentOffset;
        [point getValue:&contentOffset];
        CGFloat pageWidth = kScreen_Width;
        NSUInteger page = MAX(0, floor((contentOffset.x + (pageWidth / 2)) / pageWidth));
        if (page != self.pageControl.currentPage) {
            self.pageControl.currentPage = page;
        }
    }];
    return _pageControl;
}

#pragma mark Common
+(instancetype)shareInstance{
    static YinkeShareView *shareView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareView = [[YinkeShareView alloc]init];
    });
    return shareView;
}
+ (NSDictionary *)snsNameDict{
    static NSDictionary *snsNameDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        snsNameDict = @{
                        @"coding": @"Coding好友",
                        @"copylink": @"复制链接",
                        @"evernote": @"印象笔记",
                        @"sina": @"新浪微博",
                        @"qzone": @"QQ空间",
                        @"qq": @"QQ好友",
                        @"wxtimeline": @"朋友圈",
                        @"wxsession": @"微信好友",
                        @"inform": @"举报",
                        };
    });
    return snsNameDict;
    
}
+(NSArray *)supportSnsValues{
    NSMutableArray *resultSnsValues = [@[
                                         @"wxsession",
                                         @"wxtimeline",
                                         @"qq",
                                         @"qzone",
                                         @"sina",
                                         @"evernote",
                                         @"coding",
                                         @"copylink",
                                         @"inform",
                                         ] mutableCopy];
    if (![self p_canOpen:@"weixin://"]) {
        [resultSnsValues removeObjectsInArray:@[
                                                @"wxsession",
                                                @"wxtimeline",
                                                ]];
    }
    if (![self p_canOpen:@"mqqapi://"]) {
        [resultSnsValues removeObjectsInArray:@[
                                                @"qq",
                                                @"qzone",
                                                ]];
    }
    //    if (![self p_canOpen:@"weibosdk://request"]) {
    //        [resultSnsValues removeObjectsInArray:@[@"sina"]];
    //    }
    //    if (![self p_canOpen:@"evernote://"]) {
    //        [resultSnsValues removeObjectsInArray:@[@"evernote"]];
    //    }
    return resultSnsValues;
}

+(BOOL)p_canOpen:(NSString*)url{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
}

+(void)showShareViewWIthObj:(id)curObj{
    [[self shareInstance]showShareViewWithObj:curObj];
}

- (void)showShareViewWithObj:(id)curObj{
    self.objToShare = curObj;
    [self YinkeShare_show];
}

- (void)YinkeShare_show{
    [self shareTitle_check];
    [self shareValue_check];
    
    [kKeyWindow addSubview:self];
    
    //animate to show
    CGPoint endCenter = self.contentView.center;
    endCenter.y -= CGRectGetHeight(self.contentView.frame);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 0.3;
        self.contentView.center = endCenter;
    } completion:nil];
    
}

- (void)shareTitle_check{
    NSString *title;
    if ([self.objToShare isKindOfClass:[UIWebView class]]) {
        title = @"链接分享到";
    }else{
        title = @"分享到";
    }
    
    _titLabel.text = title;
}

- (void)shareValue_check{
    
 
}
@end

@interface YinkeShareViewItem ()
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *titleL;

@end

@implementation YinkeShareViewItem

- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [YinkeShareViewItem itemWidth], [YinkeShareViewItem itemHeight]);
        _button = [UIButton new];
        [self addSubview:_button];
        CGFloat padding_button = kScaleFrom_iPhone5_Desgin(kPaddingLeftWidth);
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
    }
    
    return self;
}
@end
