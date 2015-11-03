//
//  AppDelegate.m
//  chnword
//
//  Created by 苏智 on 15/6/20.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialSinaSSOHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

// 静态成员，用于程序内部其他地方便捷地引用到主程序代理
+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

// 消息处理：下一个进入商店使用直接进入套装购买界面的标记设为YES
- (void)showShopSuit:(NSNotification *)notification
{
    self.goSuit = YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Normal overwrite for the application delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.isLogin = NO;
    self.goSuit = NO;

#warning 天文分类仅用于测试
    self.wordInTianWen = @[@"日", @"月", @"夕", @"星", @"云", @"气", @"雨", @"电", @"风", @"雪", @"旦", @"朝", @"早", @"暮", @"昏"];
    self.wordInTianWenDemo = @[@"0", @"0", @"0", @"0", @"0", @"1", @"0", @"0", @"0", @"0", @"0", @"0", @"1", @"0", @"0"];

#warning 这里的分类信息最终需要从服务器获取
    self.cateNames = @[@"天文篇", @"地理篇", @"植物篇", @"动物篇", @"人姿篇", @"身体篇", @"生理篇", @"生活篇", @"活动篇", @"文化篇"];
    self.cateUnlocked = @[@"1", @"1", @"1", @"0", @"0", @"0", @"0", @"0", @"1", @"0"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showShopSuit:) name:NotiShowShopSuit object:nil];

    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //初始化友盟的sdk
    [self setUpShareSDK];

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

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - shared sdk

// 处理打开URL的方式
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

// 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

// 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

#pragma mark - SetUpShareSDK

// 配置sharedSDK
- (void)setUpShareSDK
{
    //判断是通过平台配置还是程序配置
    //注册appkey
    [UMSocialData setAppKey:AppKey_ShareSDK];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //设置平台信息
    [self setUpShareSDKPlatforms];
}

// 初始化平台信息——程序中判断
- (void)setUpShareSDKPlatforms
{
    //在你的工程设置项,targets 一栏下,选中自己的 target,在 Info->URL Types 中添加 URL Schemes,添加xcode的url scheme为微信应用appId，例如“wxd9a39c7122aa6516”
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx523e7fec6968506f" appSecret:@"4a01f28bf8671d6b5487094caaffc72e" url:@"http://www.umeng.com/social"];
    
    //在你的工程设置项,targets 一栏下,选中自己的 target,在 Info->URL Types 中添加 URL Schemes,格式为“wb”+新浪appkey，例如“wb126663232”
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //设置分享到QQ/Qzone的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1104685705" appKey:@"TaZo5RPmrGX11nPO" url:@"http://www.umeng.com/social"];
}

@end
