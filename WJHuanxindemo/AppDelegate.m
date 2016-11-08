//
//  AppDelegate.m
//  WJHuanxindemo
//
//  Created by 幻想无极（谭启宏） on 2016/11/7.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+WJHuanXin.h"
#import "MainController.h"
#import "WJHuanXinConversationListController.h"
//#import "FriendListController.h"
#import "FriendListController.h"
#import "WJHuanXinChatBaseController.h"
#import "WJHuanXinChatHelper.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions appkey:@"1103161107178551#moyou" apnsCertName:nil otherConfig:nil];
    
    MainController *main = [[MainController alloc]init];
    WJHuanXinConversationListController *conversation = [[WJHuanXinConversationListController alloc]init];
    conversation.title = @"消息";
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:conversation];
    
    FriendListController *friend = [[FriendListController alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:friend];
    main.viewControllers = @[nav,nav1];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = main;
    [self.window makeKeyWindow];
    
    //聊天的监听，网络状态，消息接收等。。。
    WJHuanXinChatHelper *helper = [WJHuanXinChatHelper shareHelper];
    helper.mainVC = main;
    helper.conversationListVC = conversation;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
