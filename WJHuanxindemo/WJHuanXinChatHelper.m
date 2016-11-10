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

//刷新会话列表和底部的小圆点
- (void)asyncConversationFromDB
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[EMClient sharedClient].chatManager getAllConversations];
        [array enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL *stop){
            if(conversation.latestMessage == nil){
                [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:NO completion:nil];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakself.conversationListVC) {
                [weakself.conversationListVC refreshDataSource];
            }
            
            if (weakself.mainVC) {
                [weakself.mainVC.store setupUnreadMessageCount];
            }
        });
    });
}

- (void)setupUnreadMessageCount {
    if (self.mainVC) {
        [self.mainVC.store setupUnreadMessageCount];
    }
}

#pragma mark - <EMClientDelegate>

/**网络链接状态改变*/
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState {
    NSLog(@"%@:网络连接状态--%@",[self class],!aConnectionState?@"已经连接":@"没有连接");

     [self.mainVC.store networkChanged:aConnectionState];
}

/**自动登录失败*/
- (void)autoLoginDidCompleteWithError:(EMError *)error {
    
    if (error) {
        NSLog(@"%@:自动登录失败",[self class]);
    } else if([[EMClient sharedClient] isConnected]){
        NSLog(@"%@:进入主界面",[self class]);
    }
}

/**当前账号在其他设备登录*/
- (void)userAccountDidLoginFromOtherDevice {
    NSLog(@"%@:当前账号在其他设备登录",[self class]);
     [self _clearHelper];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

/**当前账号已被服务端删除*/
- (void)userAccountDidRemoveFromServer {
    NSLog(@"%@:当前账号已被服务器端删除",[self class]);
     [self _clearHelper];
     [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

/**服务器被禁用*/
- (void)userDidForbidByServer {
    NSLog(@"%@:服务器被禁用",[self class]);
     [self _clearHelper];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    
}

#pragma mark - <EMChatManagerDelegate>

/**会话列表改变,只有新增或者删除会话列表才会走这里*/
- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    NSLog(@"%@:会话状态改变",[self class]);
    if (self.mainVC) {
        [_mainVC.store setupUnreadMessageCount];
    }
    
    if (self.conversationListVC) {
        [_conversationListVC refreshDataSource];
    }
}
//- (void)cleanBadgeNum {
//    if (self.mainVC) {
//        [_mainVC.store setupCleanUnreadMessageCount];
//    }
//    
//}

///**收到普通消息*/
- (void)messagesDidReceive:(NSArray *)aMessages {
    NSLog(@"%@:收到普通消息",[self class]);
    BOOL isRefreshCons = YES;
    
   
    for(EMMessage *message in aMessages){
        BOOL needShowNotification = (message.chatType != EMChatTypeChat) ? [self _needShowNotification:message.conversationId] : YES;
        
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
            switch (state) {
                case UIApplicationStateActive:
                    [self.mainVC.store playSoundAndVibration];
                    break;
                case UIApplicationStateInactive:
                    [self.mainVC.store playSoundAndVibration];
                    break;
                case UIApplicationStateBackground:
                    [self.mainVC.store showNotificationWithMessage:message];
                    break;
                default:
                    break;
            }
#endif
        }
        
        if (_chatVC == nil) {
            _chatVC = [self _getCurrentChatView];
        }
        
        BOOL isChatting = NO;
        if (_chatVC) {
            //判断会话id是否相同
            isChatting = [message.conversationId isEqualToString:_chatVC.store.conversation.conversationId];
        }
        if (_chatVC == nil || !isChatting || state == UIApplicationStateBackground) {
            [self _handleReceivedAtMessage:message];
            
            if (self.conversationListVC) {
                [_conversationListVC refresh];
            }
            
            if (self.mainVC) {
                [_mainVC.store setupUnreadMessageCount];
            }
            return;
        }
        
        if (isChatting) {
            isRefreshCons = NO;
        }
    }
    if (isRefreshCons) {
        if (self.conversationListVC) {
            [_conversationListVC refresh];
        }
        
        if (self.mainVC) {
            [_mainVC.store setupUnreadMessageCount];
        }
    }
}

///**收到命令消息*/
//- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
//    NSLog(@"%@:收到命令消息",[self class]);
//}
//
/**已经发送的消息对方已经读的回调*/
//- (void)messagesDidRead:(NSArray *)aMessages {
//    NSLog(@"%@:对方已读",[self class]);
//}

///**附件消息状态改变*/
//- (void)messageAttachmentStatusDidChange:(EMMessage *)aMessage
//                                   error:(EMError *)aError {
//    NSLog(@"%@:附件消息改变",[self class]);
//}

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

- (WJHuanXinChatBaseController*)_getCurrentChatView
{
    //遍历会话列表中的导航栏
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.mainVC.navigationController.viewControllers];
    WJHuanXinChatBaseController *chatViewContrller = nil;
    for (id viewController in viewControllers)
    {
        if ([viewController isMemberOfClass:[WJHuanXinChatBaseController class]])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    return chatViewContrller;
}
- (void)_handleReceivedAtMessage:(EMMessage*)aMessage {
    if (aMessage.chatType != EMChatTypeGroupChat || aMessage.direction != EMMessageDirectionReceive) {
        return;
    }
}

//退出登录
- (void)_clearHelper {
    self.mainVC = nil;
    self.conversationListVC = nil;
    self.chatVC = nil;
    
    [[EMClient sharedClient] logout:NO];
}

@end
