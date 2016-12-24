//
//  TopADCell.m
//  yingke
//
//  Created by 夏明伟 on 2016/11/3.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "TopADCell.h"
#import "TopADModel.h"


@implementation TopADCell

- (void)setTopADArray:(NSArray *)topADArray
{
    _topADArray = topADArray;
    
    NSMutableArray *imageUrls = [NSMutableArray array];
    for (TopADModel *topAD in topADArray) {
        [imageUrls addObject:topAD.imageUrl];
    }
    XRCarouselView *view = [XRCarouselView carouselViewWithImageArray:imageUrls describeArray:nil];
    view.time = 2.0;
    view.delegate = self;
    view.frame = self.contentView.bounds;
    [self.contentView addSubview:view];
}

#pragma mark - XRCarouselViewDelegate
- (void)carouselView:(XRCarouselView *)carouselView clickImageAtIndex:(NSInteger)index
{
    if (self.imageClickBlock) {
        self.imageClickBlock(self.topADArray[index]);
    }
}

@end
