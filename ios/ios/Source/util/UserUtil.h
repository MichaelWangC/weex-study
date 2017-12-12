//
//  UserUtil.h
//  ios
//  保存用户基本信息，使用钥匙串
//  Created by Michael on 2017/12/11.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserUtil : NSObject

@property (strong, nonatomic) NSString* userCode;
@property (strong, nonatomic) NSString* password;
@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* identityNo; // 证件号
@property (strong, nonatomic) NSString* identityType; // 证件类型

+ (UserUtil *) sharedInstance;
-(void)save;
-(void)clear;
// 判断是否登录过
-(BOOL)isLogin;

-(NSString *)getValueByKey:(NSString *)key;
-(void)saveValueByKey:(NSString *)key value:(NSString *)value;

@end
