//
//  UserDefaultsUtil.h
//  ios
//  沙盒保存信息
//  Created by Michael on 2017/12/25.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用户名 用于校验是否删除应用后 是否重新安装
#define USER_CDOE @"USER_CDOE"

// APP第一次开启=YES,开启以后,APP_FIRST_OPEN_MARK=NO
#define APP_FIRST_OPEN_MARK @"APP_FIRST_OPEN_MARK"

// 版本号,每次打开会更新版本号=1.0.3
#define APP_VERSION_INFO @"APP_VERSION_INFO"

// 头像数据保存
#define APP_HEADER_ICON_DATA @"APP_HEADER_ICON_DATA"

// 手势密码开启
#define BOOLEAN_USE_GERSURE_LOCK @"BOOLEAN_USE_GERSURE_LOCK"

@interface UserDefaultsUtil : NSObject

// 设置int值
+ (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;
// 获取int值
+ (NSInteger)integerForKey:(NSString *)defaultName;

// 设置double值
+ (void)setDouble:(double)value forKey:(NSString *)code;
// 获取double值
+ (double)doubleForKey:(NSString *)code;

// 设置string值
+ (void)setString:(NSString*)value forKey:(NSString *)code;
// 获取string值
+ (NSString*)stringForKey:(NSString *)code;

// 设置bool值
+ (void)setBool:(BOOL)value forKey:(NSString *)code;
// 获取bool值
+ (BOOL)boolForKey:(NSString *)code;
    
// 设置obj值
+ (void)setObject:(NSObject*)value forKey:(NSString *)code;
// 获取ojb值
+ (id)objectForKey:(NSString *)code;

// 初始化默认参数
+ (void)firstSetup;
    
@end
