//
//  WJHuanXinChatBaseController.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinChatBaseController.h"
#import "WJHuanXinChatMsgCellUtil.h"
#import "WJHuanXinChatStore.h"
@interface WJHuanXinChatBaseController ()<UITableViewDelegate,UITableViewDataSource> {
    
}

@property (nonatomic,strong) WJHuanXinChatStore *store;         //数据配置管理
@property (nonatomic,strong) UITableView *tableView;            //列表

@end

@implementation WJHuanXinChatBaseController

#pragma mark - init

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType {
    self = [super init];
    if (self) {
        //进入的时候获取会话对象
        [self.store getConversationChatter:conversationChatter];
    }
    return self;
}

- (WJHuanXinChatStore *)store {
    if (!_store) {
        _store = [WJHuanXinChatStore new];
    }
    return _store;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"20150207101056_tGZfA.thumb.700_0"]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - 生命周期

- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.store.tableView = self.tableView;
    [self.store startConversation];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"send" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.store tableViewDidTriggerHeaderRefresh];
}

#pragma mark - 事件监听

- (void)rightItemPressed {
//    [self.store sendTextMessage:@"123"];
    //发送了地理位置
//    [self.store sendLocationMessageLatitude:39.929986 longitude:116.37926 andAddress:@"这是测试地址"];
    //发送图片
//    [self.store sendImageMessage:[UIImage imageNamed:@"20150207101056_tGZfA.thumb.700_0"]];
    NSString *url =  [[NSBundle mainBundle]pathForResource:@"Maria Arredondo - Burning" ofType:@"mp3"];
    [self.store sendVoiceMessageWithLocalPath:url duration:10];
    
//    NSString *str = [[NSBundle mainBundle]pathForResource:@"02" ofType:@"mov"];
//    NSURL *urlPath = [NSURL URLWithString:str];
//    [self.store sendVideoMessageWithURL:urlPath];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.store.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    id object = [self.store.dataArray objectAtIndex:indexPath.row];
    //time cell
    if ([object isKindOfClass:[NSString class]]) {
        NSString *TimeCellIdentifier = [EaseMessageTimeCell cellIdentifier];
        EaseMessageTimeCell *timeCell = (EaseMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        
        if (timeCell == nil) {
            timeCell = [[EaseMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeCellIdentifier];
            timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        timeCell.title = object;
        return timeCell;
    }else {
        //自定义各种类型的cell
        cell = [WJHuanXinChatMsgCellUtil tableView:tableView cellForMsg:object];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.store.dataArray objectAtIndex:indexPath.row];
    //返回高度
    return [WJHuanXinChatMsgCellUtil cellHeightForMsg:object];
}


#pragma mark - other

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
