//
//  NSString+WJAdditions.m
//  moyouAPP
//
//  Created by 幻想无极（谭启宏） on 16/8/12.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "NSString+WJAdditions.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSData+WJAdditions.h"
#import "NSDictionary+WJAdditions.h"

@implementation NSString (WJAdditions)


#pragma mark - UUID

+ (NSString *)UUIDString
{
    CFUUIDRef UUIDRef = CFUUIDCreate(NULL);
    
    NSString *string = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, UUIDRef);
    
    if ( UUIDRef ) {
        CFRelease(UUIDRef);
        UUIDRef = NULL;
    }
    
    return string;
}



#pragma mark - Validity

- (BOOL)isDecimalNumber
{
    return [self isInCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
}

- (BOOL)isWhitespaceAndNewline
{
    return [self isInCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (BOOL)isInCharacterSet:(NSCharacterSet *)characterSet
{
    for ( int i=0; i<[self length]; ++i ) {
        unichar c = [self characterAtIndex:i];
        if ( ![characterSet characterIsMember:c] ) {
            return NO;
        }
    }
    return YES;
}



#pragma mark - Hash

- (NSString *)MD5HashString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] MD5HashString];
}

- (NSString *)SHA1HashString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] SHA1HashString];
}



#pragma mark - URL

- (NSString *)URLEncodedString
{
//    [self stringByAddingPercentEncodingWithAllowedCharacters:@""];
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]<>"),
                                                                                 kCFStringEncodingUTF8);
}

- (NSString *)URLDecodedString
{
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                 (__bridge CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8);
}



- (NSDictionary *)queryDictionary
{
    
    NSString *string = self;
    
    NSRange range = [self rangeOfString:@"?"];
    if ( range.location != NSNotFound ) {
        NSUInteger idx = range.location + range.length;
        string = [self substringFromIndex:idx];
    }
    
    NSArray *pairs = [string componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    for ( NSString *pair in pairs ) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if ( [kv count] == 2 ) {
            NSString *key = [kv objectAtIndex:0];
            NSString *value = [[kv objectAtIndex:1] URLDecodedString];
            [dictionary setObject:value forKey:key];
        }
    }
    
    if ( [dictionary count] > 0 ) {
        return dictionary;
    }
    
    return nil;
}

- (NSString *)stringByAddingQueryDictionary:(NSDictionary *)dictionary
{
    NSString *query = [dictionary queryString];
    
    if ( [query length] > 0 ) {
        
        NSMutableString *string = [[NSMutableString alloc] initWithString:self];
        
        if ( [string rangeOfString:@"?"].location == NSNotFound ) {
            [string appendString:@"?"];
        }
        
        if (![string hasSuffix:@"&"]
            && ![string hasSuffix:@"?"])
        {
            [string appendString:@"&"];
        }
        
        [string appendString:query];
        
        return string;
    }
    return self;
}

- (NSString *)stringByAppendingValue:(NSString *)value forKey:(NSString *)key
{
    if ( [key length] > 0 ) {
        
        NSString *newValue = (value) ? value : @"";
        NSMutableString *string = [[NSMutableString alloc] initWithString:self];
        
        if ( [string rangeOfString:@"?"].location == NSNotFound ) {
            [string appendString:@"?"];
        }
        
        if (![string hasSuffix:@"&"]
            && ![string hasSuffix:@"?"])
        {
            [string appendString:@"&"];
        }
        
        [string appendFormat:@"%@=%@", key, newValue];
        
        return string;
        
    }
    return self;
}


#pragma mark - MIME Types

- (NSString *)MIMEType
{
    CFStringRef UTIType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                                (__bridge CFStringRef)[self pathExtension],
                                                                NULL);
    
    NSString *MIMEType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(UTIType, kUTTagClassMIMEType);
    if ( UTIType ) {
        CFRelease(UTIType);
    }
    
    if ( [MIMEType length] <= 0 ) {
        return @"application/octet-stream";
    }
    
    return MIMEType;
}


- (BOOL)isEmailAddress {
    if([self length] <= 0)
        return NO;
    NSString *regularExpression =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpression];
    return [predicate evaluateWithObject:[self lowercaseString]];
}

- (BOOL)isLetters{
    if([self length] <= 0)
        return NO;
    NSString *regex = @"[a-zA-Z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isNumbers{
    if([self length] <= 0)
        return NO;
    NSString *regex = @"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isNumberOrLetters{
    if([self length] <= 0)
        return NO;
    NSString *regex = @"[a-zA-Z0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

+(BOOL)CheckPhonenumberInput:(NSString *)_text{
    NSString *Regex = @"1\\d{10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:_text];
}


@end
