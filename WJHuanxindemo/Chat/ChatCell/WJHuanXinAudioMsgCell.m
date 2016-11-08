//
//  WJHuanXinAudioMsgCell.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinAudioMsgCell.h"

@interface WJHuanXinAudioMsgCell ()

@property (nonatomic,strong)UILabel *label;

@end

@implementation WJHuanXinAudioMsgCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.bodyBgView addSubview:self.playStateView];
        [self.bodyBgView addSubview:self.label];
    }
    return self;
}

#pragma mark - 懒加载

- (UIImageView *)playStateView {
    if (!_playStateView) {
        _playStateView = [UIImageView new];
        _playStateView.image = [UIImage imageNamed:@"message_ic_voice"];
        _playStateView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _playStateView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.text = @"01'19'";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:16];
//        _label.textColor = [MoyouColor colorWithdefalutColor];
        _label.textColor = [UIColor redColor];
    }
    return _label;
}

- (void)setIMMsg:(EMMessage *)msg {
     [super setIMMsg:msg];
     WJHuanXinBorderManager *manager = [self borderImageAndFrame];
    if (self.fromType == WJIMMsgFromOther) {
        self.playStateView.frame = CGRectMake(manager.leftPadding+10, 12, 20,20);
        self.label.frame = CGRectMake(self.playStateView.right + 5, 0, self.bodyBgView.width - manager.rightPadding - self.playStateView.right-5, manager.height);
    }else {
        self.label.frame = CGRectMake(manager.leftPadding + 15, 0, 50, manager.height);
        self.playStateView.frame = CGRectMake(self.label.right+5, 12, 20,20);
        
    }
    cellHeight =  self.bodyBgView.bottom+WJCHAT_CELL_TIMELABELHEIGHT;
    self.cellHeight = cellHeight;
    [self baseFrameLayout];
}
+ (CGFloat)cellHeight {
    return cellHeight+0.001;
}
@end
