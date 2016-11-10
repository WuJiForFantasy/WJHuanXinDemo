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
#import "EaseMessageReadManager.h"
#import "UIAlertController+Blocks.h"

@interface WJHuanXinChatBaseController ()<UITableViewDelegate,UITableViewDataSource,WJHuanXinChatBaseCellDelegate> {
    
}



@end

@implementation WJHuanXinChatBaseController

#pragma mark - init

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType {
    self = [super init];
    if (self) {
        self.title = @"聊天通信";
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
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
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemPressed)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.view addSubview:self.tableView];
    self.store.tableView = self.tableView;
    [self.store startConversationWithVc:self];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"send" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.store tableViewDidTriggerHeaderRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.store.isViewDidAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    self.store.isViewDidAppear = NO;
}

#pragma mark - 事件监听

- (void)leftItemPressed {
    [self.store stopConversation];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemPressed {
  
    [UIAlertController showActionSheetInViewController:self withTitle:@"发送类型" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"普通文本" otherButtonTitles:@[@"图片",@"语音",@"视频",@"定位地址"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            switch (buttonIndex) {
                case 1:
                    [self sendText];
                    break;
                case 2:
                    [self sendPic];
                    break;
                case 3:
                    [self sendeMusic];
                    break;
                case 4:
                    [self sendVideo];
                    break;
                case 5:
                    [self sendLocation];
                    break;
                default:
                    break;
            }
        });
    }];
}

#pragma mark - 消息发送---------------

- (void)sendVideo {
    NSString *videoUrl =  [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer/02.mov",NSHomeDirectory()];
    [self.store sendVideoMessageWithURL:[NSURL URLWithString:videoUrl]];
}

- (void)sendeMusic {
    NSString *url =  [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer/147866230657845.amr",NSHomeDirectory()];
    [self.store sendVoiceMessageWithLocalPath:url duration:10];
}

- (void)sendPic {
    [self.store sendImageMessage:[UIImage imageNamed:@"20150207101056_tGZfA.thumb.700_0"]];
}

- (void)sendLocation {
    [self.store sendLocationMessageLatitude:39.929986 longitude:116.37926 andAddress:@"这是测试地址"];
}

- (void)sendText {
    [self.store sendTextMessage:@"[示例3]"];
}

#pragma mark ----------------

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
        WJHuanXinChatBaseCell *newcell = (WJHuanXinChatBaseCell*)cell;
        newcell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.store.dataArray objectAtIndex:indexPath.row];
    //返回高度
    return [WJHuanXinChatMsgCellUtil cellHeightForMsg:object];
}

#pragma mark - <WJHuanXinChatBaseCellDelegate>

- (void)messageCellSelected:(id<IMessageModel>)model {
    switch (model.bodyType) {
        case EMMessageBodyTypeImage:
        {
//            _scrollToBottomWhenAppear = NO;
            [self _imageMessageCellSelected:model];
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            [self _locationMessageCellSelected:model];
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            [self _audioMessageCellSelected:model];
        }
            break;
        case EMMessageBodyTypeVideo:
        {
            [self _videoMessageCellSelected:model];
            
        }
            break;
        case EMMessageBodyTypeFile:
        {
//            _scrollToBottomWhenAppear = NO;
            [self showHint:@"Custom implementation!"];
            NSLog(@"文件来咯");
        }
            break;
        default:
            break;
    }
}

- (void)statusButtonSelcted:(id<IMessageModel>)model withMessageCell:(EaseMessageCell *)messageCell {

}

- (void)avatarViewSelcted:(id<IMessageModel>)model {
    
}

#pragma mark - others

