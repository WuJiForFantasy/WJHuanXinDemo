//
//  MainController.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "MainController.h"

@interface MainController ()

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
    [[EMClient sharedClient] loginWithUsername:@"123" password:@"123" completion:^(NSString *aUsername, EMError *aError) {
        NSLog(@"%@",aError.errorDescription);
        if (!aError) {
            NSLog(@"用户:%@登录成功",aUsername);
        }else {
            NSLog(@"登录失败");
        }
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
