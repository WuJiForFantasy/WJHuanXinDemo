//
//  WJChatKeyBoard.m
//  QQ聊天输入键盘
//
//  Created by 幻想无极（谭启宏） on 16/8/29.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJChatKeyBoard.h"
#import "WJChatToolBar.h"
#import "FacePanel.h"
#import "WJChatCommentToolBar.h"

#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

////键盘上面的工具条
//#define kChatToolBarHeight              (49+40)
//
////表情模块高度
//#define kFacePanelHeight                (216-40)
////拍照、发视频等更多功能模块的面板的高度
//#define kMorePanelHeight                216
//
////整个聊天工具的高度
//#define kChatKeyBoardHeight     kChatToolBarHeight + kFacePanelHeight

//显示键盘
//CGFloat getSupviewH(CGRect frame)
//{
//    
//}
//
//CGFloat getDifferenceH(CGRect frame)
//{
//    return kScreenHeight - (frame.origin.y + kChatToolBarHeight);
//}

@interface WJChatKeyBoard ()<WJChatToolBarDelegate,FacePanelDelegate> {
    NSInteger _kChatToolBarHeight;
    NSInteger _kChatKeyBoardHeight;
    NSInteger _kFacePanelHeight;
}

@property (nonatomic,strong) FacePanel *facePanel;//表情面板
@property (nonatomic,strong) WJChatToolBar *chatToolBar;//键盘上的工具条
@property (nonatomic,assign) CGRect keyboardInitialFrame;//键盘最初的高度

@end

@implementation WJChatKeyBoard

- (CGFloat)getSupviewH:(CGRect)frame {
    return frame.origin.y + _kChatToolBarHeight;
}

- (CGFloat) getDifferenceH:(CGRect )frame
{
    return kScreenHeight - (frame.origin.y + _kChatToolBarHeight);
}

#pragma mark - 初始化


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [self removeObserver:self forKeyPath:@"self.chatToolBar.frame"];
}

+ (instancetype)keBoardWithType:(WJChatKeyBoardType)type translucent:(BOOL)translucent{
    return [[self alloc]initWithFrame:CGRectZero type:type translucent:(BOOL)translucent];
}

- (instancetype)initWithFrame:(CGRect)frame type:(WJChatKeyBoardType)type translucent:(BOOL)translucent
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        
        if (self.type == WJChatKeyBoardTypeChatComment) {
            _kChatToolBarHeight = 46;
            _kFacePanelHeight = 216 - 40;
        }else {
            _kChatToolBarHeight = 89;
            _kFacePanelHeight = 216 + 20;
        }
        _kChatKeyBoardHeight = _kChatToolBarHeight + _kFacePanelHeight;
        if (translucent) {
            self.frame = CGRectMake(0, kScreenHeight - _kChatToolBarHeight, kScreenWidth, _kChatKeyBoardHeight);
        }else {
           self.frame = CGRectMake(0, kScreenHeight - _kChatToolBarHeight-64, kScreenWidth, _kChatKeyBoardHeight);
        }
        
        self.keyboardInitialFrame = self.frame;
        [self common];
    }
    return self;
}

#pragma mark - 核心

- (void)common {
    //判断键盘类型
    
    if (self.type == WJChatKeyBoardTypeChat) {
      _chatToolBar = [[WJChatToolBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _kChatToolBarHeight)];
    }else {
        _chatToolBar = [[WJChatCommentToolBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _kChatToolBarHeight)];
    }
    _chatToolBar.delegate = self;
    [self addSubview:self.chatToolBar];
    
    _facePanel = [[FacePanel alloc] initWithFrame:CGRectMake(0, _kChatKeyBoardHeight-_kFacePanelHeight, kScreenWidth, _kFacePanelHeight)];
    _facePanel.delegate = self;
    [self addSubview:self.facePanel];
    
    
    // ---通知－－－
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //监听chatToolBar的frame的改变
    [self addObserver:self forKeyPath:@"self.chatToolBar.frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)hideKeyBoard {
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, [self getSupviewH:self.keyboardInitialFrame]-CGRectGetHeight(self.frame)+_kFacePanelHeight, kScreenWidth, CGRectGetHeight(self.frame));
        self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), _kFacePanelHeight);
    }];
    [self.chatToolBar.textView resignFirstResponder];
    [self changeKeyBoardTopY];
}

- (void)changeKeyBoardTopY {
    if (_delegate && [_delegate respondsToSelector:@selector(chatKeyBoardDidChangeFrameToTopY:)]) {
        [_delegate chatKeyBoardDidChangeFrameToTopY:self.frame.origin.y];
    }
}

#pragma mark -

//键盘改变
- (void)keyBoardWillChangeFrame:(NSNotification *)notification {
    //其他键盘的监听
  
    
    if ((self.chatToolBar.indexSelected != -1) && ([self getSupviewH:self.keyboardInitialFrame] - CGRectGetMidY(self.frame)) < CGRectGetHeight(self.frame)) {
        [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.facePanel.hidden = NO;
            
            self.frame = CGRectMake(0, [self getSupviewH:self.keyboardInitialFrame]-CGRectGetHeight(self.frame), kScreenWidth, CGRectGetHeight(self.frame));
        
            self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-_kFacePanelHeight, CGRectGetWidth(self.frame), _kFacePanelHeight);
            
        } completion:nil];
    }
    
    //普通键盘的监听
    else {
        [UIView animateWithDuration:0.25 animations:^{
            
            CGRect begin = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
            CGRect end = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
            CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            
            
            CGFloat targetY = end.origin.y - (CGRectGetHeight(self.frame) - _kFacePanelHeight) - [self getDifferenceH:self.keyboardInitialFrame];
            
            if(begin.size.height>0 && (begin.origin.y-end.origin.y>0))
            {
                // 键盘弹起 (包括，第三方键盘回调三次问题，监听仅执行最后一次)
                self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
                [self showOtherKeyBord];
                
            }
            else if (end.origin.y == kScreenHeight && begin.origin.y!=end.origin.y && duration > 0)
            {
                self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
            
            }
            else if ((begin.origin.y-end.origin.y<0) && duration == 0)
            {
                //键盘切换
                self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
            }
        }];
    }
    [self changeKeyBoardTopY];
}