//地址选中
- (void)_locationMessageCellSelected:(id<IMessageModel>)model
{
//    _scrollToBottomWhenAppear = NO;
    
    EaseLocationViewController *locationController = [[EaseLocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
    [self.navigationController pushViewController:locationController animated:YES];
}

//图片选中
- (void)_imageMessageCellSelected:(id<IMessageModel>)model {
    __weak typeof(self) weakSelf = self;
    EMImageMessageBody *imageBody = (EMImageMessageBody*)[model.message body];
    if ([imageBody type] == EMMessageBodyTypeImage) {
        //如果是成功状态
        if (imageBody.thumbnailDownloadStatus == EMDownloadStatusSuccessed) {
            if (imageBody.downloadStatus == EMDownloadStatusSuccessed)
            {
                //send the acknowledgement
                [weakSelf.store _sendHasReadResponseForMessages:@[model.message] isRead:YES];
                NSString *localPath = model.message == nil ? model.fileLocalPath : [imageBody localPath];
                if (localPath && localPath.length > 0) {
                    UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                    
                    if (image)
                    {
                        //弹出图片视图
                        [[EaseMessageReadManager defaultManager] showBrowserWithImages:@[image]];
                    }
                    else
                    {
                        NSLog(@"Read %@ failed!", localPath);
                    }
                    return;
                }
            }
            
            [weakSelf showHudInView:weakSelf.view hint:NSEaseLocalizedString(@"message.downloadingImage", @"downloading a image...")];
            [[EMClient sharedClient].chatManager downloadMessageAttachment:model.message progress:nil completion:^(EMMessage *message, EMError *error) {
                [weakSelf hideHud];
                if (!error) {
                    //send the acknowledgement
                    [weakSelf.store _sendHasReadResponseForMessages:@[model.message] isRead:YES];
                    NSString *localPath = message == nil ? model.fileLocalPath : [(EMImageMessageBody*)message.body localPath];
                    if (localPath && localPath.length > 0) {
                        UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                        //                                weakSelf.isScrollToBottom = NO;
                        if (image)
                        {
                            [[EaseMessageReadManager defaultManager] showBrowserWithImages:@[image]];
                        }
                        else
                        {
                            NSLog(@"Read %@ failed!", localPath);
                        }
                        return ;
                    }
                }
                [weakSelf showHint:NSEaseLocalizedString(@"message.imageFail", @"image for failure!")];
            }];
        }else{
            //get the message thumbnail
            [[EMClient sharedClient].chatManager downloadMessageThumbnail:model.message progress:nil completion:^(EMMessage *message, EMError *error) {
                if (!error) {
                    [weakSelf.store _reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:NSEaseLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
            }];
        }
    }
}

//音频选中
- (void)_audioMessageCellSelected:(id<IMessageModel>)model {
    
    EMVoiceMessageBody *body = (EMVoiceMessageBody*)model.message.body;
    EMDownloadStatus downloadStatus = [body downloadStatus];
    
    if (downloadStatus == EMDownloadStatusDownloading) {
        [self showHint:NSEaseLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        return;
    }
    else if (downloadStatus == EMDownloadStatusFailed)
    {
        [self showHint:NSEaseLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        [[EMClient sharedClient].chatManager downloadMessageAttachment:model.message progress:nil completion:nil];
        return;
    }
    
    // play the audio
    if (model.bodyType == EMMessageBodyTypeVoice) {
        //send the acknowledgement
        [self.store _sendHasReadResponseForMessages:@[model.message] isRead:YES];
        
        __weak typeof(self) weakSelf = self;
        BOOL isPrepare = [[EaseMessageReadManager defaultManager] prepareMessageAudioModel:model updateViewCompletion:^(EaseMessageModel *prevAudioModel, EaseMessageModel *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                [weakSelf.tableView reloadData];
            }
        }];
        
        //如果已经准备
        if (isPrepare) {
            _isPlayingAudio = YES;
            __weak typeof(self) weakSelf = self;
            //播放音频路径
            [[EMCDDeviceManager sharedInstance] enableProximitySensor];
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:model.fileLocalPath completion:^(NSError *error) {
                [[EaseMessageReadManager defaultManager] stopMessageAudioModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    weakSelf.isPlayingAudio = NO;
                    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
                });
            }];
        }
        else{
            _isPlayingAudio = NO;
        }
    }
}

//视频选中
- (void)_videoMessageCellSelected:(id<IMessageModel>)model {
    EMVideoMessageBody *videoBody = (EMVideoMessageBody*)model.message.body;
    
    NSString *localPath = [model.fileLocalPath length] > 0 ? model.fileLocalPath : videoBody.localPath;
    if ([localPath length] == 0) {
        [self showHint:NSEaseLocalizedString(@"message.videoFail", @"video for failure!")];
        return;
    }
    dispatch_block_t block = ^{
        //send the acknowledgement
        [self.store _sendHasReadResponseForMessages:@[model.message]
                                       isRead:YES];
        
        NSURL *videoURL = [NSURL fileURLWithPath:localPath];
        MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
        [moviePlayerController.moviePlayer prepareToPlay];
        moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
    };
    __weak typeof(self) weakSelf = self;
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error)
        {
            [weakSelf.store _reloadTableViewDataWithMessage:aMessage];
        }
        else
        {
            [weakSelf showHint:NSEaseLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
        }
    };
    
    //如果加载失败或者没有缩略图就下载缩略图
    if (videoBody.thumbnailDownloadStatus == EMDownloadStatusFailed || ![[NSFileManager defaultManager] fileExistsAtPath:videoBody.thumbnailLocalPath]) {
        [self showHint:@"begin downloading thumbnail image, click later"];
        
        [[EMClient sharedClient].chatManager downloadMessageThumbnail:model.message progress:nil completion:completion];
        return;
    }
    
    //如果是下载成功状态就播放视频，否则进入下载视频
    if (videoBody.downloadStatus == EMDownloadStatusSuccessed && [[NSFileManager defaultManager] fileExistsAtPath:localPath])
    {
        block();
        return;
    }
    [self showHudInView:self.view hint:NSEaseLocalizedString(@"message.downloadingVideo", @"downloading video...")];
    [[EMClient sharedClient].chatManager downloadMessageAttachment:model.message progress:nil completion:^(EMMessage *message, EMError *error) {
        [weakSelf hideHud];
        if (!error) {
            block();
        }else{
            [weakSelf showHint:NSEaseLocalizedString(@"message.videoFail", @"video for failure!")];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
