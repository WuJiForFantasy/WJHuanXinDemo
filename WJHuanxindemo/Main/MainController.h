//
//  MainController.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainStore.h"

@interface MainController : UITabBarController

@property (nonatomic,strong)MainStore *store;   //数据通知配置管理
//@property (nonatomic,strong)

@end
