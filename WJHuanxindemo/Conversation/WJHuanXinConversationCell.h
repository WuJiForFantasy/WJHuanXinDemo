//
//  WJHuanXinConversationCell.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJHuanXinConversationModel.h"
#import "MGSwipeTableCell.h"

/**会话cell*/

@interface WJHuanXinConversationCell : MGSwipeTableCell

@property (nonatomic,strong)UIImageView *userImage; //头像
@property (nonatomic,strong)UILabel *userLabel;     //用户名
@property (nonatomic,strong)UILabel *contentLabel;  //内容
@property (nonatomic,strong)UILabel *dateLabel;     //时间
@property (nonatomic,strong)UILabel *numBadge;//没有阅读的数量

@property (nonatomic,strong)WJHuanXinConversationModel *model; //模型

+ (CGFloat)cellHeight;//高度

@end
