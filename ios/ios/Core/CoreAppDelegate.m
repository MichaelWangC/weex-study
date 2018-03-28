//
//  CoreAppDelegate.m
//  ios
//
//  Created by Michael on 2017/12/25.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "CoreAppDelegate.h"
#import "UserInfoUtil.h"
#import "UserDefaultsUtil.h"
#import "HybridViewController.h"

@implementation CoreAppDelegate

#pragma loginOut
-(void) doLogout{
    
    [UserDefaultsUtil setBool:NO forKey:BOOLEAN_USE_GERSURE_LOCK];
    UserInfoUtil *user = [UserInfoUtil sharedInstance];
    [user clear];
    
    self.mainController = nil;
    
    self.window.rootViewController = [[BaseNavViewController alloc] initWithRootViewController:[self loginController]];
    [[NSNotificationCenter defaultCenter] postNotificationName:APP_LOGIN_OUT_NOTIFICATION object:nil];
    [HttpUtil clearCookies];
}
    
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    
    return result;
}

// 查找当前界面有没有一个AlertView
-(BOOL)isAlert{
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        NSArray* subviews = window.subviews;
        if ([subviews count] > 0)
            if ([[subviews objectAtIndex:0] isKindOfClass:[UIAlertView class]])
                return YES;
    }
    return NO;
}
    
@end
