//
//  NSString+WJAdditions.h
//  moyouAPP
//
//  Created by 幻想无极（谭启宏） on 16/8/12.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WJAdditions)

///-------------------------------
/// UUID
///-------------------------------

+ (NSString *)UUIDString;


///-------------------------------
/// Validity
///-------------------------------

- (BOOL)isDecimalNumber;

- (BOOL)isWhitespaceAndNewline;


- (BOOL)isInCharacterSet:(NSCharacterSet *)characterSet;


///-------------------------------
/// Hash
///-------------------------------

- (NSString *)MD5HashString;

- (NSString *)SHA1HashString;


///-------------------------------
/// URL
///-------------------------------

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (NSDictionary *)queryDictionary;
- (NSString *)stringByAddingQueryDictionary:(NSDictionary *)dictionary;
- (NSString *)stringByAppendingValue:(NSString *)value forKey:(NSString *)key;


///-------------------------------
/// MIME types
///-------------------------------

- (NSString *)MIMEType;

- (BOOL)isEmailAddress;
- (BOOL)isLetters;
- (BOOL)isNumbers;
- (BOOL)isNumberOrLetters;
+(BOOL)CheckPhonenumberInput:(NSString *)_text;

@end
