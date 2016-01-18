//
//  NSString+J.m
//  JKitDemo
//
//  Created by elongtian on 16/1/6.
//  Copyright © 2016年 陈杰. All rights reserved.
//

#import "NSString+J.h"
#import <CommonCrypto/CommonDigest.h>
//引入IOS自带密码库
#import <CommonCrypto/CommonCryptor.h>

//空字符串
#define     LocalStr_None           @""

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
@implementation NSString (J)

- (NSString *)j_base64
{
    
    if (self && ![self isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY  改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin  改动了此处
        //data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [self base64EncodedStringFrom:data];
        //        return [self stringByURLEncodingStringParameter:[self base64EncodedStringFrom:data]];
    }
    else {
        return LocalStr_None;
    }
}


- (NSString *)j_textFromBase64
{
    if (self && ![self isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY   改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [self dataWithBase64EncodedString:self];
        //IOS 自带DES解密 Begin    改动了此处
        //data = [self DESDecrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return LocalStr_None;
    }
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
- (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
- (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 ******************************************************************************/
- (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:@""];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
- (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}






#pragma mark MD5

- (NSString *)j_md5
{
    const char *input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *md5 = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        
        [md5 appendFormat:@"%02x", result[i]];
    }
    
    return md5;
}

#pragma mark SHA1

- (NSString *)j_sha1
{
    const char *cStr = [self UTF8String];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *sha1 = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        
        [sha1 appendFormat:@"%02x", digest[i]];
    }
    
    return sha1;
}

#pragma mark -.-

- (BOOL)validWithRegex:(NSString *)regex
{
    if (!self || !self.length) {
        
        return false;
    }
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (![pred evaluateWithObject:self]) {
        
        return false;
    }
    
    return true;
}

#pragma mark 判断输入0-9数字

- (BOOL)j_validNumber
{
    return [self validWithRegex:@"^[0-9]*$"];
}

#pragma mark 判断手机号

/**
 *
 运营商手机号段划分
 
 中国移动：134（0-8）、135、136、137、138、139、147、150、151、152、154、157、158、159、178、182、183、184、187、188
 中国联通：130、131、132、145、155、156、176、185、186
 中国电信：133、1349、153、177、180、181、189
 网络运营商：170
 *
 *  @return 是/不是
 */
- (BOOL)j_validMobile
{
    return [self validWithRegex:@"^(0|86|17951)?(13[0-9]|15[0-9]|17[0678]|18[0-9]|14[57])[0-9]{8}$"];
}

#pragma mark 判断身份证号

- (BOOL)j_validIdentityCard
{
    return [self chk18PaperId:[self uppercaseString]];
}

- (BOOL)chk18PaperId:(NSString *)sPaperId
{
    //  判断位数
    
    if ([sPaperId length] != 15 && [sPaperId length] != 18) {
        
        return NO;
    }
    
    NSString *carid = sPaperId;
    
    long lSumQT = 0;
    
    //  加权因子
    
    int R[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};
    
    //  校验码
    
    unsigned char sChecker[11] = {'1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //  将15位身份证号转换成18位
    
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    
    if ([sPaperId length] == 15) {
        
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        
        const char *pid = [mString UTF8String];
        
        for (int i = 0; i <= 16; i++) {
            
            p += (pid[i] - 48) * R[i];
        }
        
        int o = p % 11;
        
        NSString *string_content = [NSString stringWithFormat:@"%c", sChecker[o]];
        
        [mString insertString:string_content atIndex:[mString length]];
        
        carid = mString;
    }
    
    //  判断地区码
    
    NSString *sProvince = [carid substringToIndex:2];
    
    if (![self areaCode:sProvince]) {
        
        return NO;
    }
    
    //  判断年月日是否有效
    
    //  年份
    
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    
    //  月份
    
    int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
    
    //  日
    
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [dateFormatter setTimeZone:localZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01", strYear, strMonth, strDay]];
    
    if (!date) {
        
        return NO;
    }
    
    const char *PaperId = [carid UTF8String];
    
    //检验长度
    
    if (18 != strlen(PaperId)) {
        
        return - 1;
    }
    
    //校验数字
    
    for (int i = 0; i < 18; i++) {
        
        if (!isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i)) {
            
            return NO;
        }
    }
    
    //验证最末的校验码
    
    for (int i = 0; i <= 16; i++) {
        
        lSumQT += (PaperId[i] - 48) * R[i];
    }
    
    if (sChecker[lSumQT % 11] != PaperId[17]) {
        
        return NO;
    }
    
    return YES;
}

- (NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger)value1 Value2:(NSInteger)value2;
{
    return [str substringWithRange:NSMakeRange(value1, value2)];
}

- (BOOL)areaCode:(NSString *)code
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:@"北京" forKey:@"11"];
    
    [dic setObject:@"天津" forKey:@"12"];
    
    [dic setObject:@"河北" forKey:@"13"];
    
    [dic setObject:@"山西" forKey:@"14"];
    
    [dic setObject:@"内蒙古" forKey:@"15"];
    
    [dic setObject:@"辽宁" forKey:@"21"];
    
    [dic setObject:@"吉林" forKey:@"22"];
    
    [dic setObject:@"黑龙江" forKey:@"23"];
    
    [dic setObject:@"上海" forKey:@"31"];
    
    [dic setObject:@"江苏" forKey:@"32"];
    
    [dic setObject:@"浙江" forKey:@"33"];
    
    [dic setObject:@"安徽" forKey:@"34"];
    
    [dic setObject:@"福建" forKey:@"35"];
    
    [dic setObject:@"江西" forKey:@"36"];
    
    [dic setObject:@"山东" forKey:@"37"];
    
    [dic setObject:@"河南" forKey:@"41"];
    
    [dic setObject:@"湖北" forKey:@"42"];
    
    [dic setObject:@"湖南" forKey:@"43"];
    
    [dic setObject:@"广东" forKey:@"44"];
    
    [dic setObject:@"广西" forKey:@"45"];
    
    [dic setObject:@"海南" forKey:@"46"];
    
    [dic setObject:@"重庆" forKey:@"50"];
    
    [dic setObject:@"四川" forKey:@"51"];
    
    [dic setObject:@"贵州" forKey:@"52"];
    
    [dic setObject:@"云南" forKey:@"53"];
    
    [dic setObject:@"西藏" forKey:@"54"];
    
    [dic setObject:@"陕西" forKey:@"61"];
    
    [dic setObject:@"甘肃" forKey:@"62"];
    
    [dic setObject:@"青海" forKey:@"63"];
    
    [dic setObject:@"宁夏" forKey:@"64"];
    
    [dic setObject:@"新疆" forKey:@"65"];
    
    [dic setObject:@"台湾" forKey:@"71"];
    
    [dic setObject:@"香港" forKey:@"81"];
    
    [dic setObject:@"澳门" forKey:@"82"];
    
    [dic setObject:@"国外" forKey:@"91"];
    
    if (![dic objectForKey:code]) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark 判断URL

- (BOOL)j_validURL
{
    return [self validWithRegex:@"^((http)|(https))+:[^\\s]+\\.[^\\s]*$"];
}

#pragma mark 判断EMail

- (BOOL)j_validEMail
{
    return [self validWithRegex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

#pragma mark 判断IP

- (BOOL)j_validIPAddress
{
    if ([self validWithRegex:@"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"]) {
        
        NSArray *components = [self componentsSeparatedByString:@"."];
        
        for (NSString *s in components) {
            
            if (s.integerValue > 255) {
                
                return NO;
            }
        }
        
        return YES;
    }
    
    return NO;
}

#pragma mark 判断汉字

- (BOOL)j_validChinese
{
    return [self validWithRegex:@"^[\u4e00-\u9fa5]+$"];
}

#pragma mark - -.-

#pragma mark 计算Size

- (CGSize)j_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize resultSize = CGSizeZero;
    
    if (self.length <= 0) {
        return resultSize;
    }
    
    resultSize = [self boundingRectWithSize:size options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: font} context:nil].size;
    
    return resultSize;
}

#pragma mark 计算Width

- (CGFloat)j_widthWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self j_sizeWithFont:font constrainedToSize:size].width;
}

#pragma mark 计算Height

- (CGFloat)j_heightWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self j_sizeWithFont:font constrainedToSize:size].height;
}

