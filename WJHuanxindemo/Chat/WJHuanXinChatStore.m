//
//  WJHuanXinChatStore.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinChatStore.h"

@class EaseAtTarget;    //如果要做组需要用的

@interface WJHuanXinChatStore ()<EMChatManagerDelegate> {
    dispatch_queue_t _messageQueue;  //消息队列
}

@end

@implementation WJHuanXinChatStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.messageCountOfPage = 50; //默认50
    }
    return self;
}

#pragma mark - 懒加载

- (NSMutableArray *)messsagesSource {
    if (!_messsagesSource) {
        _messsagesSource = [NSMutableArray array];
    }
    return _messsagesSource;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)getConversationChatter:(NSString *)conversationChatter {
    _conversation = [[EMClient sharedClient].chatManager getConversation:conversationChatter type:EMConversationTypeChat createIfNotExist:YES];
    //将所有的消息置为已读
    [_conversation markAllMessagesAsRead:nil];
}

- (void)startConversation {
    [self createmessageQueue];
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}
//创建消息异步线程
- (void)createmessageQueue {
    _messageQueue = dispatch_queue_create("wjhuanxin.tqh.com", NULL);
}

#pragma mark - 这里需要调整好

- (void)tableViewDidTriggerHeaderRefresh {
    NSString *messageId = nil;
    if ([self.messsagesSource count] > 0) {
        messageId = [(EMMessage *)self.messsagesSource.firstObject messageId];
    }
    else {
        messageId = nil;
    }
    [self _loadMessagesBefore:messageId count:self.messageCountOfPage append:YES];
}

//从数据库里面加在数据显示出来
- (void)_loadMessagesBefore:(NSString*)messageId
                      count:(NSInteger)count
                     append:(BOOL)isAppend {
    
    __weak typeof(self) weakSelf = self;
    void (^refresh)(NSArray *messages) = ^(NSArray *messages) {
        dispatch_async(_messageQueue, ^{
            //模型格式转换
            NSArray *formattedMessages = [weakSelf formatMessages:messages];
            //刷新页面
            dispatch_async(dispatch_get_main_queue(), ^{
                NSInteger scrollToIndex = 0;
                if (isAppend) {
                     [weakSelf.messsagesSource insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
                    //Combine the message
                    id object = [weakSelf.dataArray firstObject];
                    if ([object isKindOfClass:[NSString class]]) {
                        NSString *timestamp = object;
                        [formattedMessages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                            if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model]) {
                                [weakSelf.dataArray removeObjectAtIndex:0];
                                *stop = YES;
                            }
                        }];
                    }
                    scrollToIndex = [weakSelf.dataArray count];
                    [weakSelf.dataArray insertObjects:formattedMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formattedMessages count])]];
                }
                else {
                    [weakSelf.messsagesSource removeAllObjects];
                    [weakSelf.messsagesSource addObjectsFromArray:messages];
                    
                    [weakSelf.dataArray removeAllObjects];
                    [weakSelf.dataArray addObjectsFromArray:formattedMessages];
                }
                
                EMMessage *latest = [weakSelf.messsagesSource lastObject];
                weakSelf.messageTimeIntervalTag = latest.timestamp;
#warning - 暂时将tableView写在这里
                [weakSelf.tableView reloadData];
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - scrollToIndex - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
            });
            //re-download all messages that are not successfully downloaded
            for (EMMessage *message in messages)
            {
                [weakSelf _downloadMessageAttachments:message];
            }
            
            //send the read acknoledgement
            [weakSelf _sendHasReadResponseForMessages:messages
                                               isRead:NO];
            
        });
    };
    
    //加载数据库
    [self.conversation loadMessagesStartFromId:messageId count:(int)count searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        if (!aError && [aMessages count]) {
            refresh(aMessages);
        }
    }];
}

