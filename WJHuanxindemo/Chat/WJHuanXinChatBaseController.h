//
//  WJHuanXinChatBaseController.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <UIKit/UIKit.h>

/***环信聊天控制器*/
@interface WJHuanXinChatBaseController : UIViewController

/**初始化--传入会话ID（单聊就是用户名称，会话类型是单聊）*/

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType;

@end
