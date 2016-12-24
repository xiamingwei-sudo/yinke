//
//  YinkeShareView.h
//  yingke
//
//  Created by Sino on 16/8/3.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YinkeShareView : UIView
+(void)showShareViewWIthObj:(id)curObj;
@end

@interface YinkeShareViewItem : UIView

@property (strong, nonatomic) NSString *snsName;
@property (copy , nonatomic) void (^clickedBlock)(NSString *snsName);
+ (instancetype)itemWithSnsName:(NSString *)snsName;
+ (CGFloat)itemWidth;
+ (CGFloat)itemHeight;

@end
