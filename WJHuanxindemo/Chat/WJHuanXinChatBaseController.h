//
//  WJHuanXinChatBaseController.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJHuanXinChatStore.h"
/***环信聊天控制器最底层的*/
@interface WJHuanXinChatBaseController : UIViewController

@property (nonatomic) BOOL isPlayingAudio;  //正在播放音乐
@property (nonatomic,strong) WJHuanXinChatStore *store;         //数据配置管理
/**初始化--传入会话ID（单聊就是用户名称，会话类型是单聊）*/

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType;

@end
