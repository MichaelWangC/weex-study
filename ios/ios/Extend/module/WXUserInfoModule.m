//
//  WXUserInfoModule.m
//  ios
//
//  Created by Michael on 2018/3/1.
//  Copyright © 2018年 weexstudy. All rights reserved.
//

#import "WXUserInfoModule.h"
#import "UserInfoUtil.h"

@implementation WXUserInfoModule
WX_EXPORT_METHOD_SYNC(@selector(getUserName))
WX_EXPORT_METHOD_SYNC(@selector(getMobilePhone))
WX_EXPORT_METHOD_SYNC(@selector(getUserMemo))
WX_EXPORT_METHOD_SYNC(@selector(saveUserMemo:))
WX_EXPORT_METHOD(@selector(setGestureLockBoolean:))
WX_EXPORT_METHOD_SYNC(@selector(getGestureLockBoolean))
WX_EXPORT_METHOD(@selector(setGestureLockPassword:))
WX_EXPORT_METHOD_SYNC(@selector(getGestureLockPassword))

#pragma mark 获取用户姓名
-(NSString *)getUserName {
    return [UserInfoUtil sharedInstance].userName;
}

#pragma mark 获取手机号
-(NSString *)getMobilePhone {
    return [UserInfoUtil sharedInstance].mphone;
}

#pragma mark 获取用户简介
-(NSString *)getUserMemo {
    return [UserInfoUtil sharedInstance].memo;
}

#pragma mark 保存用户简介
-(void)saveUserMemo:(NSString *)memo {
    UserInfoUtil *info = [UserInfoUtil sharedInstance];
    info.memo = memo;
    [info save];
}

#pragma mark 设置是否开启手势密码
-(void)setGestureLockBoolean:(NSString *)isopen {
    if ([isopen isEqualToString:@"true"]) {
        [UserDefaultsUtil setBool:YES forKey:BOOLEAN_USE_GERSURE_LOCK];
    } else {
        [UserDefaultsUtil setBool:NO forKey:BOOLEAN_USE_GERSURE_LOCK];
    }
}

#pragma mark 获取是否开启手势密码
-(BOOL)getGestureLockBoolean {
    BOOL isGest = [UserDefaultsUtil boolForKey:BOOLEAN_USE_GERSURE_LOCK];
    return isGest;
}

#pragma mark 保存手势密码
-(void)setGestureLockPassword:(NSString *)password {
    UserInfoUtil *info = [UserInfoUtil sharedInstance];
    info.gestruePassword = password;
    [info save];
}

#pragma mark 获取手势密码
-(NSString *)getGestureLockPassword {
    return [UserInfoUtil sharedInstance].gestruePassword;
}

@end
