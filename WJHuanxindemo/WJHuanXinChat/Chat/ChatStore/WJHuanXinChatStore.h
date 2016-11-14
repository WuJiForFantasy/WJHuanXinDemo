//
//  WJHuanXinChatStore.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinChatBaseCell.h"
@class WJHuanXinChatBaseController;

//typedef void (^did);
/**聊天相关的数据处理----单聊~~~~*/

@interface WJHuanXinChatStore : NSObject

@property (nonatomic,strong)UITableView *tableView;                 //列表

@property (nonatomic,strong)EMConversation *conversation;          //环信聊天会话
@property (nonatomic,strong)NSMutableArray *messsagesSource;        //消息数据 - EMMessage环信对象
@property (nonatomic,strong)NSMutableArray *dataArray;              //消息数据 - EaseMessageModel消息模型对象
@property (nonatomic,assign)NSTimeInterval messageTimeIntervalTag;  //消息时间戳标记

@property (nonatomic) NSInteger messageCountOfPage;                 //default 50
@property (nonatomic) BOOL isViewDidAppear;                         //视图将要显示(需要在视图显示消失操作)

/**通过会话ID获取会话，创建单聊,最初调用*/
- (void)getConversationChatter:(NSString *)conversationChatter;
/**开始会话并进行会话监听*/
- (void)startConversationWithVc:(WJHuanXinChatBaseController *)vc;
//关闭会话
- (void)stopConversation;

- (void)tableViewDidTriggerHeaderRefresh;

//- (void)_loadMessagesBefore:(NSString*)messageId
//                      count:(NSInteger)count
//                     append:(BOOL)isAppend;
#pragma mark - 发送消息回执
- (void)_reloadTableViewDataWithMessage:(EMMessage *)message;
- (void)_sendHasReadResponseForMessages:(NSArray*)messages
                                 isRead:(BOOL)isRead;
#pragma mark - 发送消息
- (void)_sendMessage:(EMMessage *)message;
- (void)sendTextMessage:(NSString *)text;
- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary*)ext;
- (void)sendLocationMessageLatitude:(double)latitude
                          longitude:(double)longitude
                         andAddress:(NSString *)address;
- (void)sendImageMessageWithData:(NSData *)imageData;
- (void)sendImageMessage:(UIImage *)image;
- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(NSInteger)duration;
- (void)sendVideoMessageWithURL:(NSURL *)url;
@end
