//
//  WJHuanXinTextMsgCell.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinTextMsgCell.h"
#import "MLEmojiLabel.h"

@interface WJHuanXinTextMsgCell ()<MLEmojiLabelDelegate>

@property (nonatomic, strong) MLEmojiLabel *emojiLabel;

@end

@implementation WJHuanXinTextMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.bodyBgView addSubview:self.emojiLabel];
    }
    return self;
}

#pragma mark - 懒加载

- (MLEmojiLabel *)emojiLabel
{
    if (!_emojiLabel) {
        _emojiLabel = [MLEmojiLabel new];
        _emojiLabel.numberOfLines = 0;
        _emojiLabel.font = [UIFont systemFontOfSize:14.0f];
        _emojiLabel.delegate = self;
        _emojiLabel.backgroundColor = [UIColor clearColor];
        _emojiLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _emojiLabel.textColor = [UIColor whiteColor];
        _emojiLabel.backgroundColor = [UIColor colorWithRed:0.218 green:0.809 blue:0.304 alpha:1.000];
        _emojiLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _emojiLabel.isNeedAtAndPoundSign = YES;
        _emojiLabel.disableEmoji = NO;
        _emojiLabel.lineSpacing = 3.0f;
        _emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _emojiLabel.customEmojiPlistName = @"expressionImage_custom.plist";
    }
    return _emojiLabel;
}
- (void)setIMMsg:(EaseMessageModel *)msg {
    [super setIMMsg:msg];
     [self.emojiLabel setText:msg.text];
    WJHuanXinBorderManager *manager =  [self borderImageAndFrame];
    self.emojiLabel.frame = CGRectMake(manager.leftPadding, manager.topPadding,  manager.labelWidth,  manager.labelHeight);

    cellHeight = self.bodyBgView.bottom+WJCHAT_CELL_TIMELABELHEIGHT;
    self.cellHeight = cellHeight;
    [self baseFrameLayout];
}
+ (CGFloat)cellHeight {
    return cellHeight+0.001;
}

#pragma mark - <MLEmojiLabelDelegate>

- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type {
    NSLog(@"---------llll-----------");
}

@end