#pragma mark - -.-

#pragma mark 返回沙盒中的文件路径

- (NSString *)j_documentsFile
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:self];
}

#pragma mark 删除沙盒中的文件

- (BOOL)j_removeDocumentsFile
{
    return [[NSFileManager defaultManager] removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:self] error:nil];
}

#pragma mark 写入系统偏好

- (BOOL)j_saveUserDefaultsWithKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:self forKey:key];
    
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 获取系统偏好值

- (NSString *)j_getUserDefaults
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:self];
}

#pragma mark - -.-

#pragma mark 去掉字符串两端的空白

- (NSString *)j_trimWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark 去掉字符串两端的空白和回车字符

- (NSString *)j_trimWhitespaceAndNewline
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark 去掉字符串所有的空白字符

- (NSString *)j_trimWhitespaceAll
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark 字符串反转

- (NSString *)j_reverse
{
    NSMutableString *reverseString = [[NSMutableString alloc] init];
    
    NSInteger charIndex = [self length];
    
    while (charIndex > 0) {
        
        charIndex--;
        NSRange subStringRange = NSMakeRange(charIndex, 1);
        [reverseString appendString:[self substringWithRange:subStringRange]];
    }
    
    return reverseString;
}

#pragma mark 是否包含字符串

- (BOOL)j_containsString:(NSString *)aString
{
    NSRange rang = [self rangeOfString:aString];
    
    if (rang.location == NSNotFound) {
        
        return NO;
        
    } else {
        
        return YES;
    }
}

