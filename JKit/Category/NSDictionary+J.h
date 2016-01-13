//
//  NSDictionary+J.h
//  JKitDemo
//
//  Created by elongtian on 16/1/13.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (J)

/**
 *  取值(防止为Null)
 *
 *  @param key  key
 *
 *  @return nil 或者 值
 */
- (instancetype)j_objectForKey:(NSString *)key;
@end
