//
//  WJHuanXinAudioMsgCell.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinChatBaseCell.h"

@interface WJHuanXinAudioMsgCell : WJHuanXinChatBaseCell

@property (nonatomic,strong)UIImageView *playStateView;//播放状态的View

@property (nonatomic) NSArray *sendMessageVoiceAnimationImages UI_APPEARANCE_SELECTOR;

@property (nonatomic) NSArray *recvMessageVoiceAnimationImages UI_APPEARANCE_SELECTOR;

@end
