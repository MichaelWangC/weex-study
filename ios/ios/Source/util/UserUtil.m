//
//  UserUtil.m
//  ios
//
//  Created by Michael on 2017/12/11.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "UserUtil.h"
#import <Security/Security.h>

NSString * const KEY_USER = @"com.user";

NSString * const KEY_USERCODE = @"usercode";
NSString * const KEY_PASSWORD = @"password";
NSString * const KEY_USERNAME = @"UserName";
NSString * const KEY_IDENTITYNO = @"IdentityNo";
NSString * const KEY_IDENTITYTYPE = @"IdentityType";

@implementation UserUtil

+ (UserUtil *) sharedInstance
{
    static UserUtil *sharedObj = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObj = [[UserUtil alloc] init];
        [sharedObj loadData];
    });
    return sharedObj;
}

-(BOOL)isLogin{
    BOOL islogin = self.userCode == nil || [self.userCode isEqualToString:@""];
    return islogin;
}

-(void)save{
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:self.userCode forKey:KEY_USERCODE];
    [usernamepasswordKVPairs setObject:self.password forKey:KEY_PASSWORD];
    [usernamepasswordKVPairs setObject:self.userName forKey:KEY_USERNAME];
    [usernamepasswordKVPairs setObject:self.identityNo forKey:KEY_IDENTITYNO];
    [usernamepasswordKVPairs setObject:self.identityType forKey:KEY_IDENTITYTYPE];
    [UserUtil save:KEY_USER data:usernamepasswordKVPairs];
}

-(NSString *)getValueByKey:(NSString *)key {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserUtil load:KEY_USER];
    return [usernamepasswordKVPairs objectForKey:key];
}

-(void)saveValueByKey:(NSString *)key value:(NSString *)value {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserUtil load:KEY_USER];
    if (usernamepasswordKVPairs == nil) {
        usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    }
    [usernamepasswordKVPairs setObject:value forKey:key];
    [UserUtil save:KEY_USER data:usernamepasswordKVPairs];
}

-(void)clear{
    self.userCode=nil;
    self.password=nil;
    self.userName=nil;
    self.identityNo=nil;
    self.identityType=nil;
    [UserUtil delete:KEY_USER];
}

#pragma PRIVATE
-(void)loadData{
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserUtil load:KEY_USER];
    self.userCode = [usernamepasswordKVPairs objectForKey:KEY_USERCODE];
    self.password = [usernamepasswordKVPairs objectForKey:KEY_PASSWORD];
    self.identityNo = [usernamepasswordKVPairs objectForKey:KEY_IDENTITYNO];
    self.identityType = [usernamepasswordKVPairs objectForKey:KEY_IDENTITYTYPE];
    self.userName = [usernamepasswordKVPairs objectForKey:KEY_USERNAME];
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
