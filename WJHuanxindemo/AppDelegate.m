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

-(NSString*) copyFile2Documents:(NSString*)fileName
{
    NSFileManager*fileManager =[NSFileManager defaultManager];
    NSError*error;
    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString*documentsDirectory =[paths objectAtIndex:0];
    
    NSString*destPath =[documentsDirectory stringByAppendingPathComponent:fileName];
    
    //  如果目标目录也就是(Documents)目录没有数据库文件的时候，才会复制一份，否则不复制
    if(![fileManager fileExistsAtPath:destPath]){
        NSString* sourcePath =[[NSBundle mainBundle] pathForResource:fileName ofType:@""];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:&error];
        
    }
    return destPath;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self copyFile2Documents:@"testMovie.mov"];
     [self copyFile2Documents:@"testMusic.amr"];
//    NSError *error = nil;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"testMovie.mov" ofType:nil];
//    NSLog(@"%@",path);
//    
//    BOOL flag = [[NSFileManager defaultManager] copyItemAtPath:path
//                                                        toPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
//                                                         error:&error];
//    if (flag) {
//        NSLog(@"成功");
//    }else {
//        NSLog(@"失败");
//    }
    
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"testMusic.amr" ofType:nil];
//    BOOL flag1 = [[NSFileManager defaultManager] copyItemAtPath:path1
//                                                        toPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
//                                                         error:&error];
    NSLog(@"%@",NSHomeDirectory());
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
    
//    main.tabBar.hidden = YES;
    
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
