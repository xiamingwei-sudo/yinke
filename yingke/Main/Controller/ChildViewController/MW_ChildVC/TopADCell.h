//
//  TopADCell.h
//  yingke
//
//  Created by 夏明伟 on 2016/11/3.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRCarouselView.h"
@class TopADModel;

@interface TopADCell : UITableViewCell<XRCarouselViewDelegate>

@property (nonatomic , strong)NSArray *topADArray;

/** 点击图片的block */
@property (nonatomic, copy) void (^imageClickBlock)(TopADModel *topAD);
@end
