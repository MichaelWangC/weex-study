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

@implementation WeexSDKManager

+(void)setup {
    [WXAppConfiguration setAppGroup:@"App"];
    [WXAppConfiguration setAppName:@"WeexDemo"];
    [WXAppConfiguration setAppVersion:@"1.0.0"];
    
    [WXSDKEngine initSDKEnvironment];
    
    [WXSDKEngine registerHandler:[WXImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
    
    [WXSDKEngine registerModule:@"event" withClass:[WXEventModule class]];
    
#ifdef DEBUG
    [WXLog setLogLevel:WXLogLevelLog];
#endif
}

@end