- (NSString *)j_joinSeparatedByString:(NSString *)separatedString otherStrings:(NSString *)otherStrings, ...NS_REQUIRES_NIL_TERMINATION;
{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    
    va_list args;
    
    if (otherStrings) {
        
        separatedString.length ? [mutableString appendFormat:@"%@%@", separatedString, otherStrings] : [mutableString appendString:otherStrings];
        
        va_start(args, otherStrings);
        
        NSString *other;
        
        while ((other = va_arg(args, NSString *))) {
            
            separatedString.length ? [mutableString appendFormat:@"%@%@", separatedString, other] : [mutableString appendString:other];
        }
        
        va_end(args);
    }
    
    return mutableString;
}

#pragma mark - -.-

#pragma mark - -.-

#pragma mark - pinyin

- (NSString *)j_pinyinWithPhoneticSymbol
{
    NSMutableString *pinyin = [NSMutableString stringWithString:self];
    
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformMandarinLatin, NO);
    
    return pinyin;
}

- (NSString *)j_pinyin
{
    NSMutableString *pinyin = [NSMutableString stringWithString:[self j_pinyinWithPhoneticSymbol]];
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformStripCombiningMarks, NO);
    
    return pinyin;
}

- (NSArray *)j_pinyinArray
{
    NSArray *array = [[self j_pinyin] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return array;
}

- (NSString *)j_pinyinWithoutBlank
{
    NSMutableString *string = [NSMutableString stringWithString:@""];
    
    for (NSString *str in [self j_pinyinArray]) {
        
        [string appendString:str];
    }
    
    return string;
}

- (NSArray *)j_pinyinInitialsArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *str in [self j_pinyinArray]) {
        
        if ([str length] > 0) {
            
            [array addObject:[str substringToIndex:1]];
        }
    }
    
    return array;
}

- (NSString *)j_pinyinInitialsString
{
    NSMutableString *pinyin = [NSMutableString stringWithString:@""];
    
    for (NSString *str in [self j_pinyinArray]) {
        
        if ([str length] > 0) {
            
            [pinyin appendString:[str substringToIndex:1]];
        }
    }
    
    return pinyin;
}

@end
