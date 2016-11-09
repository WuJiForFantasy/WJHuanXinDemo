//
//  WJChatToolBar.m
//  QQ聊天输入键盘
//
//  Created by 幻想无极（谭启宏） on 16/8/29.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJChatToolBar.h"
#import "RFTextView.h"
#import "WJChatToolCell.h"

#define TextViewH               36
#define TextViewVerticalOffset  10 //(ItemH-TextViewH)/2.0
#define COLLECTION_WIDTH (CGRectGetWidth(self.bounds)-20)

@interface WJChatToolBar ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** 临时记录输入的textView */
@property (nonatomic, copy) NSString *currentText;

@property CGFloat previousTextViewHeight;


@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation WJChatToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.indexSelected = - 1;
        self.previousTextViewHeight = TextViewH;
        [self initSubviews];
        
    }
    return self;
}

- (void)initSubviews {
    
    
    
    self.userInteractionEnabled = YES;
    self.textView = [[RFTextView alloc] init];
    self.textView.delegate = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = (COLLECTION_WIDTH-40*6)/5;
    layout.minimumInteritemSpacing = 1;
    layout.itemSize = CGSizeMake(40, 40);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[WJChatToolCell class] forCellWithReuseIdentifier:@"cellID"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.textView];
    [self addSubview:self.collectionView];
    
    [self setbarSubViewsFrame];
    //KVO监听输入框的内容大小
    [self addObserver:self forKeyPath:@"self.textView.contentSize" options:(NSKeyValueObservingOptionNew) context:nil];
    [self collectionViewFrameChange];
}

- (void)setbarSubViewsFrame {
    
    self.textView.frame = CGRectMake(TextViewVerticalOffset, 5, COLLECTION_WIDTH, TextViewH);
    
}

//- (void)layoutSubviews {
//   
//}

- (void)collectionViewFrameChange {
     self.collectionView.frame = CGRectMake(TextViewVerticalOffset, CGRectGetHeight(self.bounds)-40, COLLECTION_WIDTH, 40);
}

- (void)setItemDataArray:(NSArray<WJChatToolBarItemModel *> *)itemDataArray {
    _itemDataArray = itemDataArray;
    [self.collectionView reloadData];
}

#pragma mark -- 调整文本内容
- (void)setTextViewContent:(NSString *)text
{
    self.currentText = self.textView.text = text;
}
- (void)clearTextViewContent
{
    self.currentText = self.textView.text = @"";
}

#pragma mark -- 调整placeHolder
- (void)setTextViewPlaceHolder:(NSString *)placeholder
{
    if (placeholder == nil) {
        return;
    }
    
    self.textView.placeHolder = placeholder;
}

- (void)setTextViewPlaceHolderColor:(UIColor *)placeHolderColor
{
    if (placeHolderColor == nil) {
        return;
    }
    self.textView.placeHolderTextColor = placeHolderColor;
}



#pragma mark - <UITextViewDelegate>
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //重置选择
    self.indexSelected = -1;
    [self.collectionView reloadData];
  
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(chatToolBarTextViewDidBeginEditing:)])
    {
        [self.delegate chatToolBarTextViewDidBeginEditing:self.textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if ([self.delegate respondsToSelector:@selector(chatToolBarSendText:)])
        {
            self.currentText = @"";
            [self.delegate chatToolBarSendText:textView.text];
        }
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    self.currentText = textView.text;
    
    if ([self.delegate respondsToSelector:@selector(chatToolBarTextViewDidChange:)])
    {
        [self.delegate chatToolBarTextViewDidChange:self.textView];
    }
}


#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WJChatToolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    WJChatToolBarItemModel *model = self.itemDataArray[indexPath.row];
    [cell.itemButton setImage:[UIImage imageNamed:model.normalString] forState:UIControlStateNormal];
    [cell.itemButton setImage:[UIImage imageNamed:model.selectedString] forState:UIControlStateSelected];
    if (self.indexSelected == indexPath.row) {
        cell.itemButton.selected = YES;
    }else {
        cell.itemButton.selected = NO;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemDataArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.indexSelected == indexPath.row) {
        self.indexSelected = -1;
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatToolBarDidNotSelectedIndex:)]) {
            [self.delegate chatToolBarDidNotSelectedIndex:indexPath.row];
        }
    }else {
        self.indexSelected = indexPath.row;
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatToolBarDidSelectedIndex:)]) {
            [self.delegate chatToolBarDidSelectedIndex:indexPath.row];
        }
    }
    [self.collectionView reloadData];
   
}

#pragma mark -- 私有方法

- (void)adjustTextViewContentSize
{
    //调整 textView
    self.currentText = self.textView.text;

}

- (void)resumeTextViewContentSize
{
    self.textView.text = self.currentText;
}

#pragma mark -- kvo回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"self.textView.contentSize"]) {
        [self layoutAndAnimateTextView:self.textView];
    }
}
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"self.textView.contentSize"];
    
}
#pragma mark -- 计算textViewContentSize改变

- (CGFloat)getTextViewContentH:(RFTextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

- (CGFloat)fontWidth
{
    return 36.f; //16号字体
}

- (CGFloat)maxLines
{
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    CGFloat line = 5;
    if (h == 480) {
        line = 3;
    }else if (h == 568){
        line = 3.5;
    }else if (h == 667){
        line = 4;
    }else if (h == 736){
        line = 4.5;
    }
    return line;
}

- (void)layoutAndAnimateTextView:(RFTextView *)textView
{
    CGFloat maxHeight = [self fontWidth] * [self maxLines];
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < self.previousTextViewHeight;
    CGFloat changeInHeight = contentH - self.previousTextViewHeight;
    
    if (!isShrinking && (self.previousTextViewHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self adjustTextViewHeightBy:changeInHeight];
                             }
                             CGRect inputViewFrame = self.frame;
                             self.frame = CGRectMake(0.0f,
                                                     0, //inputViewFrame.origin.y - changeInHeight
                                                     inputViewFrame.size.width,
                                                     (inputViewFrame.size.height + changeInHeight));
                             [self collectionViewFrameChange];
                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        self.previousTextViewHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    //动态改变自身的高度和输入框的高度
    CGRect prevFrame = self.textView.frame;
    
    NSUInteger numLines = MAX([self.textView numberOfLinesOfText],
                              [[self.textView.text componentsSeparatedByString:@"\n"] count] + 1);
    
    
    self.textView.frame = CGRectMake(prevFrame.origin.x, prevFrame.origin.y, prevFrame.size.width, prevFrame.size.height + changeInHeight);
    
    self.textView.contentInset = UIEdgeInsetsMake((numLines >=6 ? 4.0f : 0.0f), 0.0f, (numLines >=6 ? 4.0f : 0.0f), 0.0f);
    
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    //self.messageInputTextView.scrollEnabled = YES;
    if (numLines >=6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.textView.contentSize.height-self.textView.bounds.size.height);
        [self.textView setContentOffset:bottomOffset animated:YES];
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length-2, 1)];
    }
}



@end
