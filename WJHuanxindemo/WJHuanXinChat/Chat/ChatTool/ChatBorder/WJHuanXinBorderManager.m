//
//  WJHuanXinBorderManager.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinBorderManager.h"
#import "WJHuanXinBorderInfo.h"
#import "MLEmojiLabel.h"
#import "YYText.h"

@interface WJHuanXinBorderManager ()

@property (nonatomic,strong)WJHuanXinBorderInfo *info;
@property (nonatomic,strong)EaseMessageModel *msg;

@end

@implementation WJHuanXinBorderManager

#pragma mark - 初始化

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIImage *normal;
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
        self.leftPadding = 10;
        self.rightPadding = 10;
        self.topPadding = 1;
        self.bottomPadding = 1;
    }
    return self;
}


- (instancetype)initWithMsg:(EaseMessageModel *)msg {
    self = [super init];
    if (self) {
        
        self.msg = msg;
        //计算frame方法
        if (msg.bodyType == EMMessageBodyTypeText) {
            static MLEmojiLabel *protypeLabel = nil;
            if (!protypeLabel) {
                protypeLabel = [MLEmojiLabel new];
                protypeLabel.numberOfLines = 0;
                protypeLabel.font = [UIFont systemFontOfSize:14.0f];
                protypeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                protypeLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
                protypeLabel.isNeedAtAndPoundSign = YES;
                protypeLabel.disableEmoji = NO;
                protypeLabel.lineSpacing = 3.0f;
                protypeLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
                protypeLabel.customEmojiPlistName = @"expressionImage_custom.plist";
            }
            
            [protypeLabel setText:msg.text];
            CGSize size = [protypeLabel preferredSizeWithMaxWidth:WJCHAT_CELL_CONTENT_MAXWIDTH-20];
            self.labelWidth = size.width;
            self.labelHeight = size.height+5;
            
            if (self.labelHeight < 25) {
                self.labelHeight = 30;
            }
        }
        if (msg.message.direction == EMMessageDirectionReceive) {
            self.info = [WJHuanXinBorderInfo defaultBorderInfoFromOther];
            
        }else {
            self.info = [WJHuanXinBorderInfo defaultBorderInfoFromMe];
        }
        switch (msg.bodyType) {
            case EMMessageBodyTypeText:
                [self msgText];
                break;
                
            case EMMessageBodyTypeVoice:
                [self msgAudio];
                break;
                
            case EMMessageBodyTypeImage:
            case EMMessageBodyTypeVideo:
                [self picMsgAndVideoMsg];
                break;
                //            case IMMsgTypeEmotion:
                //                [self msgEmotion];
                //                break;
            case EMMessageBodyTypeLocation:
                [self msgLocation];
            default:
                break;
        }

    }
    return self;
}

#pragma mark - 根据不同的类型选择

- (void)msgText {
    self.width = self.labelWidth + self.info.leftPadding + self.info.rightPadding;
    self.height = self.labelHeight + self.info.bottomPadding;
    
    self.leftPadding = self.info.leftPadding;
    if (self.labelHeight == 30) {
        self.topPadding = 5;
    }else {
        self.topPadding = 10;
    }
}


- (void)msgAudio {
    CGFloat testf = 20;
    
    CGFloat width = WJCHAT_CELL_CONTENT_MAXWIDTH * testf / 60;//秒速
    //    if (width < 200) {
    //        width = 200;
    //    }else if (width > WJCHAT_CELL_CONTENT_MAXWIDTH) {
    //        width = WJCHAT_CELL_CONTENT_MAXWIDTH;
    //    }
    //这里修改了下
    width = 120;
    self.width = width;
    self.height = 44;
    if (self.msg.message.direction == EMMessageDirectionReceive) {
        self.leftPadding = 15;
        self.rightPadding = 15;
    }else {
        self.rightPadding = 15;
        self.leftPadding = 5;
    }
}

- (void)picMsgAndVideoMsg {
    
    UIImage *image = [UIImage imageNamed:@"20150207101056_tGZfA.thumb.700_0"];
    
    CGFloat f = image.size.height/image.size.width;
    
    CGFloat width = image.size.width;
    if (image.size.width/WJCHAT_CELL_CONTENT_MAXWIDTH > 0) {
        width = WJCHAT_CELL_CONTENT_MAXWIDTH;
    }else {
        width = image.size.width;
    }
    
    CGFloat height = width * f;
    
    self.width = width;
    self.height = height;
}

- (void)msgEmotion {
    self.width = 120;
    self.height = 120;
}

- (void)msgLocation {
    self.width = 200;
    self.height = 150;
}

- (UIImage *)borderImage {
    return self.info.borderImage;
}

@end