//下载消息附件
- (void)_downloadMessageAttachments:(EMMessage *)message {
    __weak typeof(self) weakSelf = self;
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error)
        {
            [weakSelf _reloadTableViewDataWithMessage:message];
        }
        else
        {
            NSLog(@"%@：消息图片获取失败",[self class]);
//            [weakSelf showHint:NSEaseLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
        }
    };
    EMMessageBody *messageBody = message.body;
    if ([messageBody type] == EMMessageBodyTypeImage) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)messageBody;
        if (imageBody.thumbnailDownloadStatus > EMDownloadStatusSuccessed)
        {
            //download the message thumbnail
            [[[EMClient sharedClient] chatManager] downloadMessageThumbnail:message progress:nil completion:completion];
        }
    }
    else if ([messageBody type] == EMMessageBodyTypeVideo)
    {
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)messageBody;
        if (videoBody.thumbnailDownloadStatus > EMDownloadStatusSuccessed)
        {
            //download the message thumbnail
            [[[EMClient sharedClient] chatManager] downloadMessageThumbnail:message progress:nil completion:completion];
        }
    }
    else if ([messageBody type] == EMMessageBodyTypeVoice)
    {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)messageBody;
        if (voiceBody.downloadStatus > EMDownloadStatusSuccessed)
        {
            //download the message attachment
            [[EMClient sharedClient].chatManager downloadMessageAttachment:message progress:nil completion:^(EMMessage *message, EMError *error) {
                if (!error) {
                    [weakSelf _reloadTableViewDataWithMessage:message];
                }
                else {
                    NSLog(@"%@：音频获取失败",[self class]);
//                    [weakSelf showHint:NSEaseLocalizedString(@"message.voiceFail", @"voice for failure!")];
                }
            }];
        }
    }
}
#pragma mark - 私有方法

- (void)_reloadTableViewDataWithMessage:(EMMessage *)message {
    if ([self.conversation.conversationId isEqualToString:message.conversationId])
    {
        for (int i = 0; i < self.dataArray.count; i ++) {
            id object = [self.dataArray objectAtIndex:i];
            if ([object isKindOfClass:[EaseMessageModel class]]) {
                id<IMessageModel> model = object;
                if ([message.messageId isEqualToString:model.messageId]) {
                    
                    //                    id<IMessageModel> model = nil;
                    //                    if (self.dataSource && [self.dataSource respondsToSelector:@selector(messageViewController:modelForMessage:)]) {
                    //                        model = [self.dataSource messageViewController:self modelForMessage:message];
                    //                    }
                    //                    else{
                    //                        model = [[EaseMessageModel alloc] initWithMessage:message];
                    //                        model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
                    //                        model.failImageName = @"imageDownloadFail";
                    //                    }
                    
                    EaseMessageModel *model = [[EaseMessageModel alloc]initWithMessage:message];
                    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
                    model.failImageName = @"imageDownloadFail";
#warning - 暂时在这里写tableView
                    [self.tableView beginUpdates];
                    [self.dataArray replaceObjectAtIndex:i withObject:model];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView endUpdates];
                    break;
                }
            }
        }
    }
}

//更新消息状态
- (void)_updateMessageStatus:(EMMessage *)aMessage {
    BOOL isChatting = [aMessage.conversationId isEqualToString:self.conversation.conversationId];
    if (aMessage && isChatting) {
        
//        id<IMessageModel> model = nil;
//        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:modelForMessage:)]) {
//            model = [_dataSource messageViewController:self modelForMessage:aMessage];
//        }
//        else{
//            model = [[EaseMessageModel alloc] initWithMessage:aMessage];
//            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
//            model.failImageName = @"imageDownloadFail";
//        }
        
        EaseMessageModel *model = [[EaseMessageModel alloc]initWithMessage:aMessage];
        model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
        model.failImageName = @"imageDownloadFail";
        if (model) {
            __block NSUInteger index = NSNotFound;
            [self.dataArray enumerateObjectsUsingBlock:^(EaseMessageModel *model, NSUInteger idx, BOOL *stop){
                if ([model conformsToProtocol:@protocol(IMessageModel)]) {
                    if ([aMessage.messageId isEqualToString:model.message.messageId])
                    {
                        index = idx;
                        *stop = YES;
                    }
                }
            }];
#warning - 暂时在这里写tableView
            if (index != NSNotFound)
            {
                [self.dataArray replaceObjectAtIndex:index withObject:model];
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            }
        }
    }
}

#pragma mark - 发送消息

