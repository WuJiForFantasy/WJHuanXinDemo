//
//  WJChatToolCell.m
//  KeyboardForChat
//
//  Created by 幻想无极（谭启宏） on 16/8/29.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "WJChatToolCell.h"


@interface WJChatToolCell()



@end

@implementation WJChatToolCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.itemButton = [UIButton new];
        [self.contentView addSubview:self.itemButton];
        self.itemButton.userInteractionEnabled = NO;
    }
    return self;
}

- (void)layoutSubviews {
    self.itemButton.frame = self.contentView.bounds;
}

@end
