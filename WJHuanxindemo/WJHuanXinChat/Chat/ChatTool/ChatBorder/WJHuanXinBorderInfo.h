//
//  WJHuanXinBorderInfo.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <Foundation/Foundation.h>

/**边框+详细参数，不完整，等待修改*/
@interface WJHuanXinBorderInfo : NSObject

@property (nonatomic,assign)CGFloat leftPadding; //左边
@property (nonatomic,assign)CGFloat rightPadding; //右边
@property (nonatomic,assign)CGFloat topPadding;  //顶部
@property (nonatomic,assign)CGFloat bottomPadding;//底部

@property (nonatomic,strong)UIImage *borderImage;//边框图片

+ (WJHuanXinBorderInfo *)defaultBorderInfoFromOther;
+ (WJHuanXinBorderInfo *)defaultBorderInfoFromMe;

@end
