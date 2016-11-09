//
//  WJHuanXinChatToolController.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/9.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinChatToolController.h"
#import "WJChatKeyBoard.h"

@interface WJHuanXinChatToolController ()<WJChatKeyBoardDataSource,WJChatKeyBoardDelegate>

//@property (nonatomic,strong)EaseFaceView *faceView;
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
    [self.view addSubview:self.keyBoard];
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
    
}
- (void)chatKeyBoardSendText:(NSString *)text {
    NSLog(@"%@",text);
    [self.store sendTextMessage:text];
}
- (void)chatKeyBoardTextViewDidChange:(UITextView *)textView {

}

@end
