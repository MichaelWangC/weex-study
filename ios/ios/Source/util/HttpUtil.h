//
//  HttpUtil.h
//  ios
//
//  Created by Michael on 2017/12/10.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_LOGIN_SUCCESS_NOTIFICATION @"APP_LOGIN_SUCCESS_NOTIFICATION"
#define APP_LOGIN_OUT_NOTIFICATION @"APP_LOGIN_OUT_NOTIFICATION"

@interface HttpUtil : NSObject

+(void)getAsynchronous:(NSString * _Nonnull)finalURL
        successHandler:(void(^_Nullable)(id _Nullable data)) successHandler
          errorHandler:(void(^_Nullable)(NSError * _Nullable error)) errorHandler;

+(void)postAsynchronousWithURL:(NSString * _Nonnull)finalURL data:(NSDictionary * _Nullable)postData
                successHandler:(void(^_Nullable)(id _Nullable data)) successHandler
                  errorHandler:(void(^_Nullable)(NSError * _Nullable error)) errorHandler;

+(void)postAsynchronousWithURL:(NSString * _Nonnull)finalURL data:(NSDictionary * _Nullable)postData isJsonType:(BOOL)isJsonType 
                successHandler:(void(^_Nullable)(id _Nullable data)) successHandler
                  errorHandler:(void(^_Nullable)(NSError * _Nullable error)) errorHandler;

+(void)login:(NSString * _Nonnull)phone password:(NSString * _Nonnull)password successHandler:(void(^_Nullable)(id _Nullable data)) successHandler errorHandler:(void(^_Nullable)(NSError * _Nullable error)) errorHandler;

+(void)clearCookies;
    
@end
