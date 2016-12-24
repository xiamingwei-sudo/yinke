//
//  NSDictionary+MWAdditions.h
//  yingke
//
//  Created by 夏明伟 on 2016/11/3.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MWAdditions)
- (NSDictionary *)dictionaryByReplacingNullsWithStrings;

-(BOOL)writeToPlistFile:(NSString*)filePath;
@end
