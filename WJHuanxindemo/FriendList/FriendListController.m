//
//  FriendListController.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "FriendListController.h"
#import "FriendStore.h"
#import "WJHuanXinChatBaseController.h"
#import "WJHuanXinChatToolController.h"
@interface FriendListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)FriendStore *store;

@end

@implementation FriendListController

#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _tableView;
}

- (FriendStore *)store {
    if (!_store) {
        _store = [FriendStore new];
    }
    return _store;
}

#pragma mark - 生命周期

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"虚拟好友列表";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.textLabel.text = self.store.dataArray[indexPath.row];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.store.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self gotoChatController:self.store.dataArray[indexPath.row]];
}

#pragma mark - others

- (void)gotoChatController:(NSString *)string {
    WJHuanXinChatToolController *chat = [[WJHuanXinChatToolController alloc]initWithConversationChatter:string conversationType:EMConversationTypeChat];
    [self.navigationController pushViewController:chat animated:YES];
}


@end
