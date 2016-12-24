//
//  UIImageView+Animation.h
//  yingke
//
//  Created by 夏明伟 on 2016/11/3.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Animation)
// 播放GIF
- (void)playGifAnim:(NSArray *)images;
// 停止动画
- (void)stopGifAnim;
@end
