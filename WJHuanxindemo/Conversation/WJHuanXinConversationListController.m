//
//  WJHuanXinConversationListController.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinConversationListController.h"
#import "WJHuanXinConversationModel.h"
#import "WJHuanXinConversationStore.h"
#import "WJHuanXinConversationCell.h"
#import "WJHuanXinChatBaseController.h"


@interface WJHuanXinConversationListController ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)WJHuanXinConversationStore *store;

@end

@implementation WJHuanXinConversationListController

#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[WJHuanXinConversationCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _tableView;
}

- (WJHuanXinConversationStore *)store {
    if (!_store) {
        _store = [WJHuanXinConversationStore new];
    }
    return _store;
}

#pragma mark - 生命周期

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    [self.view addSubview:self.tableView];
    [self.store requestAllConversations:^{
        [self.tableView reloadData];
    }];
    //获取所有会话
//    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 环信聊天管理
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
//    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EMClient sharedClient].chatManager removeDelegate:self];
//    [[EMClient sharedClient].groupManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WJHuanXinConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.model = self.store.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.store.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WJHuanXinConversationCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self gotoChatController:self.store.dataArray[indexPath.row]];
}

#pragma mark - <MGSwipeTableCellDelegate>

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
//    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
//          direction == MGSwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");
    if (direction == MGSwipeDirectionRightToLeft && index == 0) {
        //delete button
        NSIndexPath * path = [self.tableView indexPathForCell:cell];
        [self.store deleteConversationsWithModel:self.store.dataArray[path.row]];
        [self.store.dataArray removeObjectAtIndex:path.row];
        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
        return NO; //Don't autohide to improve delete expansion animation
    }
    
    return YES;
}

#pragma mark - <EMChatManagerDelegate>

- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    NSLog(@"%@",aConversationList);
     [self.store requestAllConversations:^{
        [self.tableView reloadData];
    }];
}

#pragma mark - others

- (void)gotoChatController:(WJHuanXinConversationModel *)model {
    EMConversation *conversation = model.conversation;
    WJHuanXinChatBaseController *chat = [[WJHuanXinChatBaseController alloc]initWithConversationChatter:conversation.conversationId conversationType:EMConversationTypeChat];
    [self.navigationController pushViewController:chat animated:YES];
}

@end
