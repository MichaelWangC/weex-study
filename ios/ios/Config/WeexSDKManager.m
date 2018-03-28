//
//  WeexSDKManager.m
//  ios
//
//  Created by Michael on 2017/9/30.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "WeexSDKManager.h"
#import <WeexSDK/WeexSDK.h>
#import "WXImgLoaderDefaultImpl.h"
#import "WXEventModule.h"
#import "WXDeviceModule.h"
#import "WXHTTPModule.h"
#import "WXNaviBarModule.h"
#import "WXLOTAnimationView.h"
#import "WXPieChartView.h"
#import "WXWeChatModule.h"
#import "WXImagePickerModule.h"
#import "WXLineChartView.h"
#import "WXUserInfoModule.h"
#import "WXMyWebView.h"

@implementation WeexSDKManager

+(void)setup {
    [WXAppConfiguration setAppGroup:@"App"];
    [WXAppConfiguration setAppName:@"WeexDemo"];
    [WXAppConfiguration setAppVersion:@"1.0.0"];
    
    [WXSDKEngine initSDKEnvironment];
    
    // handler
    [WXSDKEngine registerHandler:[WXImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
    
    // module
    [WXSDKEngine registerModule:@"event" withClass:[WXEventModule class]];
    [WXSDKEngine registerModule:@"device" withClass:[WXDeviceModule class]];
    [WXSDKEngine registerModule:@"http" withClass:[WXHTTPModule class]];
    [WXSDKEngine registerModule:@"navbar" withClass:[WXNaviBarModule class]];
    [WXSDKEngine registerModule:@"wechat" withClass:[WXWeChatModule class]];
    [WXSDKEngine registerModule:@"imagePicker" withClass:[WXImagePickerModule class]];
    [WXSDKEngine registerModule:@"userInfo" withClass:[WXUserInfoModule class]];
    
    // component
    [WXSDKEngine registerComponent:@"animal" withClass:[WXLOTAnimationView class]];
    [WXSDKEngine registerComponent:@"pieChart" withClass:[WXPieChartView class]];
    [WXSDKEngine registerComponent:@"lineChart" withClass:[WXLineChartView class]];
    [WXSDKEngine registerComponent:@"web" withClass:[WXMyWebView class]];

#ifdef DEBUG
    [WXLog setLogLevel:WXLogLevelLog];
#endif
}

@end
