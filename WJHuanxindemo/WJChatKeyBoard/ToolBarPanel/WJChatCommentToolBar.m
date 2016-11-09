//
//  WJChatCommentToolBar.m
//  QQ聊天输入键盘
//
//  Created by 幻想无极（谭启宏） on 16/8/30.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJChatCommentToolBar.h"

#define TextViewH               36
#define TextViewVerticalOffset  10 //(ItemH-TextViewH)/2.0
#define COLLECTION_WIDTH (CGRectGetWidth(self.bounds))

@interface WJChatCommentToolBar ()

@property (nonatomic,strong)UIButton *leftButton;

@end

@implementation WJChatCommentToolBar

- (void)initSubviews {
    self.userInteractionEnabled = YES;
    self.textView = [[RFTextView alloc] init];
    self.textView.delegate = self;
    [self addSubview:self.textView];
    
    self.leftButton = [[UIButton alloc]init];
    [self addSubview:self.leftButton];
    self.leftButton.backgroundColor = [UIColor yellowColor];
    
    [self.leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self setbarSubViewsFrame];
    //KVO监听输入框的内容大小
    [self addObserver:self forKeyPath:@"self.textView.contentSize" options:(NSKeyValueObservingOptionNew) context:nil];
    
}

- (void)setbarSubViewsFrame {
    self.textView.frame = CGRectMake(TextViewH, 5, COLLECTION_WIDTH-10-TextViewH, TextViewH);
}

- (void)layoutSubviews {
    self.leftButton.frame = CGRectMake(0, 5, TextViewH, TextViewH);
}

- (void)leftButtonPressed {
    //这个0按照后面的弹出键盘进行修改
    if (self.indexSelected == 0) {
        self.indexSelected = -1;
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatToolBarDidNotSelectedIndex:)]) {
            [self.delegate chatToolBarDidNotSelectedIndex:0];
        }
    }else {
        self.indexSelected = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatToolBarDidSelectedIndex:)]) {
            [self.delegate chatToolBarDidSelectedIndex:0];
        }
    }
}

@end
