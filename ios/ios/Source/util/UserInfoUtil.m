//
//  UserUtil.m
//  ios
//
//  Created by Michael on 2017/12/11.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "UserInfoUtil.h"
#import <Security/Security.h>

NSString * const KEY_USER = @"com.user";

NSString * const KEY_USERCODE = @"usercode";
NSString * const KEY_PASSWORD = @"password";
NSString * const KEY_USERNAME = @"UserName";
NSString * const KEY_LOGINCODE = @"loginCode";
NSString * const KEY_MPHONE =  @"mphone";
NSString * const KEY_TOKEN = @"token";
NSString * const KEY_GESTRUE = @"gestruePassword";
NSString * const KEY_MEMO = @"memo";

@implementation UserInfoUtil

+ (UserInfoUtil *) sharedInstance
{
    static UserInfoUtil *sharedObj = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObj = [[UserInfoUtil alloc] init];
        [sharedObj loadData];
    });
    return sharedObj;
}

// 判断是否登录过
-(BOOL)isLogined{
    BOOL isLogined = self.userCode == nil || [self.userCode isEqualToString:@""];
    return !isLogined;
}

-(void)save{
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    if (self.userCode) {
        [usernamepasswordKVPairs setObject:self.userCode forKey:KEY_USERCODE];
        // 用于校验是否删除应用后 重新安装
        [UserDefaultsUtil setObject:self.userCode forKey:USER_CDOE];
    }
    if (self.password) {
        [usernamepasswordKVPairs setObject:self.password forKey:KEY_PASSWORD];
    }
    if (self.userName) {
        [usernamepasswordKVPairs setObject:self.userName forKey:KEY_USERNAME];
    }
    if (self.token) {
        [usernamepasswordKVPairs setObject:self.token forKey:KEY_TOKEN];
    }
    if (self.loginCode) {
        [usernamepasswordKVPairs setObject:self.loginCode forKey:KEY_LOGINCODE];
    }
    if (self.mphone) {
        [usernamepasswordKVPairs setObject:self.mphone forKey:KEY_MPHONE];
    }
    if (self.gestruePassword) {
        [usernamepasswordKVPairs setObject:self.gestruePassword forKey:KEY_GESTRUE];
    }
    if (self.memo) {
        [usernamepasswordKVPairs setObject:self.memo forKey:KEY_MEMO];
    }
    [UserInfoUtil save:KEY_USER data:usernamepasswordKVPairs];
}

-(NSString *)getValueByKey:(NSString *)key {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserInfoUtil load:KEY_USER];
    return [usernamepasswordKVPairs objectForKey:key];
}

-(void)saveValueByKey:(NSString *)key value:(NSString *)value {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserInfoUtil load:KEY_USER];
    if (usernamepasswordKVPairs == nil) {
        usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    }
    [usernamepasswordKVPairs setObject:value forKey:key];
    [UserInfoUtil save:KEY_USER data:usernamepasswordKVPairs];
}

-(void)clear{
    self.userCode=nil;
    self.password=nil;
    self.userName=nil;
    self.token=nil;
    self.mphone = nil;
    self.loginCode = nil;
    self.gestruePassword = nil;
    self.memo = nil;
    [UserInfoUtil delete:KEY_USER];
}

#pragma PRIVATE
-(void)loadData{
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserInfoUtil load:KEY_USER];
    self.userCode = [usernamepasswordKVPairs objectForKey:KEY_USERCODE];
    self.password = [usernamepasswordKVPairs objectForKey:KEY_PASSWORD];
    self.token = [usernamepasswordKVPairs objectForKey:KEY_TOKEN];
    self.userName = [usernamepasswordKVPairs objectForKey:KEY_USERNAME];
    self.mphone = [usernamepasswordKVPairs objectForKey:KEY_MPHONE];
    self.loginCode = [usernamepasswordKVPairs objectForKey:KEY_LOGINCODE];
    self.gestruePassword = [usernamepasswordKVPairs objectForKey:KEY_GESTRUE];
    self.memo = [usernamepasswordKVPairs objectForKey:KEY_MEMO];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge  id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

@end
