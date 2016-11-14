//
//  WJChatToolBar.h
//  QQ聊天输入键盘
//
//  Created by 幻想无极（谭启宏） on 16/8/29.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFTextView.h"
#import "WJChatToolBarItemModel.h"

@protocol WJChatToolBarDelegate <NSObject>

- (void)chatToolBarTextViewDidBeginEditing:(UITextView *)textView;
- (void)chatToolBarSendText:(NSString *)text;
- (void)chatToolBarTextViewDidChange:(UITextView *)textView;
//选择下标
- (void)chatToolBarDidSelectedIndex:(NSInteger)index;
- (void)chatToolBarDidNotSelectedIndex:(NSInteger)index;

@end

/**工具条*/
@interface WJChatToolBar : UIImageView<UITextViewDelegate>

/** 输入文本框 */
//@property (nonatomic, readonly, strong) RFTextView *textView;

@property (nonatomic, weak) id<WJChatToolBarDelegate> delegate;
@property (nonatomic,assign) NSInteger indexSelected;
- (void)setTextViewContent:(NSString *)text;
- (void)clearTextViewContent;
@property (nonatomic,strong)NSArray <WJChatToolBarItemModel *>*itemDataArray;
@property (nonatomic, strong) RFTextView *textView;
@end
