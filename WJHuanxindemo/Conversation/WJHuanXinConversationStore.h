//
//  WJHuanXinConversationStore.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJHuanXinConversationModel.h"

@interface WJHuanXinConversationStore : NSObject

@property (nonatomic,strong)NSMutableArray *dataArray;//会话数据

//请求所有会话
- (void)requestAllConversations:(dispatch_block_t)block;

- (void)deleteConversationsWithModel:(WJHuanXinConversationModel *)model;

@end