- (void)_refreshAfterSentMessage:(EMMessage*)aMessage {
    
    if ([self.messsagesSource count] && [EMClient sharedClient].options.sortMessageByServerTime) {
        NSString *msgId = aMessage.messageId;
        EMMessage *last = self.messsagesSource.lastObject;
        if ([last isKindOfClass:[EMMessage class]]) {
            
            __block NSUInteger index = NSNotFound;
            index = NSNotFound;
            [self.messsagesSource enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(EMMessage *obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[EMMessage class]] && [obj.messageId isEqualToString:msgId]) {
                    index = idx;
                    *stop = YES;
                }
            }];
            if (index != NSNotFound) {
                [self.messsagesSource removeObjectAtIndex:index];
                [self.messsagesSource addObject:aMessage];
#warning - 暂时在这里写tableView
                //格式化消息
                self.messageTimeIntervalTag = -1;
                NSArray *formattedMessages = [self formatMessages:self.messsagesSource];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:formattedMessages];
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                return;
            }
        }
    }
    [self.tableView reloadData];
}

//发送消息（可发送任何消息）
- (void)_sendMessage:(EMMessage *)message
{
    if (self.conversation.type == EMConversationTypeGroupChat){
        message.chatType = EMChatTypeGroupChat;
    }
    else if (self.conversation.type == EMConversationTypeChatRoom){
        message.chatType = EMChatTypeChatRoom;
    }
    
    //将消息添加到消息数组
    [self addMessageToDataSource:message
                        progress:nil];
    
    __weak typeof(self) weakself = self;
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        NSLog(@"%@",aError.errorDescription);
        if (!aError) {
            [weakself _refreshAfterSentMessage:aMessage];
        }
        else {
            [weakself.tableView reloadData];
        }
    }];
}

//发送文本消息（这里主要判断是不是组，我这里不用判断，暂时写单聊功能）
- (void)sendTextMessage:(NSString *)text
{
    NSDictionary *ext = nil;
    [self sendTextMessage:text withExt:ext];
}

//发送文本消息
- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary*)ext
{
    EMMessage *message = [EaseSDKHelper sendTextMessage:text
                                                     to:self.conversation.conversationId
                                            messageType:[self _messageTypeFromConversationType]
                                             messageExt:ext];
    [self _sendMessage:message];
}

//发送地理位置消息
- (void)sendLocationMessageLatitude:(double)latitude
                          longitude:(double)longitude
                         andAddress:(NSString *)address
{
    EMMessage *message = [EaseSDKHelper sendLocationMessageWithLatitude:latitude
                                                              longitude:longitude
                                                                address:address
                                                                     to:self.conversation.conversationId
                                                            messageType:[self _messageTypeFromConversationType]
                                                             messageExt:nil];
    [self _sendMessage:message];
}

//发送图片Data消息
- (void)sendImageMessageWithData:(NSData *)imageData
{
//    id progress = nil;
//    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:progressDelegateForMessageBodyType:)]) {
//        progress = [_dataSource messageViewController:self progressDelegateForMessageBodyType:EMMessageBodyTypeImage];
//    }
//    else{
//        progress = self;
//    }
    
    EMMessage *message = [EaseSDKHelper sendImageMessageWithImageData:imageData
                                                                   to:self.conversation.conversationId
                                                          messageType:[self _messageTypeFromConversationType]
                                                           messageExt:nil];
    [self _sendMessage:message];
}

//发送图片Image消息
- (void)sendImageMessage:(UIImage *)image
{
//    id progress = nil;
//    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:progressDelegateForMessageBodyType:)]) {
//        progress = [_dataSource messageViewController:self progressDelegateForMessageBodyType:EMMessageBodyTypeImage];
//    }
//    else{
//        progress = self;
//    }
    
    EMMessage *message = [EaseSDKHelper sendImageMessageWithImage:image
                                                               to:self.conversation.conversationId
                                                      messageType:[self _messageTypeFromConversationType]
                                                       messageExt:nil];
    [self _sendMessage:message];
}

//发送语音消息
- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(NSInteger)duration
{
//    id progress = nil;
//    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:progressDelegateForMessageBodyType:)]) {
//        progress = [_dataSource messageViewController:self progressDelegateForMessageBodyType:EMMessageBodyTypeVoice];
//    }
//    else{
//        progress = self;
//    }
    
    EMMessage *message = [EaseSDKHelper sendVoiceMessageWithLocalPath:localPath
                                                             duration:duration
                                                                   to:self.conversation.conversationId
                                                          messageType:[self _messageTypeFromConversationType]
                                                           messageExt:nil];
    [self _sendMessage:message];
}

