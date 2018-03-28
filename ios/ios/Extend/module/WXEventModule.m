//
//  WXEventModule.m
//  ios
//
//  Created by Michael on 2017/10/11.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "WXEventModule.h"
#import "WeexViewController.h"
#import "ConfigInfo.h"
#import "UserInfoUtil.h"

@implementation WXEventModule

@synthesize weexInstance;
WX_EXPORT_METHOD(@selector(openURL:))
WX_EXPORT_METHOD(@selector(openURL:callback:))
WX_EXPORT_METHOD(@selector(popPage))
WX_EXPORT_METHOD(@selector(gotoMainTabbar))
WX_EXPORT_METHOD(@selector(showLoadingStatus))
WX_EXPORT_METHOD(@selector(hideLoadingStatus))
WX_EXPORT_METHOD(@selector(showGestureLock:))
WX_EXPORT_METHOD(@selector(openTelprompt:))
WX_EXPORT_METHOD(@selector(navigationNext))

#pragma mrak
#pragma mark weex页面跳转
- (void)openURL:(NSString *)url {
    [self openURL:url callback:nil];
}

- (void)openURL:(NSString *)url callback:(WXModuleCallback)callback {
    NSString *newURL = url;
    if ([url hasPrefix:@"//"]) {
        newURL = [NSString stringWithFormat:@"http:%@", url];
    } else if ([url hasPrefix:@"@"]) {
        NSString *urlRoot = [[ConfigInfo sharedInstance] urlWeexRoot];
        url = [url substringFromIndex:1];
        
        NSString *baseUrl = [[ConfigInfo sharedInstance] urlWeexBase];
        if ([baseUrl isEqualToString:@""]) {
            //获取问号的位置，问号后是参数列表
            NSRange range = [url rangeOfString:@"?"];
            //获取参数列表
            NSString *propertys = [url substringFromIndex:(int)(range.location+1)];
            
            // 去除 .js
            NSRange rangeJs = [url rangeOfString:@".js"];
            url = [url substringToIndex:rangeJs.location];
            
            url = [[NSBundle mainBundle] pathForResource:url ofType:@"js" inDirectory:@"weex"];
            url = [NSString stringWithFormat:@"%@?%@",url,propertys];
        }
        newURL = [NSString stringWithFormat:@"%@%@", urlRoot, url];
    } else if (![url hasPrefix:@"http"]) {
        // relative path
        newURL = [NSURL URLWithString:url relativeToURL:weexInstance.scriptURL].absoluteString;
    }
    
    WeexViewController *controller = [[WeexViewController alloc] init];
    NSDictionary *params = [self getParamsFromUrl:newURL];
    // 参数处理 title
    NSString *title = [params objectForKey:@"title"];
    if (title == nil || [title isEqualToString:@""]) {
        title = @"";
    }
    [controller setUrl:newURL title:title];
    // 导航栏是否透明
    NSString *navBarIsClear = [params objectForKey:@"navBarIsClear"];
    if (navBarIsClear == nil || [navBarIsClear isEqualToString:@""]) {
        navBarIsClear = @"false";
    }
    if ([navBarIsClear isEqualToString:@"true"]) {
        controller.navBarIsClear = YES;
    } else {
        controller.navBarIsClear = NO;
    }
    // 导航栏是否隐藏
    NSString *isHiddenNavBar = [params objectForKey:@"isHiddenNavBar"];
    if (isHiddenNavBar == nil || [isHiddenNavBar isEqualToString:@""]) {
        isHiddenNavBar = @"false";
    }
    if ([isHiddenNavBar isEqualToString:@"true"]) {
        controller.isHiddenNavBar = YES;
    } else {
        controller.isHiddenNavBar = NO;
    }
    // 返回按钮 图标 类型设置
    NSString *backButtonType = [params objectForKey:@"backButtonType"];
    if ([backButtonType isEqualToString:@"BackButtonTypeWhite"]) {
        controller.backButtonType = BackButtonTypeWhite;
    } else {
        controller.backButtonType = BackButtonTypeGray;
    }
    // 禁止右滑 返回
    NSString *disableInteractivePop = [params objectForKey:@"disableInteractivePop"];
    if ([disableInteractivePop isEqualToString:@"true"]) {
        controller.rt_disableInteractivePop = YES;
    } else {
        controller.rt_disableInteractivePop = NO;
    }
    // webview 的页面 停止声音
    NSString *closeWebMusic = [params objectForKey:@"closeWebMusic"];
    if ([closeWebMusic isEqualToString:@"true"]) {
        controller.closeWebMusic = true;
    }
    
    if (callback) {
        [controller setOnCreate:^{
            callback(@"onCreate");
        }];
    }
    
    [[weexInstance.viewController navigationController] pushViewController:controller animated:YES];
}

- (void)openTelprompt:(NSString *)telephone {
    NSString *str=[NSString stringWithFormat:@"telprompt://%@",telephone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void) popPage {
    [[weexInstance.viewController navigationController] popViewControllerAnimated:YES];
}

#pragma mark 跳转到main tabbar
-(void)gotoMainTabbar {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = [delegate mainController];
}

#pragma mark 跳转到 手势密码界面
-(void)showGestureLock:(NSString *)type {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = [delegate gestureController:type];
}

#pragma mark 引导页面跳转
-(void)navigationNext {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *token = [UserInfoUtil sharedInstance].token;
    if (token) {
        if ([UserDefaultsUtil boolForKey:BOOLEAN_USE_GERSURE_LOCK]) {
            delegate.window.rootViewController = [[BaseNavViewController alloc] initWithRootViewController:[delegate gestureController:@"lock"]];
        } else {
            delegate.window.rootViewController = [[BaseNavViewController alloc] initWithRootViewController:[delegate mainController]];
        }
    } else {
        delegate.window.rootViewController = [[BaseNavViewController alloc] initWithRootViewController:[delegate loginController]];
    }
}

#pragma mark loading框展示
-(void)showLoadingStatus {
    [((BaseViewController *)weexInstance.viewController) showLoadingStatus];
}

-(void)hideLoadingStatus {
    [((BaseViewController *)weexInstance.viewController) hideLoadingStatus];
}

#pragma mark
#pragma mark private event
#pragma mark 获取url参数
-(NSDictionary *)getParamsFromUrl:(NSString *)url {
    //获取问号的位置，问号后是参数列表
    NSRange range = [url rangeOfString:@"?"];
    
    //获取参数列表
    NSString *propertys = [url substringFromIndex:(int)(range.location+1)];
    
    // 特殊字符处理
    propertys = [propertys stringByReplacingOccurrencesOfString:@"&nbsp" withString:@" "];
    
    //进行字符串的拆分，通过&来拆分，把每个参数分开
    NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
    
    //把subArray转换为字典
    //tempDic中存放一个URL中转换的键值对
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:4];
    
    for (int j = 0 ; j < subArray.count; j++)
    {
        //在通过=拆分键和值
        NSArray *dicArray = [subArray[j] componentsSeparatedByString:@"="];
        //给字典加入元素
        if (dicArray.count > 1) {
            [tempDic setObject:dicArray[1] forKey:dicArray[0]];
        }
    }
    NSLog(@"打印参数列表生成的字典：\n%@", tempDic);
    return tempDic;
}

@end
