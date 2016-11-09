//
//  WJChatKeyBoard.h
//  QQ聊天输入键盘
//
//  Created by 幻想无极（谭启宏） on 16/8/29.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJChatToolBar.h"
#import "FaceSourceManager.h"
@class FaceSubjectModel;
@class WJChatKeyBoard;
@class WJChatToolBarItemModel;

@protocol WJChatKeyBoardDelegate <NSObject>

@optional

//输入状态
- (void)chatKeyBoardTextViewDidBeginEditing:(UITextView *)textView;
- (void)chatKeyBoardSendText:(NSString *)text;
- (void)chatKeyBoardTextViewDidChange:(UITextView *)textView;

//表情
- (void)chatKeyBoardFacePicked:(WJChatKeyBoard *)chatKeyBoard faceSize:(NSInteger)faceSize faceName:(NSString *)faceName delete:(BOOL)isDelete;

@end

/**
 *  数据源
 */
@protocol WJChatKeyBoardDataSource <NSObject>

@required

- (NSArray<FaceSubjectModel *> *)chatKeyBoardFacePanelSubjectItems;

- (NSArray<WJChatToolBarItemModel *> *)chatKeyBoardToolbarItems;

@end

typedef NS_OPTIONS(NSUInteger, WJChatKeyBoardType) {
    WJChatKeyBoardTypeChat = 0,       //聊天界面的键盘
    WJChatKeyBoardTypeChatComment //评论界面的键盘
};

@interface WJChatKeyBoard : UIView
+ (instancetype)keBoardWithType:(WJChatKeyBoardType)type translucent:(BOOL)translucent;
- (instancetype)initWithFrame:(CGRect)frame type:(WJChatKeyBoardType)type translucent:(BOOL)translucent;

//工具栏
@property (nonatomic, readonly, strong) WJChatToolBar *chatToolBar;
@property (nonatomic, weak) id<WJChatKeyBoardDataSource> dataSource;
@property (nonatomic, weak) id<WJChatKeyBoardDelegate> delegate;

@property (nonatomic,assign)WJChatKeyBoardType type;//类型

- (void)hideKeyBoard;
@end