//发送视频消息
- (void)sendVideoMessageWithURL:(NSURL *)url
{
//    id progress = nil;
//    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:progressDelegateForMessageBodyType:)]) {
//        progress = [_dataSource messageViewController:self progressDelegateForMessageBodyType:EMMessageBodyTypeVideo];
//    }
//    else{
//        progress = self;
//    }
    
    EMMessage *message = [EaseSDKHelper sendVideoMessageWithURL:url
                                                             to:self.conversation.conversationId
                                                    messageType:[self _messageTypeFromConversationType]
                                                     messageExt:nil];
    [self _sendMessage:message];
}

#pragma mark - <EMChatManagerDelegate>

- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    NSLog(@"会话列表发生改变");
}

/**收到消息*/
- (void)messagesDidReceive:(NSArray *)aMessages {
    for (EMMessage *message in aMessages) {
        if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
            //添加消息到消息数组
            [self addMessageToDataSource:message progress:nil];
            //发送消息已读回执
            [self _sendHasReadResponseForMessages:@[message]
                                           isRead:NO];
            
            //将收到的消息置为已读（在后台情况下为NO）
            if ([self _shouldMarkMessageAsRead])
            {
                [self.conversation markMessageAsReadWithId:message.messageId error:nil];
            }
        }
    }
    NSLog(@"聊天界面:收到消息");
//    NSLog(@"聊天界面:%@",aMessages);
}

/**收到Cmd消息*/
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    for (EMMessage *message in aCmdMessages) {
        if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
            NSLog(@"聊天界面:收到cmd消息");
            break;
        }
    }
}

/**收到已读回执*/
- (void)messagesDidRead:(NSArray *)aMessages {
    NSLog(@"聊天界面:对方已读");
    for (EMMessage *message in aMessages) {
        if (![self.conversation.conversationId isEqualToString:message.conversationId]){
            continue;
        }
        
        __block id<IMessageModel> model = nil;
        __block BOOL isHave = NO;
        //将所有消息设置为已经收到阅读回执
        [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             if ([obj conformsToProtocol:@protocol(IMessageModel)])
             {
                 model = (id<IMessageModel>)obj;
                 if ([model.messageId isEqualToString:message.messageId])
                 {
                     model.message.isReadAcked = YES;
                     isHave = YES;
                     *stop = YES;
                 }
             }
         }];
        
        if(!isHave){
            return;
        }
        
//        if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:didReceiveHasReadAckForModel:)]) {
//            [_delegate messageViewController:self didReceiveHasReadAckForModel:model];
//        }
//        else{
//            [self.tableView reloadData];
//        }
        [self.tableView reloadData];
    }
}

/**收到消息送达回执*/
- (void)messagesDidDeliver:(NSArray *)aMessages {
    NSLog(@"聊天界面:消息送达");
    for(EMMessage *message in aMessages){
        [self _updateMessageStatus:message];
    }
}

/**消息状态发生变化*/
- (void)messageStatusDidChange:(EMMessage *)aMessage
                         error:(EMError *)aError {
    NSLog(@"聊天界面:消息状态改变。。。");
    [self _updateMessageStatus:aMessage];
}

/**消息附件状态发生改变*/
- (void)messageAttachmentStatusDidChange:(EMMessage *)aMessage
                                   error:(EMError *)aError {
    NSLog(@"聊天界面:消息附件发送改变。。。");
    if (!aError) {
        //如果成功就刷新那条cell
        EMFileMessageBody *fileBody = (EMFileMessageBody*)[aMessage body];
        if ([fileBody type] == EMMessageBodyTypeImage) {
            EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
            if ([imageBody thumbnailDownloadStatus] == EMDownloadStatusSuccessed)
            {
                [self _reloadTableViewDataWithMessage:aMessage];
            }
        }else if([fileBody type] == EMMessageBodyTypeVideo){
            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)fileBody;
            if ([videoBody thumbnailDownloadStatus] == EMDownloadStatusSuccessed)
            {
                [self _reloadTableViewDataWithMessage:aMessage];
            }
        }else if([fileBody type] == EMMessageBodyTypeVoice){
            if ([fileBody downloadStatus] == EMDownloadStatusSuccessed)
            {
                [self _reloadTableViewDataWithMessage:aMessage];
            }
        }
        
    }else{
        
    }
}


#pragma mark - handler

