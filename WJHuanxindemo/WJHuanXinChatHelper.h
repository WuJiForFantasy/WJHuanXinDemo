//
//  WJHuanXinChatHelper.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <Foundation/Foundation.h>

/**WJ环信聊天帮助*/

@interface WJHuanXinChatHelper : NSObject

/**单例*/
+ (instancetype)shareHelper;

- (void)asyncConversationFromDB;

@end
