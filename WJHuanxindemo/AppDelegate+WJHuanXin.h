//
//  AppDelegate+WJHuanXin.h
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "AppDelegate.h"

/**环信即时通讯的类别*/

@interface AppDelegate (WJHuanXin)

/**环信授权*/

- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig;

/**环信推送服务*/
- (void)easemobApplication:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo;

@end
