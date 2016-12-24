//
//  EasyStartView.h
//  yingke
//
//  Created by Sino on 16/7/26.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EasyStartView : UIView
+ (instancetype)startView;

- (void)startAnimationWithCompletionBlock:(void(^)(EasyStartView *easeStartView))completionHandler;
@end