//弹出其他键盘
- (void)showOtherKeyBord {
//                    self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
       self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), _kFacePanelHeight);
}

#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //chatToolBar的frame在textview改变的时候就会改变
    if (object == self && [keyPath isEqualToString:@"self.chatToolBar.frame"]) {
        
        CGRect newRect = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        CGRect oldRect = [[change objectForKey:NSKeyValueChangeOldKey] CGRectValue];
        CGFloat changeHeight = newRect.size.height - oldRect.size.height;
        self.frame = CGRectMake(0, self.frame.origin.y - changeHeight, self.frame.size.width, self.frame.size.height + changeHeight);
        [self KVOChangeHeight];
    }
}

- (void)KVOChangeHeight {
        self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-_kFacePanelHeight, CGRectGetWidth(self.frame), _kFacePanelHeight);
//            self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kMorePanelHeight, CGRectGetWidth(self.frame), kMorePanelHeight);
    //        self.OAtoolbar.frame = CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), kChatToolBarHeight);
    [self changeKeyBoardTopY];
}

#pragma mark - <WJChatToolBarDelegate>

//打开自定义面板
- (void)chatToolBarDidSelectedIndex:(NSInteger)index {
    //判断index.......
    [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.facePanel.hidden = NO;
        
        self.frame = CGRectMake(0, [self getSupviewH:self.keyboardInitialFrame]-CGRectGetHeight(self.frame), kScreenWidth, CGRectGetHeight(self.frame));
        
        self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-_kFacePanelHeight, CGRectGetWidth(self.frame), _kFacePanelHeight);
        
    } completion:nil];
     [self.chatToolBar.textView resignFirstResponder];
    [self changeKeyBoardTopY];
}

//隐藏自定义面板
- (void)chatToolBarDidNotSelectedIndex:(NSInteger)index {
    // 判断index...

    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, [self getSupviewH:self.keyboardInitialFrame]-CGRectGetHeight(self.frame)+_kFacePanelHeight, kScreenWidth, CGRectGetHeight(self.frame));
        self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), _kFacePanelHeight);
    }];
    [self.chatToolBar.textView resignFirstResponder];
    [self changeKeyBoardTopY];
}

// ----- 输入状态

- (void)chatToolBarTextViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardTextViewDidBeginEditing:)]) {
        [self.delegate chatKeyBoardTextViewDidBeginEditing:textView];
    }
}
- (void)chatToolBarSendText:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSendText:)]) {
        [self.delegate chatKeyBoardSendText:text];
    }
    [self.chatToolBar clearTextViewContent];
}
- (void)chatToolBarTextViewDidChange:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardTextViewDidChange:)]) {
        [self.delegate chatKeyBoardTextViewDidChange:textView];
    }
}

#pragma mark -- FacePanelDelegate
- (void)facePanelFacePicked:(FacePanel *)facePanel faceSize:(NSInteger)faceSize faceName:(NSString *)faceName delete:(BOOL)isDelete
{
    NSString *text = self.chatToolBar.textView.text;
    if (isDelete) {
        if (text.length > 1) {
            [self.chatToolBar setTextViewContent:[text substringToIndex:text.length - 1]];
        }else {
            [self.chatToolBar setTextViewContent:@""];
        }
    }else {
        [self.chatToolBar setTextViewContent:[text stringByAppendingString:faceName]];
    }
    
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardFacePicked:faceSize:faceName:delete:)]) {
        [self.delegate chatKeyBoardFacePicked:self faceSize:faceSize faceName:faceName delete:isDelete];
    }
}

- (void)facePanelSendTextAction:(FacePanel *)facePanel
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSendText:)]) {
        [self.delegate chatKeyBoardSendText:self.chatToolBar.textView.text];
    }
    [self.chatToolBar clearTextViewContent];
}

- (void)facePanelAddSubject:(FacePanel *)facePanel
{
//    if ([self.delegate respondsToSelector:@selector(chatKeyBoardAddFaceSubject:)]) {
//        [self.delegate chatKeyBoardAddFaceSubject:self];
//    }
}
- (void)facePanelSetSubject:(FacePanel *)facePanel
{
//    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSetFaceSubject:)]) {
//        [self.delegate chatKeyBoardSetFaceSubject:self];
//    }
}

#pragma mark - setter

- (void)setDataSource:(id<WJChatKeyBoardDataSource>)dataSource {
    _dataSource = dataSource;
    if (dataSource == nil) {
        return;
    }
    if ([self.dataSource respondsToSelector:@selector(chatKeyBoardFacePanelSubjectItems)]) {
        NSArray<FaceSubjectModel *> *subjectMItems = [self.dataSource chatKeyBoardFacePanelSubjectItems];
        [self.facePanel loadFaceSubjectItems:subjectMItems];
    }
    if ([self.dataSource respondsToSelector:@selector(chatKeyBoardToolbarItems)]) {
        NSArray<WJChatToolBarItemModel*> *modelArray = [self.dataSource chatKeyBoardToolbarItems];
        self.chatToolBar.itemDataArray = modelArray;
    }
    
}

@end
