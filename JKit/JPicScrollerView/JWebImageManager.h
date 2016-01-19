//
//  JWebImageManager.h
//  JKitDemo
//
//  Created by elongtian on 16/1/19.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWebImageManager : NSObject
/**
 *  下载失败重复下载次数,默认不重复,
 */
@property NSUInteger DownloadImageRepeatCount;

/**
 *  图片下载失败会调用该block(如果设置了重复下载次数,则会在重复下载完后,假如还没下载成功,就会调用该block)
 *  @param error    错误信息
 *  @param imageUrl 下载失败的imageurl
 */
@property (nonatomic,copy) void(^downLoadImageError)(NSError *error,NSString *imageUrl);

@property (nonatomic,copy) void(^downLoadImageComplish)(UIImage *image,NSString *imageUrl);


+ (instancetype)shareManager;

- (void)downloadImageWithUrlString:(NSString *)urlSting;
@end
