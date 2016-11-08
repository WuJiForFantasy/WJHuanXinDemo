//
//  WJHuanXinChatHelper.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinChatHelper.h"

static WJHuanXinChatHelper *helper = nil;

@interface WJHuanXinChatHelper () <EMClientDelegate,EMChatManagerDelegate>

@end

@implementation WJHuanXinChatHelper

+ (instancetype)shareHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[WJHuanXinChatHelper alloc] init];
    });
    return helper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initHelper];
    }
    return self;
}

- (void)initHelper {
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

- (void)asyncConversationFromDB {
    //暂时没有写
}

#pragma mark - <EMClientDelegate>

/**网络链接状态改变*/
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState {
    NSLog(@"%@:网络连接状态--%@",[self class],!aConnectionState?@"已经连接":@"没有连接");
}

/**自动登录失败*/
- (void)autoLoginDidCompleteWithError:(EMError *)error {
    NSLog(@"%@:自动登录失败",[self class]);
}

/**当前账号在其他设备登录*/
- (void)userAccountDidLoginFromOtherDevice {
    NSLog(@"%@:当前账号在其他设备登录",[self class]);
}

/**当前账号已被服务端删除*/
- (void)userAccountDidRemoveFromServer {
    NSLog(@"%@:当前账号已被服务器端删除",[self class]);
}

/**服务器被禁用*/
- (void)userDidForbidByServer {
    NSLog(@"%@:服务器被禁用",[self class]);
}

#pragma mark - <EMChatManagerDelegate>

/**会话列表改变,只有新增或者删除会话列表才会走这里*/
- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    NSLog(@"%@:会话状态改变",[self class]);
    if (self.mainVC) {
//        [_mainVC setupUnreadMessageCount];
        //更新小气泡
    }
    
    if (self.conversationListVC) {
        [_conversationListVC refreshDataSource];
    }
}

/**收到普通消息*/
- (void)messagesDidReceive:(NSArray *)aMessages {
    NSLog(@"%@:收到普通消息",[self class]);
//    BOOL isRefreshCons = YES;
//    for(EMMessage *message in aMessages){
//        BOOL needShowNotification = (message.chatType != EMChatTypeChat) ? [self _needShowNotification:message.conversationId] : YES;
//    }
    //总的判断
}

/**收到命令消息*/
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    NSLog(@"%@:收到命令消息",[self class]);
}

/**已经发送的消息对方已经读的回调*/
- (void)messagesDidRead:(NSArray *)aMessages {
    NSLog(@"%@:对方已读",[self class]);
}

/**附件消息状态改变*/
- (void)messageAttachmentStatusDidChange:(EMMessage *)aMessage
                                   error:(EMError *)aError {
    NSLog(@"%@:附件消息改变",[self class]);
}

#pragma mark - other

- (BOOL)_needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getGroupsWithoutPushNotification:nil];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    return ret;
}
@end
