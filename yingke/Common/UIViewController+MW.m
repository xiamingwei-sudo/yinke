//
//  UIViewController+MW.m
//  yingke
//
//  Created by 夏明伟 on 2016/11/3.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "UIViewController+MW.h"
#import "UIImageView+Animation.h"

static const void *GifKey = &GifKey;
@implementation UIViewController (MW)
- (UIImageView *)gifView{
    return objc_getAssociatedObject(self, GifKey);
   
}

- (void)setGifView:(UIImageView *)gifView{
    return objc_setAssociatedObject(self, GifKey, gifView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)showGifLoding:(NSArray *)images inView:(UIView *)view{
    if (!images.count) {
        images = @[[UIImage imageNamed:@"hold1_60x72"], [UIImage imageNamed:@"hold2_60x72"], [UIImage imageNamed:@"hold3_60x72"]];
    }
    UIImageView *gifView = [[UIImageView alloc] init];
    if (!view) {
        view = self.view;
    }
    [view addSubview:gifView];
    [gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.equalTo(@60);
        make.height.equalTo(@70);
    }];
    self.gifView = gifView;
    [gifView playGifAnim:images];
    
}
// 取消GIF加载动画
- (void)hideGufLoding
{
    [self.gifView stopGifAnim];
    self.gifView = nil;
}

- (BOOL)isNotEmpty:(NSArray *)array
{
    if ([array isKindOfClass:[NSArray class]] && array.count) {
        return YES;
    }
    return NO;
}

@end
