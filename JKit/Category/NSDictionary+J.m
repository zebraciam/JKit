//
//  NSDictionary+J.m
//  JKitDemo
//
//  Created by elongtian on 16/1/13.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import "NSDictionary+J.h"

@implementation NSDictionary (J)

#pragma mark -取值(防止为Null)
- (instancetype)j_objectForKey:(NSString *)key{
    if ([[self objectForKey:key] isEqual:[NSNull null]]) {
        return nil;
    }else{
        return [self objectForKey:key];
    }
}
@end
