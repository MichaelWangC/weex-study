//
//  main.m
//  ios
//
//  Created by Michael on 2017/9/28.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreAppDelegate.h"
#import "UserDefaultsUtil.h"
#import "UserInfoUtil.h"

int main(int argc, char * argv[]) {
    
    NSString *nowVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    NSString* saveVersion = [UserDefaultsUtil stringForKey:APP_VERSION_INFO];
    BOOL newVersion = NO;
    if (nowVersion!=nil && [nowVersion isEqualToString:saveVersion]) {
        [UserDefaultsUtil setBool:NO forKey:APP_FIRST_OPEN_MARK];
        NSLog(@"老版本");
    }else{
        [UserDefaultsUtil setBool:YES forKey:APP_FIRST_OPEN_MARK];
        NSLog(@"新版本-第一次打开");
        newVersion= YES;
    }
    
    // 更新版本号
    [UserDefaultsUtil setString:nowVersion forKey:APP_VERSION_INFO];
    
    if (newVersion) {
        //初始化默认参数.
        [UserDefaultsUtil firstSetup];
        //校验是否删除应用后 重新安装
        NSString *username = [UserDefaultsUtil stringForKey:USER_CDOE];
        if (username == nil) {
            [[UserInfoUtil sharedInstance] clear];
        }
    }
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([CoreAppDelegate class]));
    }
}
