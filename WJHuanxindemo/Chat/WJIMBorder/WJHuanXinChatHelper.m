//
//  WJHuanXinChatHelper.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/9.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinChatHelper.h"

@implementation WJHuanXinChatHelper

+ (NSRegularExpression *)regexEmoticon {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

@end
