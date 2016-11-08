//
//  WJHuanXinBorderManager.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMMessage.h"
#define WJIMTextMsgCellTextFont [UIFont systemFontOfSize:14] //文字的大小

//cell上的配置
#define WJCHAT_CELL_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)  //cell宽度
#define WJCHAT_CELL_AVATARWIDTH 40                                      //头像宽度
#define WJCHAT_CELL_LEFT_PADDING (40+30)                                //左边距离
#define WJCHAT_CELL_RIGHT_PADDING 15                                    //右边距离
#define WJCHAT_CELL_HEADER 20                                           //header高度
#define WJCHAT_CELL_TIMELABELHEIGHT 30                                  //footer高度
#define WJCHAT_CELL_CONTENT_MAXWIDTH (WJCHAT_CELL_WIDTH - WJCHAT_CELL_LEFT_PADDING-WJCHAT_CELL_RIGHT_PADDING*2)//文本最大宽度

@interface WJHuanXinBorderManager : NSObject

@property (nonatomic,assign)CGFloat leftPadding;    //左边
@property (nonatomic,assign)CGFloat rightPadding;   //右边
@property (nonatomic,assign)CGFloat topPadding;     //顶部
@property (nonatomic,assign)CGFloat bottomPadding;  //底部

@property (nonatomic,assign)CGFloat labelWidth;     //label宽度
@property (nonatomic,assign)CGFloat labelHeight;    //label高度

@property (nonatomic,assign)CGFloat width;          //宽度
@property (nonatomic,assign)CGFloat height;         //高度

@property (nonatomic,strong)UIImage *borderImage;   //边框图片

- (instancetype)initWithMsg:(EaseMessageModel *)msg;

@end
