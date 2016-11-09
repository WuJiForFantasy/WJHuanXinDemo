//
//  WJHuanXinTextMsgCell.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinChatBaseCell.h"
#import "TTTAttributedLabel.h"
#import "YYText.h"

/**聊天cell的文本类*/
@interface WJHuanXinTextMsgCell : WJHuanXinChatBaseCell

@property (nonatomic,strong)YYLabel *contentLabel;
@property (nonatomic,strong)TTTAttributedLabel *textView;//富文本

@end
