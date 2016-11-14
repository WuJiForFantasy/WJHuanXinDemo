//
//  MainStore.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/10.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <Foundation/Foundation.h>

/**环信通知消息等管理*/
@interface MainStore : NSObject
//{
//    EMConnectionState _connectionState; //网络连接状态
//}
@property (nonatomic,assign,readonly)EMConnectionState connectionState; //网络连接状态
@property (nonatomic,copy)void (^unreadMsgNumBlock)(NSInteger num);     //没有阅读的数量的回调

//统计未读消息
- (void)setupUnreadMessageCount;
- (void)setupCleanUnreadMessageCount;
//播放声音和响铃
- (void)playSoundAndVibration;

//显示通知消息
- (void)showNotificationWithMessage:(EMMessage *)message;


//收到本地通知
//- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
//网络状态改变（配置）
- (void)networkChanged:(EMConnectionState)connectionState;

@end
