//
//  WJHuanXinConversationStore.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinConversationStore.h"


@implementation WJHuanXinConversationStore

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)requestAllConversations:(dispatch_block_t)block {
    //获取所有会话
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    //会话排序
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           if(message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    [self.dataArray removeAllObjects];
    for (EMConversation *converstion in sorted) {
        WJHuanXinConversationModel *model = nil;
        model = [[WJHuanXinConversationModel alloc] initWithConversation:converstion];
        if (model) {
            [self.dataArray addObject:model];
        }
    }
    block();
}

- (void)deleteConversationsWithModel:(WJHuanXinConversationModel *)model {
    [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId isDeleteMessages:YES completion:nil];
}

@end
