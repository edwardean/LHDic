//
//  AppDelegate.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-16.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "AppDelegate.h"
#import "ProgressViewController.h"
#import "DBManager.h"
#import "UMSocial.h"
@implementation AppDelegate

#pragma mark - 创建个人收藏的数据库及在数据库中的表
- (void) createTable
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",kFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:filePath];
    if (!isExists) {//第一次数据库文件不存在,则创建数据库的同时创建两个表 
        [[DBManager sharedInstance]createTable:ShouCangTable];
        [[DBManager sharedInstance]createTable:LatestSearchTable];
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //分享模块做的设置操作
    [UMSocialData setAppKey:@"5211818556240bc9ee01db2f"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"calligrapher"] stretchableImageWithLeftCapWidth:4 topCapHeight:8]
                                       forBarMetrics:UIBarMetricsDefault];
    
    ProgressViewController *progressCtr = [[ProgressViewController alloc]init];
    self.window.rootViewController = progressCtr;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self createTable];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
