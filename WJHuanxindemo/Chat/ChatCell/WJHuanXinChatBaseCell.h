//
//  WJHuanXinChatBaseCell.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoyouSmallIconText.h"
#import "UIView+IM.h"
#import "WJHuanXinBorderManager.h"

/**消息来源*/
typedef NS_ENUM(NSInteger, WJIMMsgFrom)
{
    WJIMMsgFromOther = 0,       //其他人
    WJIMMsgFromLocalSelf = 1,   //自己
};

static CGFloat cellHeight = 0;//计算cell的高度，静态变量

/**聊天cell的基类
 1.注意调用添加消息后把cellHeight赋值
 2.注意高度调用 [WJHuanXinChatBaseCell cellHeight]
 3.more~~~
 */
@protocol WJHuanXinChatBaseCellDelegate;

@interface WJHuanXinChatBaseCell : UITableViewCell

@property (nonatomic,strong)EaseMessageModel *msg;          //环信聊天消息

@property (nonatomic,strong)UIActivityIndicatorView *activity;  //消息发送时的圈圈
@property (nonatomic,assign)WJIMMsgFrom fromType;    //消息来源，自己还是其他人
@property (nonatomic,strong)UIImageView *avatarView; //头像
@property (nonatomic,strong)UIView *footerView;      //底部
@property (nonatomic,strong)UIView *headerView;      //底部
@property (nonatomic,strong)MoyouSmallIconText *timeLabel;//时间
@property (nonatomic,strong)UIView *errorView;       //错误视图
@property (nonatomic,strong)UIButton *bodyBgView;    //文本区域
@property (nonatomic,assign)CGFloat cellHeight;//高度属性

@property (nonatomic,weak)id<WJHuanXinChatBaseCellDelegate>delegate;

- (WJHuanXinBorderManager *)borderImageAndFrame;
/**添加消息*/
- (void)setIMMsg:(EaseMessageModel *)msg;

//- (void)addModelWith:(EMMessage *)msg

//基础布局
- (void)baseFrameLayout;
//注意:cell的高度都用这个返回
+ (CGFloat)cellHeight;

@end

//cell上面的点击代理
@protocol WJHuanXinChatBaseCellDelegate <NSObject>

@optional

//cell选中
- (void)messageCellSelected:(id<IMessageModel>)model;

//状态
- (void)statusButtonSelcted:(id<IMessageModel>)model withMessageCell:(EaseMessageCell*)messageCell;

//头像选中
- (void)avatarViewSelcted:(id<IMessageModel>)model;

@end
