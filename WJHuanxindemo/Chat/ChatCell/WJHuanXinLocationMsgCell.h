//
//  WJHuanXinLocationMsgCell.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinChatBaseCell.h"

/**地理位置*/
@interface WJHuanXinLocationMsgCell : WJHuanXinChatBaseCell

@property (nonatomic,strong)UIImageView *picImage;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIButton *locationIcon;
@property (nonatomic,strong)UILabel *locationLabel;

@end
