//
//  WJHuanXinChatBaseCell.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinChatBaseCell.h"

@implementation WJHuanXinChatBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self defaultCommon];
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.bodyBgView];
        [self.contentView addSubview:self.footerView];
        [self.contentView addSubview:self.headerView];
        [self.footerView addSubview:self.timeLabel];
        [self.contentView addSubview:self.errorView];
        self.errorView.hidden = YES;
        self.errorView.backgroundColor = [UIColor redColor];
        self.timeLabel.font = 10;
        [self.timeLabel setRightImage:[UIImage imageNamed:@"message_ic_service"] text:@"啊哈哈"];
        [self addEvent];
    }
    return self;
}

- (void)addEvent {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewTapAction:)];
    [self.bodyBgView addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarViewTapAction:)];
    [self.avatarView addGestureRecognizer:tapRecognizer2];
}



#pragma mark - 懒加载

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [UIImageView new];
    }
    return _avatarView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [UIView new];
    }
    return _footerView;
}

- (MoyouSmallIconText *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[MoyouSmallIconText alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
        _timeLabel.leftPadding = 0;
        _timeLabel.rightPadding = 0;
        _timeLabel.iconTextPadding = 2;
        _timeLabel.label.textColor = [UIColor colorWithHexString:@"778187"];
        _timeLabel.edge = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return _timeLabel;
}

- (UIButton *)bodyBgView {
    if (!_bodyBgView) {
        _bodyBgView = [UIButton new];
    }
    return _bodyBgView;
}

- (UIView *)errorView {
    if (!_errorView) {
        _errorView = [UIView new];
    }
    return _errorView;
}

#pragma mark - public

- (void)setIMMsg:(EaseMessageModel *)msg {
    _msg = msg;
    if (msg.message.direction == EMMessageDirectionSend) {
        self.fromType = WJIMMsgFromLocalSelf;
    }else {
        self.fromType = WJIMMsgFromOther;
    }
    //继承写下面的方法
}

+ (CGFloat)cellHeight {
    return cellHeight+0.001;
}

#pragma mark - FrameLayout

- (void)avatarFrameLayout {
    CGFloat minY = self.cellHeight-WJCHAT_CELL_AVATARWIDTH-WJCHAT_CELL_TIMELABELHEIGHT;
    if (self.fromType == WJIMMsgFromOther) {
        self.avatarView.frame = CGRectMake(15, minY, WJCHAT_CELL_AVATARWIDTH, WJCHAT_CELL_AVATARWIDTH);
    }else {
        //        self.avatarView.frame = CGRectMake(WJCHAT_CELL_WIDTH-WJCHAT_CELL_AVATARWIDTH,minY, WJCHAT_CELL_AVATARWIDTH, WJCHAT_CELL_AVATARWIDTH);
        self.avatarView.frame = CGRectZero;
    }
}

- (void)timeLabelFrameLayout {
    if (self.fromType == WJIMMsgFromOther) {
        self.footerView.frame = CGRectMake(self.bodyBgView.left, self.cellHeight-WJCHAT_CELL_TIMELABELHEIGHT, WJCHAT_CELL_CONTENT_MAXWIDTH, WJCHAT_CELL_TIMELABELHEIGHT);
        self.timeLabel.frame = CGRectMake(self.bodyBgView.width - 60, 4, 60, 20);
    }else {
        self.footerView.frame = CGRectMake(self.bodyBgView.left, self.cellHeight-WJCHAT_CELL_TIMELABELHEIGHT, WJCHAT_CELL_CONTENT_MAXWIDTH, WJCHAT_CELL_TIMELABELHEIGHT);
        self.timeLabel.frame = CGRectMake(0, 4, 60, 20);
        
        
    }
    [self.timeLabel setRightImage:[UIImage imageNamed:@"message_ic_service"] text:@"12:00"];
}

- (void)errorViewFrameLayout {
    if (self.fromType == WJIMMsgFromOther) {
        self.errorView.frame = CGRectMake(self.bodyBgView.right, self.bodyBgView.centerY-20, 40, 40);
    }else {
        self.errorView.frame = CGRectMake(self.bodyBgView.left-40, self.bodyBgView.centerY-20, 40, 40);
    }
}

- (void)baseFrameLayout {
    [self avatarFrameLayout];
    [self timeLabelFrameLayout];
    [self errorViewFrameLayout];
}

#pragma mark - 事件监听

- (void)bubbleViewTapAction:(UITapGestureRecognizer *)sender {
    NSLog(@"点击了会话框");
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (!_delegate) {
            return;
        }
        if ([_delegate respondsToSelector:@selector(messageCellSelected:)]) {
            [_delegate messageCellSelected:self.msg];
        }
    }
}

- (void)avatarViewTapAction:(UITapGestureRecognizer *)sender {
    
    NSLog(@"点击了头像");

}

#pragma mark - others

- (void)defaultCommon {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.detailTextLabel.hidden = YES;
    self.textLabel.hidden = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (WJHuanXinBorderManager *)borderImageAndFrame {
    WJHuanXinBorderManager *manager = [[WJHuanXinBorderManager alloc]initWithMsg:self.msg];
    [self.bodyBgView setBackgroundImage:manager.borderImage forState:UIControlStateNormal];
    if (self.fromType == WJIMMsgFromOther) {
        self.bodyBgView.frame = CGRectMake(WJCHAT_CELL_LEFT_PADDING, WJCHAT_CELL_HEADER, manager.width, manager.height);
    }else {
        self.bodyBgView.frame = CGRectMake(WJCHAT_CELL_WIDTH-WJCHAT_CELL_RIGHT_PADDING-manager.width, WJCHAT_CELL_HEADER, manager.width, manager.height);
    }
    return manager;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
