//
//  NSArray+J.m
//  JKitDemo
//
//  Created by elongtian on 16/1/6.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import "NSArray+J.h"

@implementation NSArray (J)

- (BOOL)j_isContains:(NSString *)obj{
    for (NSString * object in self) {
        if ([object isEqualToString:obj]) {
            return YES;
        }
    }
    return NO;
}
- (instancetype)j_objectAtIndex:(NSInteger)index{
    if (self.count > index) {
        return [self objectAtIndex:index];
    }
    return nil;
}
@end
