//
//  NSDictionary+MWAdditions.m
//  yingke
//
//  Created by 夏明伟 on 2016/11/3.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "NSDictionary+MWAdditions.h"

@implementation NSDictionary (MWAdditions)

- (NSDictionary *)dictionaryByReplacingNullsWithStrings {
    const NSMutableDictionary *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for(NSString *key in self) {
        const id object = [self objectForKey:key];
        if(object == nul) {
            //pointer comparison is way faster than -isKindOfClass:
            //since [NSNull null] is a singleton, they'll all point to the same
            //location in memory.
            [replaced setObject:blank
                         forKey:key];
        }
    }
    
    return [replaced copy];
}
-(BOOL)writeToPlistFile:(NSString*)filePath{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
    BOOL didWriteSuccessfull = [data writeToFile:filePath atomically:YES];
    return didWriteSuccessfull;
}

@end
