//
//  WJHuanXinChatMsgModel.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/8.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <Foundation/Foundation.h>

/**环信即时通讯cell上的模型，遵守IMessageModel协议*/

@interface WJHuanXinChatMsgModel : NSObject<IMessageModel>

@property (nonatomic) CGFloat cellHeight;

@property (strong, nonatomic, readonly) EMMessage *message;
@property (strong, nonatomic, readonly) EMMessageBody *firstMessageBody;
@property (strong, nonatomic, readonly) NSString *messageId;
@property (nonatomic, readonly) EMMessageBodyType bodyType;
@property (nonatomic, readonly) EMMessageStatus messageStatus;
@property (nonatomic, readonly) EMChatType messageType;
@property (nonatomic) BOOL isMessageRead;
// if the current login user is message sender
@property (nonatomic) BOOL isSender;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatarURLPath;
@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSAttributedString *attrBody;
@property (strong, nonatomic) NSString *address;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
//Placeholder image for network error
@property (strong, nonatomic) NSString *failImageName;
@property (nonatomic) CGSize imageSize;
@property (nonatomic) CGSize thumbnailImageSize;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *thumbnailImage;
@property (nonatomic) BOOL isMediaPlaying;
@property (nonatomic) BOOL isMediaPlayed;
@property (nonatomic) CGFloat mediaDuration;
@property (strong, nonatomic) NSString *fileIconName;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *fileSizeDes;
@property (nonatomic) CGFloat fileSize;
//progress of uploading or downloading the attachment message
@property (nonatomic) float progress;
@property (strong, nonatomic, readonly) NSString *fileLocalPath;
@property (strong, nonatomic) NSString *thumbnailFileLocalPath;
@property (strong, nonatomic) NSString *fileURLPath;
@property (strong, nonatomic) NSString *thumbnailFileURLPath;

- (instancetype)initWithMessage:(EMMessage *)message;



@end
