//
//  WJHuanXinConversationModel.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <Foundation/Foundation.h>

/**环信会话模型*/

@interface WJHuanXinConversationModel : NSObject

@property (strong, nonatomic, readonly) EMConversation *conversation;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *avatarURLPath;
@property (strong, nonatomic) UIImage *avatarImage;

- (instancetype)initWithConversation:(EMConversation *)conversation;

@end
