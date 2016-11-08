//
//  WJHuanXinLocationMsgCell.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinLocationMsgCell.h"

@implementation WJHuanXinLocationMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.bodyBgView addSubview:self.picImage];
        [self.bodyBgView addSubview:self.bottomView];
        [self.bottomView addSubview:self.locationIcon];
        [self.bottomView addSubview:self.locationLabel];
    }
    return self;
}

#pragma mark - 懒加载

- (UIImageView *)picImage {
    if (!_picImage) {
        _picImage = [UIImageView new];
        _picImage.backgroundColor = [UIColor redColor];
    }
    return _picImage;
}

- (UIButton *)locationIcon {
    if (!_locationIcon) {
        _locationIcon = [UIButton new];
        [_locationIcon setImage:[UIImage imageNamed:@"message_ic_positioning2"] forState:UIControlStateNormal];
    }
    return _locationIcon;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [UILabel new];
        _locationLabel.text = @"四川成都定位武侯区测试文字";
        _locationLabel.font = [UIFont systemFontOfSize:15];
        _locationLabel.textColor = [UIColor whiteColor];
    }
    return _locationLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        //        _bottomView.backgroundColor = [MoyouColor colorWithdefalutColor];
//        [_bottomView jm_setJMRadius:JMRadiusMake(0, 0, 5, 5) withBackgroundColor:[UIColor redColor]];
    }
    return _bottomView;
}

#pragma mark - setter

- (void)setIMMsg:(EMMessage *)msg {
    [self borderImageAndFrame];
    self.picImage.image = [UIImage imageNamed:@"meitu_boy"];
    if (self.fromType == WJIMMsgFromOther) {
        self.picImage.frame = CGRectMake(20, 10, self.bodyBgView.width - 30, self.bodyBgView.height - 20);
        self.bottomView.frame = CGRectMake(10, self.bodyBgView.height - 35, self.bodyBgView.width-10, 35);
    }else {
        self.picImage.frame = CGRectMake(10, 10, self.bodyBgView.width - 30, self.bodyBgView.height - 20);
        self.bottomView.frame = CGRectMake(0, self.bodyBgView.height - 35, self.bodyBgView.width-10, 35);
    }
    self.locationIcon.frame = CGRectMake(0, 0, 35, 35);
    self.locationLabel.frame = CGRectMake(self.locationIcon.right, 0, self.bottomView.width - self.locationIcon.right, 35);
    
    cellHeight =  self.bodyBgView.bottom+WJCHAT_CELL_TIMELABELHEIGHT;
    self.cellHeight = cellHeight;
    [self baseFrameLayout];
}
+ (CGFloat)cellHeight {
    return cellHeight+0.001;
}
@end
