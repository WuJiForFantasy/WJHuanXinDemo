//
//  WJHuanXinChatMsgCellUtil.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinChatMsgCellUtil.h"

@implementation WJHuanXinChatMsgCellUtil

+ (CGFloat)cellHeightForMsg:(id)msg {
    if ([msg isKindOfClass:[EaseMessageModel class]]) {
        EaseMessageModel *tmpMsg = (EaseMessageModel *)msg;
        if (tmpMsg.bodyType == EMMessageBodyTypeText) {
            return [WJHuanXinTextMsgCell cellHeight];
        }
        else if (tmpMsg.bodyType == EMMessageBodyTypeVoice) {
            return [WJHuanXinAudioMsgCell cellHeight];
        } else if (tmpMsg.bodyType == EMMessageBodyTypeImage) {
            return [WJHuanXinPicMsgCell cellHeight];
        } else if (tmpMsg.bodyType == EMMessageBodyTypeVideo) {
            return [WJHuanXinVideoMsgCell cellHeight];
        }
        else if (tmpMsg.bodyType == EMMessageBodyTypeLocation) {
            return [WJHuanXinLocationMsgCell cellHeight];
        }else {
            return 44;
        }
    }else {
        return 44;
    }
//     return 44;
}

+ (UITableViewCell *)tableView:(UITableView *)tableView cellForMsg:(id)msg {
    if ([msg isKindOfClass:[EaseMessageModel class]]) {
        
        WJHuanXinChatBaseCell *cell = nil;
        EaseMessageModel *tmpMsg = (EaseMessageModel *)msg;
        //文字cell
        if (tmpMsg.bodyType == EMMessageBodyTypeText) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"IMTextMsg"];
            if(cell == nil){
                cell = [[WJHuanXinTextMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IMTextMsg"];
            }
            [cell setIMMsg:msg];
        }
        //语音cell
        else if (tmpMsg.bodyType == EMMessageBodyTypeVoice) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"IMAudioMsg"];
            if(cell == nil){
                cell = [[WJHuanXinAudioMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IMAudioMsg"];
            }
            [cell setIMMsg:msg];
        }
        //图片cell
        else if (tmpMsg.bodyType == EMMessageBodyTypeImage) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"IMPicMsg"];
            if(cell == nil){
                cell = [[WJHuanXinPicMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IMPicMsg"];
            }
            [cell setIMMsg:msg];
        }
        //视频cell
        else if (tmpMsg.bodyType == EMMessageBodyTypeVideo) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"IMVideoMsg"];
            if(cell == nil){
                cell = [[WJHuanXinVideoMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IMVideoMsg"];
            }
            [cell setIMMsg:msg];
        }
        //地址cell
        else if (tmpMsg.bodyType == EMMessageBodyTypeLocation) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"IMLocationMsg"];
            if(cell == nil){
                cell = [[WJHuanXinLocationMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IMLocationMsg"];
            }
            [cell setIMMsg:msg];
        }
        
        else {
            cell = [[WJHuanXinChatBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"basecell"];
        }
 
        return cell;
    }else {
        //如果不是消息类型就不返回
        return nil;
        
    }
}

@end
