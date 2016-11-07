//
//  WJHuanXinChatBaseController.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinChatBaseController.h"

@interface WJHuanXinChatBaseController ()<EMChatManagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) EMConversation *conversation;     //环信聊天会话
@property (nonatomic,strong) UITableView *tableView;            //列表

@end

@implementation WJHuanXinChatBaseController

#pragma mark - init

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType {
    self = [super init];
    if (self) {
        _conversation = [[EMClient sharedClient].chatManager getConversation:conversationChatter type:conversationType createIfNotExist:YES];
        [_conversation markAllMessagesAsRead:nil];
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _tableView;
}

#pragma mark - 生命周期

- (void)dealloc {
    //移除聊天会话
//    [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:YES completion:nil];
//    //移除代理
//    [[EMClient sharedClient] removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"send" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed)];
    self.navigationItem.rightBarButtonItem = rightItem;
        
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
    
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];

}


- (void)didReceiveHasDeliveredAcks:(NSArray *)aMessages {
    NSLog(@"收到消息");
}
- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    NSLog(@"会话列表发生改变");
}

#pragma mark - 事件监听

- (void)rightItemPressed {
    
    EMMessage *message = [EaseSDKHelper sendTextMessage:@"test test !~~"
                                                     to:self.conversation.conversationId
                                            messageType:EMChatTypeChat
                                             messageExt:nil];
    
    //发送消息
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        NSLog(@"%u",aMessage.status);
        if (!aError) {
            NSLog(@"消息发送成功");
        }
        else {
            NSLog(@"发送失败");
        }
    }];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    return cell;
}

#pragma mark - <EMChatManagerDelegate>

/**收到消息*/
- (void)messagesDidReceive:(NSArray *)aMessages {
    NSLog(@"收到消息");
    NSLog(@"%@",aMessages);
}

/**收到Cmd消息*/
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    NSLog(@"收到cmd消息");
}

/**收到已读回执*/
- (void)messagesDidRead:(NSArray *)aMessages {
    NSLog(@"对方已读");
}

/**收到消息送达回执*/
- (void)messagesDidDeliver:(NSArray *)aMessages {
    NSLog(@"消息送达");
}

/**消息状态发生变化*/
- (void)messageStatusDidChange:(EMMessage *)aMessage
                         error:(EMError *)aError {
    NSLog(@"消息状态改变。。。");
}

/**消息附件状态发生改变*/
- (void)messageAttachmentStatusDidChange:(EMMessage *)aMessage
                                   error:(EMError *)aError {
    NSLog(@"消息附件发送改变。。。");
}

#pragma mark - other

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
