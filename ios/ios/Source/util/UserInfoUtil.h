//
//  UserUtil.h
//  ios
//  保存用户基本信息，使用钥匙串 保存 加密信息
//  Created by Michael on 2017/12/11.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoUtil : NSObject

@property (copy, nonatomic) NSString* userCode;
@property (copy, nonatomic) NSString* password;
@property (copy, nonatomic) NSString* userName;
@property (copy, nonatomic) NSString* loginCode;
@property (copy, nonatomic) NSString* mphone;
@property (copy, nonatomic) NSString* token;
@property (copy, nonatomic) NSString* gestruePassword;
@property (copy, nonatomic) NSString* memo;

+ (UserInfoUtil *) sharedInstance;
-(void)save;
-(void)clear;
// 判断是否登录过
-(BOOL)isLogined;

-(NSString *)getValueByKey:(NSString *)key;
-(void)saveValueByKey:(NSString *)key value:(NSString *)value;

@end
