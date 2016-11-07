//
//  WJHuanXinConversationCell.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinConversationCell.h"

@interface WJHuanXinConversationCell ()

@property (nonatomic,strong)MGSwipeButton *readButton;//阅读状态

@end

@implementation WJHuanXinConversationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.userImage];
        [self.contentView addSubview:self.userLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.numBadge];
    }
    return self;
}

#pragma mark - 懒加载

- (UIImageView *)userImage {
    if (!_userImage) {
        _userImage = [UIImageView new];
//        _userImage.image = AVATERIMAGE_TEST;
        _userImage.backgroundColor = [UIColor greenColor];
//        [self.userImage viewWithCornerRadius:20];
        self.userImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPressed)];
        [self.userImage addGestureRecognizer:tap];
    }
    return _userImage;
}

- (UILabel *)userLabel {
    if (!_userLabel) {
        _userLabel = [UILabel new];
    }
    return _userLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
    }
    return _contentLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
    }
    return _dateLabel;
}

- (UILabel *)numBadge {
    if (!_numBadge) {
        _numBadge = [UILabel new];
        _numBadge.textAlignment = NSTextAlignmentCenter;
        _numBadge.backgroundColor = [UIColor redColor];
        _numBadge.font = [UIFont systemFontOfSize:10];
        _numBadge.textColor = [UIColor whiteColor];
        _numBadge.layer.cornerRadius = 7.5;
        _numBadge.layer.masksToBounds = YES;
    }
    return _numBadge;
}

-  (MGSwipeButton *)readButton {
    if (!_readButton) {
        _readButton = [MGSwipeButton buttonWithTitle:@"未读" icon:[UIImage imageNamed:@"message_ic_have_read"] backgroundColor:[UIColor colorWithHexString:@"3288d9"] callback:^BOOL(MGSwipeTableCell *sender) {
            NSLog(@"阅读");
            return YES;
        }];
        [_readButton setImage:[UIImage imageNamed:@"message_ic_have_read"] forState:UIControlStateSelected];
        [_readButton setTitle:@"已读" forState:UIControlStateSelected];
        _readButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_readButton centerIconOverTextWithSpacing:10];
        _readButton.selected = YES;
    }
    return _readButton;
}

- (void)exportCell {
    MGSwipeButton *zhiDingButton = [MGSwipeButton buttonWithTitle:@"置顶" icon:[UIImage imageNamed:@"message_ic_top"] backgroundColor:[UIColor colorWithHexString:@"ffbd3d"] callback:^BOOL(MGSwipeTableCell *sender) {
        NSLog(@"置顶");
        return YES;
    }];
    MGSwipeButton *deleteButton = [MGSwipeButton buttonWithTitle:@"删除" icon:[UIImage imageNamed:@"message_ic_clear1"] backgroundColor:[UIColor colorWithHexString:@"ff5b5b"] callback:^BOOL(MGSwipeTableCell *sender) {
        NSLog(@"删除");
        return YES;
    }];
    zhiDingButton.titleLabel.font = [UIFont systemFontOfSize:14];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [zhiDingButton centerIconOverTextWithSpacing:10];
    [deleteButton centerIconOverTextWithSpacing:10];
    
    self.leftButtons = @[self.readButton];
    self.rightButtons = @[deleteButton,zhiDingButton];
    self.rightExpansion.buttonIndex = 0;
    self.rightExpansion.fillOnTrigger = YES;
    
}


#pragma mark - setter

- (void)setModel:(WJHuanXinConversationModel *)model {
    _model = model;
    self.userImage.frame = CGRectMake(15, 15, 40, 40);
    self.userLabel.frame = CGRectMake(self.userImage.maxX + 15, 20, 200, 20);
    self.contentLabel.frame = CGRectMake(self.userImage.maxX+5, self.userLabel.maxY+10, SCREEN_WIDTH-60-self.userImage.maxX-10, 20);
    self.dateLabel.frame = CGRectMake(SCREEN_WIDTH-60, self.contentLabel.y, 50, 20);
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    
    self.userLabel.text = @"陌友小秘书";
    self.userLabel.font = [UIFont systemFontOfSize:15];
    self.userLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.contentLabel.text = @"我不想说了，真的不想输了😄啦啦！！！！就喝喝酒很快就好的撒按时打算的撒的";
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.dateLabel.text = @"12:10";
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    self.dateLabel.textColor = [UIColor colorWithHexString:@"888888"];
    self.contentLabel.textColor = [UIColor grayColor];
    self.dateLabel.textColor = [UIColor grayColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self exportCell];
    [self masLayout];
    self.userLabel.text = model.title;
}

- (void)masLayout {
    
    self.userImage.frame = CGRectMake(15, (75-40)/2, 40, 40);
    self.userLabel.frame = CGRectMake(10+self.userImage.maxX, self.userImage.y, 150, 20);
    self.dateLabel.frame = CGRectMake(SCREEN_WIDTH - 15-70, self.userImage.y, 70, 20);
    self.contentLabel.frame = CGRectMake(self.userLabel.x, self.userLabel.maxY, self.dateLabel.x - 10 - self.userImage.maxX - 10, 20);
    
    self.numBadge.text = @"99";
    if ([self.numBadge.text integerValue] == 0) {
        self.numBadge.frame = CGRectZero;
    }else if ([self.numBadge.text integerValue] > 0 && [self.numBadge.text integerValue]< 10) {
        self.numBadge.frame = CGRectMake(SCREEN_WIDTH - 15 - 15, self.dateLabel.maxY, 15, 15);
    }else {
        self.numBadge.frame = CGRectMake(SCREEN_WIDTH - 15-20, self.dateLabel.maxY, 20, 15);
    }
}

#pragma mark - 事件监听

- (void)tapPressed {
    NSLog(@"点击了头像");
}

#pragma mark - other

+ (CGFloat)cellHeight {
    return 80;
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
