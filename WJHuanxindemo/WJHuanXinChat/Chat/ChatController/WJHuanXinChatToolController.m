//
//  WJHuanXinChatToolController.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/9.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinChatToolController.h"
#import "WJChatKeyBoard.h"

@interface WJHuanXinChatToolController ()<WJChatKeyBoardDataSource,WJChatKeyBoardDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)WJChatKeyBoard *keyBoard;
@end

@implementation WJHuanXinChatToolController

#pragma mark - 懒加载

- (WJChatKeyBoard *)keyBoard {
    if (!_keyBoard) {
        _keyBoard = [WJChatKeyBoard keBoardWithType:WJChatKeyBoardTypeChat translucent:YES];
        _keyBoard.dataSource = self;
        _keyBoard.delegate = self;
    }
    return _keyBoard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天键盘UI";
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        self.edgesForExtendedLayout =  UIRectEdgeNone;
//    }
    self.tableView.height = SCREEN_HEIGHT - 89 - 64;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.keyBoard];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPressed:)];
    [self.tableView addGestureRecognizer:tap];
    
}

#pragma mark - 事件监听

- (void)tapPressed:(UITapGestureRecognizer *)sender {
    [self.keyBoard hideKeyBoard];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.keyBoard hideKeyBoard];
}

#pragma mark - <WJChatKeyBoardDataSource>

- (NSArray<FaceSubjectModel *> *)chatKeyBoardFacePanelSubjectItems {
    return [FaceSourceManager loadFaceSource];
}

- (NSArray<WJChatToolBarItemModel *> *)chatKeyBoardToolbarItems {
    //－－－－里面适配的是6个
    NSMutableArray *mutable = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        WJChatToolBarItemModel *model = [WJChatToolBarItemModel new];
        model.normalString = @"f_static_007";
        model.selectedString = @"f_static_015";
        [mutable addObject:model];
    }
    return mutable;
}

#pragma mark - <WJChatKeyBoardDelegate>

- (void)chatKeyBoardTextViewDidBeginEditing:(UITextView *)textView {
//    [self tableViewChangeToEidtMode];
}
- (void)chatKeyBoardSendText:(NSString *)text {
    NSLog(@"%@",text);
    [self.store sendTextMessage:text];
}
- (void)chatKeyBoardTextViewDidChange:(UITextView *)textView {

}

- (void)chatKeyBoardDidChangeFrameToTopY:(CGFloat)TopY {
   [UIView animateWithDuration:0.25 animations:^{
       [self tableViewChangeToEidtMode];
   }];
}
#pragma mark - others

- (void)tableViewChangeToEidtMode
{
    self.tableView.height = self.keyBoard.top - 64;
    if(self.tableView.contentSize.height > self.tableView.frame.size.height){
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height) animated:NO];
    }
}

@end
