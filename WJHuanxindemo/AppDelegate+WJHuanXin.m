//
//  AppDelegate+WJHuanXin.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "AppDelegate+WJHuanXin.h"
#import "WJHuanXinChatHelper.h"

@implementation AppDelegate (WJHuanXin)

- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig
{
    //注册登录状态监听
 //   [[NSNotificationCenter defaultCenter] addObserver:self
   //                                          selector:@selector(loginStateChange:)
     //                                            name:KNOTIFICATION_LOGINCHANGE
       //                                        object:nil];
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:appkey
                                         apnsCertName:apnsCertName
                                          otherConfig:nil];
    
    //聊天的监听，网络状态，消息接收等。。。
    [WJHuanXinChatHelper shareHelper];
    
//    BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
//    if (isAutoLogin){
//     //   [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
//    }
//    else
//    {
//       // [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//    }
}

- (void)easemobApplication:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didReceiveRemoteNotification:userInfo];
}

#pragma mark - App Delegate

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - EMPushManagerDelegateDevice

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.content", @"Apns content")
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
    
}

@end
