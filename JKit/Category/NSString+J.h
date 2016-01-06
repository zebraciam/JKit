//
//  NSString+J.h
//  JKitDemo
//
//  Created by elongtian on 16/1/6.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define JMD5(string) [string j_md5]
#define JSHA1(string) [string j_sha1]

#define JValidNumber(string) [string j_validNumber]
#define JValidMobile(string) [string j_validMobile]
#define JValidIdentityCard(string) [string j_validIdentityCard]
#define JValidURL(string) [string j_validURL]
#define JValidEMail(string) [string j_validEMail]

#define JDocumentsFile(name) [name j_documentsFile]
#define JRemoveDocumentsFile(file) [file j_removeDocumentsFile]
#define JSaveUserDefaults(string,key) [string j_saveUserDefaultsWithKey:key]
#define JGetUserDefaults(key) [key j_getUserDefaults]

#define JTrimWhitespaceAndNewline(string) [string j_trimWhitespaceAndNewline]
#define JTrimWhitespaceAll(string) [string j_trimWhitespaceAll]

#define JEncode(string) [string j_encode]
#define JDecode(string) [string j_decode]

@interface NSString (J)

/**
 *  MD5
 *
 *  @return NSString
 */
- (NSString *)j_md5;

/**
 *  SHA1
 *
 *  @return NSString
 */
- (NSString *)j_sha1;

/**
 *  判断输入0-9数字
 *
 *  @return 是/不是
 */
- (BOOL)j_validNumber;

/**
 *  判断手机号
 *
 *  @return 是/不是
 */
- (BOOL)j_validMobile;

/**
 *  判断身份证号
 *
 *  @return 是/不是
 */
- (BOOL)j_validIdentityCard;

/**
 *  判断URL
 *
 *  @return 是/不是
 */
- (BOOL)j_validURL;

/**
 *  判断EMail
 *
 *  @return 是/不是
 */
- (BOOL)j_validEMail;

/**
 *  判断IP
 *
 *  @return 是/不是
 */
- (BOOL)j_validIPAddress;

/**
 *  判断汉字
 *
 *  @return 是/不是
 */
- (BOOL)j_validChinese;

/**
 *  计算Size
 *
 *  @param font 当前字体
 *  @param size 当前区域内
 *
 *  @return Size
 */
- (CGSize)j_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/**
 *  计算Width
 *
 *  @param font 当前字体
 *  @param size 当前区域内
 *
 *  @return Width
 */
- (CGFloat)j_widthWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/**
 *  计算Height
 *
 *  @param font 当前字体
 *  @param size 当前区域内
 *
 *  @return Height
 */
- (CGFloat)j_heightWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/**
 *  返回沙盒中的文件路径
 *
 *  @return 沙盒中的文件路径
 */
- (NSString *)j_documentsFile;

/**
 *  删除沙盒中的文件
 *
 *  @return 成功/失败
 */
- (BOOL)j_removeDocumentsFile;

/**
 *  写入系统偏好
 *
 *  @param key
 */
- (BOOL)j_saveUserDefaultsWithKey:(NSString *)key;

/**
 *  获取系统偏好值
 *
 *  @return 偏好值
 */
- (NSString *)j_getUserDefaults;

/**
 *  去掉字符串两端的空白
 *
 *  @return NSString
 */
- (NSString *)j_trimWhitespace;

/**
 *  去掉字符串两端的空白和回车字符
 *
 *  @return NSString
 */
- (NSString *)j_trimWhitespaceAndNewline;

/**
 *  去掉字符串所有的空白字符
 *
 *  @return NSString
 */
- (NSString *)j_trimWhitespaceAll;

/**
 *  字符串反转
 *
 *  @return NSString
 */
- (NSString *)j_reverse;

/**
 *  是否包含字符串
 *
 *  @param aString 目标字符串
 *
 *  @return 是/否
 */
- (BOOL)j_containsString:(NSString *)aString;

/**
 *  字符串拼接
 *
 *  @param separatedString 分割符
 *  @param string          目标字符串
 *
 *  @return NSString
 */
- (NSString *)j_joinSeparatedByString:(NSString *)separatedString otherStrings:(NSString *)otherStrings, ...NS_REQUIRES_NIL_TERMINATION;

///**
// *  URLEncode
// *
// *  @return NSString
// */
//- (NSURL *)j_urlEncode;
//
///**
// *  请求参数
// *
// *  @return NSDictionary
// */
//- (NSDictionary *)j_requestParams;
//
///**
// *  Encode
// *
// *  @return NSString
// */
//- (NSString *)j_encode;
//
///**
// *  Decode
// *
// *  @return NSString
// */
//- (NSString *)j_decode;

#pragma mark - pinyin

/**
 *  中文->zhōng wén
 *
 *  @return e.g.@"zhōng wén"
 */
- (NSString *)j_pinyinWithPhoneticSymbol;

/**
 *  中文->zhong wen
 *
 *  @return e.g.@"zhong wen"
 */
- (NSString *)j_pinyin;

/**
 *  中文->[@"zhong", @"wen"]
 *
 *  @return e.g.@[@"zhong", @"wen"]
 */
- (NSArray *)j_pinyinArray;

/**
 *  中文->zhongwen
 *
 *  @return e.g.@"zhongwen"
 */
- (NSString *)j_pinyinWithoutBlank;

/**
 *  中文->[@"z", @"w"]
 *
 *  @return e.g.@[@"z", @"w"]
 */
- (NSArray *)j_pinyinInitialsArray;

/**
 *  中文->zw
 *
 *  @return e.g.@"zw"
 */
- (NSString *)j_pinyinInitialsString;

@end
