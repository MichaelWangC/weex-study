//
//  UserDefaultsUtil.m
//  ios
//
//  Created by Michael on 2017/12/25.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "UserDefaultsUtil.h"

@implementation UserDefaultsUtil

//设置int值
+ (void)setInteger:(NSInteger)value forKey:(NSString *)code{
    NSUserDefaults *userdata = [NSUserDefaults standardUserDefaults];
    [userdata setInteger:value forKey:code];
    [userdata synchronize];
//    NSLog(@"##HsUserDefaults.set#%@ is:%ld",code,value);
}
//获取int值
+ (NSInteger)integerForKey:(NSString *)code{
    NSInteger value = [[NSUserDefaults standardUserDefaults]integerForKey:code];
//    NSLog(@"##HsUserDefaults.get#%@ is:%ld",code,value);
    return value;
}

//设置int值
+ (void)setDouble:(double)value forKey:(NSString *)code{
    NSUserDefaults *userdata = [NSUserDefaults standardUserDefaults];
    [userdata setDouble:value forKey:code];
    [userdata synchronize];
//    NSLog(@"##HsUserDefaults.set#%@ is:%lf",code,value);
}

//获取double值
+ (double)doubleForKey:(NSString *)code{
    double value = [[NSUserDefaults standardUserDefaults]doubleForKey:code];
//    NSLog(@"##HsUserDefaults.get#%@ is:%lf",code,value);
    return value;
}

//设置obj值
+ (void)setString:(NSString*)value forKey:(NSString *)code{
    NSUserDefaults *userdata = [NSUserDefaults standardUserDefaults];
    [userdata setObject:value forKey:code];
    [userdata synchronize];
//    NSLog(@"##HsUserDefaults.set#%@ is:%@",code,value);
}
//获取string值
+ (NSString*)stringForKey:(NSString *)code{
    NSString *value = [[NSUserDefaults standardUserDefaults]objectForKey:code];
//    NSLog(@"##HsUserDefaults.get#%@ is:%@",code,value);
    return value;
}

//设置bool值
+ (void)setBool:(BOOL)value forKey:(NSString *)code{
    NSUserDefaults *userdata = [NSUserDefaults standardUserDefaults];
    [userdata setBool:value forKey:code];
    [userdata synchronize];
//    NSLog(@"##HsUserDefaults.set#%@ is:%@",code,value?@"YES":@"NO");
}
//获取bool值
+ (BOOL)boolForKey:(NSString *)code{
    BOOL value = [[NSUserDefaults standardUserDefaults]boolForKey:code];
//    NSLog(@"##HsUserDefaults.get#%@ is:%@",code,value?@"YES":@"NO");
    return value;
}

//设置obj值
+ (void)setObject:(NSObject*)value forKey:(NSString *)code{
    NSUserDefaults *userdata = [NSUserDefaults standardUserDefaults];
    [userdata setObject:value forKey:code];
    [userdata synchronize];
//    NSLog(@"##HsUserDefaults.set#%@ is:%@",code,value?@"YES":@"NO");
}
//获取ojb值
+ (id)objectForKey:(NSString *)code{
    id value = [[NSUserDefaults standardUserDefaults]objectForKey:code];
//    NSLog(@"##HsUserDefaults.get#%@ is:%@",code,value?@"YES":@"NO");
    return value;
}
    
#pragma mark 初始
+ (void)firstSetup{
}
    
@end
