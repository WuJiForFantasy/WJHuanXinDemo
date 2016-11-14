//
//  WJHuanXinBorderInfo.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinBorderInfo.h"

@implementation WJHuanXinBorderInfo

//左边的边框
+ (WJHuanXinBorderInfo *)defaultBorderInfoFromOther {
    
    UIImage *normal;
    normal = [UIImage imageNamed:@"message_ic_left_bubble"];
    normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(22, 20, 40, 10)];
    WJHuanXinBorderInfo *info = [[WJHuanXinBorderInfo alloc]init];
    info.leftPadding = 22;
    info.rightPadding = 10;
    info.topPadding = 35;
    info.bottomPadding = 10;
    info.borderImage = normal;
    return info;
}

//右边的边框
+ (WJHuanXinBorderInfo *)defaultBorderInfoFromMe {
    UIImage *normal;
    normal = [UIImage imageNamed:@"message_ic_right_bubble"];
    normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(10, 12, 40, 30) resizingMode:UIImageResizingModeStretch];
    
    WJHuanXinBorderInfo *info = [[WJHuanXinBorderInfo alloc]init];
    info.leftPadding = 10;
    info.rightPadding = 20;
    info.topPadding = 35;
    info.bottomPadding = 22;
    info.borderImage = normal;
    return info;
}

@end
