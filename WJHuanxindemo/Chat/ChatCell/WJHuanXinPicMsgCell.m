//
//  WJHuanXinPicMsgCell.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinPicMsgCell.h"

@implementation WJHuanXinPicMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.picImage = [UIImageView new];
        self.picImage.backgroundColor = [UIColor redColor];
        [self.bodyBgView addSubview:self.picImage];
    }
    return self;
}

- (void)setIMMsg:(EaseMessageModel *)msg {
    [super setIMMsg:msg];
    [self borderImageAndFrame];
    self.picImage.image = [UIImage imageNamed:@"20150207101056_tGZfA.thumb.700_0"];
    if (self.fromType == WJIMMsgFromOther) {
        
        self.picImage.frame = CGRectMake(20,10,self.bodyBgView.width-30-5,self.bodyBgView.height-20);
    }else {
        
        self.picImage.frame = CGRectMake(10,10,self.bodyBgView.width-25-5,self.bodyBgView.height-20);
    }
    
    cellHeight =  self.bodyBgView.bottom+WJCHAT_CELL_TIMELABELHEIGHT;
    self.cellHeight = cellHeight;
    [self baseFrameLayout];
}
+ (CGFloat)cellHeight {
    return cellHeight+0.001;
}
@end
