//
//  AppDelegate.m
//  ios
//
//  Created by Michael on 2017/9/28.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "AppDelegate.h"
#import <WeexSDK/WeexSDK.h>
#import "WeexViewController.h"
#import "WeexSDKManager.h"
#import "MainTabbarController.h"
#import "UserInfoUtil.h"
#import "WXApi.h"
#import "UMConfigManager.h"
#import "HttpUtil.h"
#import "ConfigInfo.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate {
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 微信设置
    [WXApi registerApp:@""];
    // weex设置
    [WeexSDKManager setup];
    // 友盟设置
//    [UMConfigManager setup];
    
    BOOL newVersion = [UserDefaultsUtil boolForKey:APP_FIRST_OPEN_MARK];
    newVersion = YES;
    if (newVersion) {
        // 第一次打开 进入引导页
        self.window.rootViewController = [[BaseNavViewController alloc] initWithRootViewController:[self navigationController]];
    } else {
        NSString *token = [UserInfoUtil sharedInstance].token;
        if (token) {
            if ([UserDefaultsUtil boolForKey:BOOLEAN_USE_GERSURE_LOCK]) {
                self.window.rootViewController = [[BaseNavViewController alloc] initWithRootViewController:[self gestureController:@"lock"]];
            } else {
                self.window.rootViewController = [self mainController];
            }
        } else {
            self.window.rootViewController = [[BaseNavViewController alloc] initWithRootViewController:[self loginController]];
        }
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark 登录页面
-(UIViewController *) loginController {
    if (!_loginController) {
        NSString *baseUrl = [[ConfigInfo sharedInstance] urlWeexBase];
        BOOL isLoadLocalFile = YES;
        if (![baseUrl isEqualToString:@""]) isLoadLocalFile = NO;
        NSString *mainUrl = [NSString stringWithFormat:@"%@/modules/front/login.js", [[ConfigInfo sharedInstance] urlWeexRoot]];
        if (isLoadLocalFile) {
            mainUrl = [[NSBundle mainBundle] pathForResource:@"modules/front/login" ofType:@"js" inDirectory:@"weex"];
            mainUrl = [NSString stringWithFormat:@"%@%@", [[ConfigInfo sharedInstance] urlWeexRoot], mainUrl];
        }
        
        WeexViewController *weexController = [[WeexViewController alloc] init];
        [weexController setNavBarIsClear:YES];
        [weexController setUrl:mainUrl title:@""];
        
        _loginController = weexController;
    }
    return _loginController;
}

#pragma mark 手势密码页
-(UIViewController *) gestureController:(NSString *)type {
    NSString *baseUrl = [[ConfigInfo sharedInstance] urlWeexBase];
    BOOL isLoadLocalFile = YES;
    if (![baseUrl isEqualToString:@""]) isLoadLocalFile = NO;
    NSString *mainUrl = [NSString stringWithFormat:@"%@/modules/front/gestureLock.js", [[ConfigInfo sharedInstance] urlWeexRoot]];
    if (isLoadLocalFile) {
        mainUrl = [[NSBundle mainBundle] pathForResource:@"modules/front/gestureLock" ofType:@"js" inDirectory:@"weex"];
        mainUrl = [NSString stringWithFormat:@"%@%@", [[ConfigInfo sharedInstance] urlWeexRoot], mainUrl];
    }
    
    mainUrl = [NSString stringWithFormat:@"%@?type=%@", mainUrl, type];
    WeexViewController *weexController = [[WeexViewController alloc] init];
    weexController.backButtonType = BackButtonTypeWhite;
    [weexController setNavBarIsClear:YES];
    [weexController setUrl:mainUrl title:@""];
    
    _gestureController = weexController;
    return _gestureController;
}

#pragma mark 引导页
-(UIViewController *) navigationController {
    NSString *baseUrl = [[ConfigInfo sharedInstance] urlWeexBase];
    BOOL isLoadLocalFile = YES;
    if (![baseUrl isEqualToString:@""]) isLoadLocalFile = NO;
    NSString *mainUrl = [NSString stringWithFormat:@"%@/modules/front/navigationView.js", [[ConfigInfo sharedInstance] urlWeexRoot]];
    if (isLoadLocalFile) {
        mainUrl = [[NSBundle mainBundle] pathForResource:@"modules/front/navigationView" ofType:@"js" inDirectory:@"weex"];
        mainUrl = [NSString stringWithFormat:@"%@%@", [[ConfigInfo sharedInstance] urlWeexRoot], mainUrl];
    }
    
    WeexViewController *weexController = [[WeexViewController alloc] init];
    weexController.statusBarIsLightContent = YES;
    [weexController setNavBarIsClear:YES];
    [weexController setUrl:mainUrl title:@""];
    
    _gestureController = weexController;
    return _gestureController;
}

#pragma mark 首页
-(UIViewController *) mainController {
    
    if (!_mainController) {
        MainTabbarController *main = [[MainTabbarController alloc] init];
        _mainController = main;
    }
    return _mainController;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strMsg = @"";
        if (resp.errCode == 0) {
            strMsg = @"分享成功";
        } else {
            strMsg = [NSString stringWithFormat:@"分享失败(%d)", resp.errCode];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strMsg delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark UIApplicationDelegate
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
