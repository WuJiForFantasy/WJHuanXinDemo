//
//  WJHuanXinTextMsgCell.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinTextMsgCell.h"

@interface WJHuanXinTextMsgCell ()<TTTAttributedLabelDelegate>

@end

@implementation WJHuanXinTextMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         [self.bodyBgView addSubview:self.textView];
    }
    return self;
}

#pragma mark - 懒加载

- (TTTAttributedLabel *)textView {
    if (!_textView) {
        _textView = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _textView.userInteractionEnabled = NO;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.lineBreakMode = NSLineBreakByCharWrapping;
        _textView.numberOfLines = 0;
        _textView.leading = 5;
        _textView.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        _textView.highlightedTextColor = [UIColor whiteColor];
        _textView.font = WJIMTextMsgCellTextFont;
        _textView.delegate = self;
    }
    return _textView;
}

- (void)setIMMsg:(EaseMessageModel *)msg {
    [super setIMMsg:msg];
    [self.textView setText:@"测试测试测试"];
    
    WJHuanXinBorderManager *manager =  [self borderImageAndFrame];
    
    self.textView.frame = CGRectMake(manager.leftPadding, manager.topPadding,  manager.labelWidth,  manager.labelHeight);
    
    cellHeight = self.bodyBgView.bottom+WJCHAT_CELL_TIMELABELHEIGHT;
    self.cellHeight = cellHeight;
    [self baseFrameLayout];
}
+ (CGFloat)cellHeight {
    return cellHeight+0.001;
}
@end
