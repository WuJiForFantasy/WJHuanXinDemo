//
//  MainController.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "MainController.h"

@interface MainController ()<UIAlertViewDelegate>

@end

@implementation MainController

#pragma mark - 懒加载

- (MainStore *)store {
    if (!_store) {
        _store = [MainStore new];
    }
    return _store;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录" delegate:self cancelButtonTitle:@"登录" otherButtonTitles:nil];
    alertView.delegate = self;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];

    __weak typeof(self) myself = self;
    [self.store setUnreadMsgNumBlock:^(NSInteger num) {
        NSLog(@"没有读取的消息-----%ld",num);
        if (num == 0) {
            myself.viewControllers[0].tabBarItem.badgeValue = nil;
        }else {
            myself.viewControllers[0].tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",num];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField *textFeild = [alertView textFieldAtIndex:0];
    [[EMClient sharedClient] loginWithUsername:textFeild.text password:@"123" completion:^(NSString *aUsername, EMError *aError) {
        NSLog(@"%@",aError.errorDescription);
        if (!aError) {
            NSLog(@"用户:%@登录成功",aUsername);
        }else {
            NSLog(@"登录失败");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
