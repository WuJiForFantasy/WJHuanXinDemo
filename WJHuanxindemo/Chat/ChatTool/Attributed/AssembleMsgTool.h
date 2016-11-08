//
//  AssembleeMsgTool.h
//  DoctorChat
//
//  Created by 王鹏 on 13-2-28.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**组装消息工具*/
@interface AssembleMsgTool : NSObject

//取得组装后的数组
+ (NSMutableArray *)getAssembleArrayWithStr:(NSString *)msgstr;

//判断是否是表情字符串
+ (BOOL)isFaceStr:(NSString *)str;

//取得表情字符串数组
+ (NSArray *)getFaceArray;

//通过文字转换为表情字符串（类似：［"哈哈"］）
+ (NSString *)getFaceImageWithStr:(NSString *)str;

@end
