//
//  WJHuanXinVideoMsgCell.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinVideoMsgCell.h"

@interface WJHuanXinVideoMsgCell ()

@property (nonatomic,strong)UIImageView *playImageView;

@end

@implementation WJHuanXinVideoMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.picImage = [UIImageView new];
        self.picImage.backgroundColor = [UIColor redColor];
        [self.bodyBgView addSubview:self.picImage];
        self.playImageView = [UIImageView new];
        self.playImageView.bounds = CGRectMake(0, 0, 50, 50);
        [self.bodyBgView addSubview:self.playImageView];
        self.playImageView.image = [UIImage imageNamed:@"play"];
        
    }
    return self;
}

- (void)setIMMsg:(EMMessage *)msg {
    [super setIMMsg:msg];
    [self borderImageAndFrame];
    
    if (self.fromType == WJIMMsgFromOther) {
        self.picImage.frame = CGRectMake(20,10,self.bodyBgView.width-30,self.bodyBgView.height-20);
    }else {
        self.picImage.frame = CGRectMake(10,10,self.bodyBgView.width-25,self.bodyBgView.height-20);
    }
    self.playImageView.center = self.picImage.center;
    cellHeight =  self.bodyBgView.bottom+WJCHAT_CELL_TIMELABELHEIGHT;
    self.cellHeight = cellHeight;
    [self baseFrameLayout];

}
+ (CGFloat)cellHeight {
    return cellHeight+0.001;
}
@end
