//
//  WJHuanXinChatHelper.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainController.h"
#import "WJHuanXinConversationListController.h"
/**WJ环信聊天帮助*/

@interface WJHuanXinChatHelper : NSObject

@property (nonatomic, weak) WJHuanXinConversationListController *conversationListVC;

@property (nonatomic, weak) MainController *mainVC;

/**单例*/
+ (instancetype)shareHelper;

/**异步获取从数据库会话*/

- (void)asyncConversationFromDB;

@end
