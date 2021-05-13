//
//  NSString+NTAdd.h
//  XWCurrencyExchange
//
//  Created by YouLoft_MacMini on 16/1/27.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static inline BOOL NTStringEqual(NSString *s1, NSString *s2){
    return [s1 isEqualToString:s2];
}

@interface NSString (NTAdd)

@property (nonatomic, readonly) NSString *md2String;
@property (nonatomic, readonly) NSString *md4String;
@property (nonatomic, readonly) NSString *md5String;
@property (nonatomic, readonly) NSString *sha1String;
@property (nonatomic, readonly) NSString *sha224String;
@property (nonatomic, readonly) NSString *sha256String;
@property (nonatomic, readonly) NSString *sha384String;
@property (nonatomic, readonly) NSString *sha512String;
@property (nonatomic, readonly) NSString *verticalString;//通过添加换行符的方式将字符串变成垂直的，最后一个字符不会添加换行符

@property (nonatomic, readonly) NSString *crc32String;


@property (nonatomic, readonly) NSString *firstCharUpperString;

#pragma mark - hmac (HMAC 加密相关，通过一个Key值进行加密)
- (NSString *)nt_hmacMD5StringWithKey:(NSString *)key;

- (NSString *)nt_hmacSHA1StringWithKey:(NSString *)key;

- (NSString *)nt_hmacSHA224StringWithKey:(NSString *)key;

- (NSString *)nt_hmacSHA256StringWithKey:(NSString *)key;

- (NSString *)nt_hmacSHA384StringWithKey:(NSString *)key;

- (NSString *)nt_hmacSHA512StringWithKey:(NSString *)key;

#pragma mark - Authcode
- (NSString *)nt_authCodeEncoded:(NSString *)key encoding:(NSStringEncoding)encoding expiry:(NSUInteger)expiry;
- (NSString *)nt_authCodeEncoded:(NSString *)key encoding:(NSStringEncoding)encoding;
- (NSString *)nt_authCodeEncoded:(NSString *)key;
- (NSString *)nt_authCodeDecoded:(NSString *)key encoding:(NSStringEncoding)encoding expiry:(NSUInteger)expiry;
- (NSString *)nt_authCodeDecoded:(NSString *)key encoding:(NSStringEncoding)encoding;
- (NSString *)nt_authCodeDecoded:(NSString *)key;

- (NSString *)nt_aes128EncryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSString *)nt_aes128DecryptWithkey:(NSString *)key iv:(NSString *)iv;

#pragma mark - ecode and decode (编码解码相关)
@property (nonatomic, readonly) NSString *base64EncodedString;
@property (nonatomic, readonly) NSString *base64DecodedString;
@property (nonatomic, readonly) NSString *urlEncodedString;
@property (nonatomic, readonly) NSString *urlDecodedString;
@property (nonatomic, readonly) NSString *escapingHTMLString;
@property(nonatomic, readonly) NSData *hexData;

- (NSString *)nt_base64EncodedString:(NSStringEncoding)encoding;
- (NSString *)nt_base64DecodedString:(NSStringEncoding)encoding;

#pragma mark - size to fit (文字自适应相关)
- (CGSize)nt_sizeWithfont:(UIFont *)font maxSize:(CGSize)maxSize;
- (CGSize)nt_sizeWithAttrs:(NSDictionary *)attrs maxSize:(CGSize)maxSize;
- (NSString *)nt_trimStringWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

#pragma mark - regular expression(正则表达式相关)
- (BOOL)nt_matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options;
- (void)nt_enumerateRegexMatches:(NSString *)regex
                      options:(NSRegularExpressionOptions)options
                   usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block;
- (NSString *)nt_stringByReplacingRegex:(NSString *)regex
                             options:(NSRegularExpressionOptions)options
                          withString:(NSString *)replacement;

#pragma mark - NSNumber (添加部分NSNumber相关属性)

@property (nonatomic, readonly) NSNumber *numberValue;
@property (readonly) char charValue;
@property (readonly) unsigned char unsignedCharValue;
@property (readonly) short shortValue;
@property (readonly) unsigned short unsignedShortValue;
@property (readonly) unsigned int unsignedIntValue;
@property (readonly) long longValue;
@property (readonly) unsigned long unsignedLongValue;
@property (readonly) unsigned long long unsignedLongLongValue;
@property (readonly) NSUInteger unsignedIntegerValue;

#pragma mark - UTF32 Char (UTF32相关)

+ (NSString *)nt_stringWithUTF32Char:(UTF32Char)char32;
+ (NSString *)nt_stringWithUTF32Chars:(const UTF32Char *)char32 length:(NSUInteger)length;
- (void)nt_enumerateUTF32CharInRange:(NSRange)range usingBlock:(void (^)(UTF32Char char32, NSRange range, BOOL *stop))block;

#pragma mark - imageScaleString (给图片路径添加scale字段，如@2x， 用于没有使用AssetImage的图片资源)

/**如果无后缀名使用此方法  From @"name" to @"name@2x".*/
- (NSString *)nt_stringByAppendingNameScale:(CGFloat)scale;
/**如果有后缀名使用此方法 From @"name.png" to @"name@2x.png".*/
- (NSString *)nt_stringByAppendingPathScale:(CGFloat)scale;

/**返回合适的scaled图片名，如在iphone6p下,优先返回name@3x.type,然后是name@2x.type，最后是name.type*/
- (NSString *)nt_scaledNameWithType:(NSString *)type;