- (BOOL)_shouldMarkMessageAsRead
{
    BOOL isMark = YES;
//    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewControllerShouldMarkMessagesAsRead:)]) {
//        isMark = [_dataSource messageViewControllerShouldMarkMessagesAsRead:self];
//    }
//    else{
//        if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || !self.isViewDidAppear)
//        {
//            isMark = NO;
//        }
//    }
    //判断是不是在后台，在后台的话不标记为收藏
    if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || !self.isViewDidAppear)
    {
        isMark = NO;
    }
    return isMark;
}


- (BOOL)shouldSendHasReadAckForMessage:(EMMessage *)message
                                  read:(BOOL)read
{
    NSString *account = [[EMClient sharedClient] currentUsername];
    if (message.chatType != EMChatTypeChat || message.isReadAcked || [account isEqualToString:message.from] || ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || !self.isViewDidAppear)
    {
        return NO;
    }
    
    EMMessageBody *body = message.body;
    if (((body.type == EMMessageBodyTypeVideo) ||
         (body.type == EMMessageBodyTypeVoice) ||
         (body.type == EMMessageBodyTypeImage)) &&
        !read)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

//发送消息回执
- (void)_sendHasReadResponseForMessages:(NSArray*)messages
                                 isRead:(BOOL)isRead {
    NSMutableArray *unreadMessages = [NSMutableArray array];
    for (NSInteger i = 0; i < [messages count]; i++)
    {
        EMMessage *message = messages[i];
        BOOL isSend = YES;
        //        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:shouldSendHasReadAckForMessage:read:)]) {
        //            isSend = [_dataSource messageViewController:self
        //                         shouldSendHasReadAckForMessage:message read:isRead];
        //        }
        //        else{
        //            isSend = [self shouldSendHasReadAckForMessage:message
        //                                                     read:isRead];
        //        }
        isSend = [self shouldSendHasReadAckForMessage:message
                                                 read:isRead];
        
        if (isSend)
        {
            [unreadMessages addObject:message];
        }
    }
    
    if ([unreadMessages count])
    {
        for (EMMessage *message in unreadMessages)
        {
            [[EMClient sharedClient].chatManager sendMessageReadAck:message completion:nil];
        }
    }
}

#pragma mark - other

//获取会话类型
- (EMChatType)_messageTypeFromConversationType
{
    EMChatType type = EMChatTypeChat;
    switch (self.conversation.type) {
        case EMConversationTypeChat:
            type = EMChatTypeChat;
            break;
        case EMConversationTypeGroupChat:
            type = EMChatTypeGroupChat;
            break;
        case EMConversationTypeChatRoom:
            type = EMChatTypeChatRoom;
            break;
        default:
            break;
    }
    return type;
}


//添加消息到消息数组，发送消息，收到消息会调用
-(void)addMessageToDataSource:(EMMessage *)message
                     progress:(id)progress {
    //添加发送or收到的消息
    [self.messsagesSource addObject:message];
    //将消息转换为数据加在到tableView中，刷新。。。
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf formatMessages:@[message]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.dataArray addObjectsFromArray:messages];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    });
}

//将环信的消息转化为cell中的消息模型
- (NSArray *)formatMessages:(NSArray *)messages {
    NSMutableArray *formattedArray = [[NSMutableArray alloc] init];
    if ([messages count] == 0) {
        return formattedArray;
    }
    for (EMMessage *message in messages) {
        //计算时间戳
        CGFloat interval = (self.messageTimeIntervalTag - message.timestamp) / 1000;
        if (self.messageTimeIntervalTag < 0 || interval > 60 || interval < -60) {
            NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSString *timeStr = @"";
            
            //            if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:stringForDate:)]) {
            //                timeStr = [_dataSource messageViewController:self stringForDate:messageDate];
            //            }
            //            else{
            //                timeStr = [messageDate formattedTime];
            //            }
            
            //得到时间字符串
            timeStr = [messageDate formattedTime];
            [formattedArray addObject:timeStr];
            self.messageTimeIntervalTag = message.timestamp;
        }
        //创建消息模型
        EaseMessageModel *model = [[EaseMessageModel alloc]initWithMessage:message];
        model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
        model.failImageName = @"imageDownloadFail";
        if (model) {
            [formattedArray addObject:model];
        }
    }
    return formattedArray;
}
@end
