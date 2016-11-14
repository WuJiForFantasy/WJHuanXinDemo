//
//  WJHuanXinChatMsgCellUtil.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WJHuanXinChatBaseCell.h"
#import "WJHuanXinTextMsgCell.h"
#import "WJHuanXinPicMsgCell.h"
#import "WJHuanXinVideoMsgCell.h"
#import "WJHuanXinLocationMsgCell.h"
#import "WJHuanXinAudioMsgCell.h"

@interface WJHuanXinChatMsgCellUtil : NSObject

/**返回cell的高度*/
+ (CGFloat)cellHeightForMsg:(id)msg;

/**根据消息返回cell*/
+ (UITableViewCell *)tableView:(UITableView *)tableView cellForMsg:(id)msg;

@end