#pragma mark - blank(空白字符相关)

/**去除string中的首尾空白*/
- (NSString *)nt_stringByTrim;
/**判断字符串是否是空白：nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.*/
- (BOOL)nt_isNotBlank;

#pragma mark - contain(包含相关)

- (BOOL)nt_containsString:(NSString *)string;
/**
 1 controlCharacterSet//控制符 2 whitespaceCharacterSet 3 whitespaceAndNewlineCharacterSet//空格换行 4 decimalDigitCharacterSet//小数 5 letterCharacterSet//文字 6 lowercaseLetterCharacterSet//小写字母 7 uppercaseLetterCharacterSet//大写字母 8 nonBaseCharacterSet//非基础 9 alphanumericCharacterSet//字母数字10 decomposableCharacterSet//可分解11 illegalCharacterSet//非法12 punctuationCharacterSet//标点13 capitalizedLetterCharacterSet//大写14 symbolCharacterSet//符号15 newlineCharacterSet//换行符
 */
- (BOOL)nt_containsCharacterSet:(NSCharacterSet *)set;

#pragma mark - other

/**Returns an NSData using UTF-8 encoding.*/
@property (nonatomic, readonly) NSData *dataValue;
@property (nonatomic, readonly) NSRange rangeOfAll;
/**JSON字符串转JSON*/
@property (nonatomic, readonly) id jsonValue;

+ (NSString *)nt_stringWithUUID;
/** 给数字string添加逗号分隔符，自身带有逗号也没有关系，会自动处理,比如1234.5->1,234.5(用于计算器等)*/
- (NSString *)nt_insertCommaFornumberString;
/**删除逗号，返回float值*/
- (float)nt_deleteCommaFornumberValue;
/**给手机号码添加空格分隔符*/
- (NSString *)nt_addSeperatorForPhoneString;
/**汉字转拼音*/
- (NSString *)nt_getPinYinWithChineseString;

#pragma mark - Hex string

/**将16进制的hexString转为普通string*/
- (NSString *)nt_hexStringToString;

#pragma mark - 正则 方法

- (BOOL)nt_isNumber;

/**是否手机号码，只检测11位，防止误杀*/
- (BOOL)nt_isPhoneNumberBy11Num;

/**是否手机号码， 较为精确，可能会误杀*/
- (BOOL)nt_isMobileNumber;

- (BOOL)nt_isEmailAddress;

/**是否是身份证号码，简单检测*/
- (BOOL)nt_isSimpleVerifyIdentityCardNum;

/**是否是身份证号码，精确检测*/
- (BOOL)nt_accurateVerifyIDCardNumber;

- (BOOL)nt_isCarNumber;

- (BOOL)nt_isMacAddress;

- (BOOL)nt_isIPAddress;

- (BOOL)nt_isUrl;

- (BOOL)nt_isChinese;

- (BOOL)nt_isPostalcode;

- (BOOL)nt_isTaxNo;

- (BOOL)nt_isBankCard;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)nt_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     containDigtal   包含数字
 @param     containLowLetter   包含小写字母
 @param     containUpLetter   包含大写字母
 @param     containOtherCharacter   其他字符
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)nt_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
                 containDigtal:(BOOL)containDigtal
              containLowLetter:(BOOL)containLowLetter
               containUpLetter:(BOOL)containUpLetter
         containOtherCharacter:(nullable NSString *)containOtherCharacter
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;


@end


#define _NTStringBox(_v_) __NTStringBox(@encode(__typeof__((_v_))), (_v_))

static inline NSString * __NTStringBox(const char *type, ...){
    va_list v;
    va_start(v, type);
    NSString *obj = nil;
    if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = NSStringFromCGPoint(actual);
    }else if (strcmp(type, @encode(CGRect)) == 0) {
        CGRect actual = (CGRect)va_arg(v, CGRect);
        obj = NSStringFromCGRect(actual);
    }else if (strcmp(type, @encode(CGVector)) == 0) {
        CGVector actual = (CGVector)va_arg(v, CGVector);
        obj = NSStringFromCGVector(actual);
    }else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = NSStringFromCGSize(actual);
    }else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
        CGAffineTransform actual = (CGAffineTransform)va_arg(v, CGAffineTransform);
        obj = NSStringFromCGAffineTransform(actual);
    }else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
        UIEdgeInsets actual = (UIEdgeInsets)va_arg(v, UIEdgeInsets);
        obj = NSStringFromUIEdgeInsets(actual);
    }else if (strcmp(type, @encode(UIOffset)) == 0) {
        UIOffset actual = (UIOffset)va_arg(v, UIOffset);
        obj = NSStringFromUIOffset(actual);
    }else if (strcmp(type, @encode(SEL)) == 0) {
        SEL actual = (SEL)va_arg(v, SEL);
        obj = NSStringFromSelector(actual);
    }else if (strcmp(type, @encode(Class)) == 0) {
        Class actual = (Class)va_arg(v, Class);
        obj = NSStringFromClass(actual);
    }else if (strcmp(type, @encode(NSRange)) == 0) {
        NSRange actual = (NSRange)va_arg(v, NSRange);
        obj = NSStringFromRange(actual);
    }else if (strcmp(type, @encode(NSNull)) == 0){
        obj = @"Null";
    }else{
        id actual = va_arg(v, id);
        obj = [NSString stringWithFormat:@"%@", actual];
    }
    va_end(v);
    return obj;
}

NS_ASSUME_NONNULL_END
