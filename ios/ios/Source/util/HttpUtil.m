//
//  HttpUtil.m
//  ios
//
//  Created by Michael on 2017/12/10.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "HttpUtil.h"
#import "AFNetworking.h"
#import "UserInfoUtil.h"
#import "HSJSONKit.h"

static int _hshttputilTimeOut = 60;
static AFHTTPSessionManager *_httpManager;
static dispatch_queue_t concurrentLoginQueue;
static dispatch_group_t group;

@interface HttpErrorResult : NSObject

@property (nonatomic) int code;
@property (nonatomic,strong) NSString* message;

@end

@implementation HttpErrorResult

@end

#pragma mark
#pragma mark HttpUtil
@implementation HttpUtil

+(void) initialize {
    if(!_httpManager) {
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            _httpManager = [AFHTTPSessionManager manager];
            _httpManager.requestSerializer.timeoutInterval = _hshttputilTimeOut;
            _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                      @"application/json",
                                                                      @"text/json",
                                                                      @"text/javascript",
                                                                      @"text/html", nil];
            
            concurrentLoginQueue = dispatch_queue_create("login.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
            group = dispatch_group_create();
        });
    }
}

// get
+(void)getAsynchronous:(NSString*)finalURL
        successHandler:(void(^)(id _Nullable data)) successHandler
          errorHandler:(void(^)(NSError *error)) errorHandler {
    
    NSString *encodedUrl = [finalURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *nsUrl = [NSURL URLWithString:encodedUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:_hshttputilTimeOut];
    [request setHTTPMethod:@"GET"];
    // 请求头设置
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    [request setValue:@"AJAX" forHTTPHeaderField:@"REQUEST-TYPE"];
    NSString *token = [UserInfoUtil sharedInstance].token;
    if (token) {
        [request setValue:token forHTTPHeaderField:@"token"];
    }
    
    NSURLSessionDataTask *dataTask = [_httpManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            errorHandler(error);
        } else {
            [self handleResonseObject:responseObject request:request successHandler:successHandler errorHandler:errorHandler];
        }
    }];
    [dataTask resume];
}

// post
+(void)postAsynchronousWithURL:(NSString*)finalURL data:(NSDictionary*)postData
                successHandler:(void(^)(id _Nullable data)) successHandler
                  errorHandler:(void(^)(NSError *error)) errorHandler {
    [self postAsynchronousWithURL:finalURL data:postData isJsonType:NO successHandler:successHandler errorHandler:errorHandler];
}

+(void)postAsynchronousWithURL:(NSString * _Nonnull)finalURL data:(NSDictionary * _Nullable)postData isJsonType:(BOOL)isJsonType
                successHandler:(void(^_Nullable)(id _Nullable data)) successHandler
                  errorHandler:(void(^_Nullable)(NSError * _Nullable error)) errorHandler {
    NSLog(@"running...");
    
    NSString *encodedUrl = [finalURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSMutableString* postStr = [NSMutableString string];
    for(NSString* key in postData){
        [postStr appendString:@"&"];
        [postStr appendString:key];
        [postStr appendString:@"="];
        NSString *value = [NSString stringWithFormat:@"%@", [postData objectForKey:key]];
        [postStr appendString:value];
    }
    
    NSLog(@"postSynchronousWithURL = %@?%@",finalURL,postStr);
    
    if(postStr.length>0){
        [postStr replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    NSURL *nsUrl = [NSURL URLWithString:encodedUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:_hshttputilTimeOut];
    [request setHTTPMethod:@"POST"];
    if (isJsonType) {
        NSString *jsonData = [postData JSONString];
        [request setHTTPBody:[jsonData dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    } else {
        [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    }
    // 请求头设置
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    [request setValue:@"AJAX" forHTTPHeaderField:@"REQUEST-TYPE"];
    NSString *token = [UserInfoUtil sharedInstance].token;
    if (token) {
        [request setValue:token forHTTPHeaderField:@"token"];
    }
    
    [_httpManager setCompletionQueue:concurrentLoginQueue];
    NSURLSessionDataTask *dataTask = [_httpManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            errorHandler(error);
        } else {
            [HttpUtil handleResonseObject:responseObject request:request successHandler:successHandler errorHandler:errorHandler];
        }
    }];
    [dataTask resume];
}
#pragma mark 返回数据判断
+(void)handleResonseObject:(id)responseObject request:(NSURLRequest*)request successHandler:(void(^)(id _Nullable data)) successHandler errorHandler:(void(^)(NSError *error)) errorHandler{
    if([responseObject isKindOfClass:[NSDictionary class]]){
        // 返回数据正常
        id status = [responseObject objectForKey:@"status"];
        NSString *statusStr = [NSString stringWithFormat:@"%@", status];
        if ([statusStr isEqualToString:@"100"]) {
            // 未登录 跳到登录页面
            dispatch_async(dispatch_get_main_queue(), ^{
                [((CoreAppDelegate *)[UIApplication sharedApplication].delegate) doLogout];
            });
            NSError *error1 = [NSError errorWithDomain:@"数据异常" code:100 userInfo:@{NSLocalizedDescriptionKey: @"登录验证过期或未登录，请重新登录"}];
            errorHandler(error1);
        } else if ([statusStr isEqualToString:@"500"]) {
            NSString *msg = [responseObject objectForKey:@"statuMsg"];
            NSError *error1 = [NSError errorWithDomain:@"数据异常" code:500 userInfo:@{NSLocalizedDescriptionKey: msg}];
            errorHandler(error1);
        } else {
            // 正常
            successHandler(responseObject);
        }
    } else {
        // 返回数据异常
        NSError *error = [NSError errorWithDomain:@"数据异常" code:500 userInfo:@{NSLocalizedDescriptionKey: @"数据异常"}];
        errorHandler(error);
    }
}

#pragma mark 重新登录
+(void)reloginWithSuccessHandler:(void(^)(id _Nullable data)) successHandler errorHandler:(void(^)(NSError *error)) errorHandler{
    if (![[UserInfoUtil sharedInstance] isLogined]) {
        // 从未登录过 弹出登录界面
        errorHandler(nil);
        return;
    }
    static BOOL isLogging = NO;
    static BOOL isLogined = NO;
    if (!isLogging) {
        @synchronized(self){
            if(!isLogging){
                isLogined = NO;
                dispatch_group_async(group, concurrentLoginQueue, ^{
                    dispatch_group_enter(group);
                    NSString* usercode = [UserInfoUtil sharedInstance].userCode;
                    NSString* password = [UserInfoUtil sharedInstance].password;
                    [HttpUtil login:usercode password:password successHandler:^(id  _Nullable data) {
                        isLogined = YES;
                        isLogging = NO;
                        dispatch_group_leave(group);
                    } errorHandler:^(NSError * _Nullable error) {
                        isLogined = NO;
                        isLogging = NO;
                        dispatch_group_leave(group);
                    }];
                });
                isLogging = YES;
            }
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //之前有登陆失败的请求，应用已经退回至登陆界面
        if(![[UserInfoUtil sharedInstance] isLogined]){
            errorHandler(nil);
            return;
        }
        
        if(isLogined){
            successHandler(nil);
            return;
        }else{
            errorHandler(nil);
            return;
        }
    });
}

#pragma mark 登录
+(void)login:(NSString * _Nonnull)phone password:(NSString * _Nonnull)password successHandler:(void(^_Nullable)(id _Nullable data)) successHandler errorHandler:(void(^_Nullable)(NSError * _Nullable error)) errorHandler{
    // 登录
    NSString *url = [[ConfigInfo sharedInstance] urlAPILogin];
    NSDictionary *data = @{@"phone": phone,@"code": password};
    
    [HttpUtil postAsynchronousWithURL:url data:data successHandler:^(id  _Nullable data) {
        if([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = data;
            NSInteger status = [[dict objectForKey:@"status"] integerValue];
            
            if (status == 200) {
                // 获取用户数据
                UserInfoUtil *user = [UserInfoUtil sharedInstance];
                
                NSDictionary *retData = [dict objectForKey:@"data"];
                user.token = [retData objectForKey:@"token"];
                
                NSDictionary *userInfo = [retData objectForKey:@"user"];
                user.userCode = [userInfo objectForKey:@"userCode"];
                user.loginCode = [userInfo objectForKey:@"loginCode"];
                user.mphone = [userInfo objectForKey:@"mphone"];
                user.userName = [userInfo objectForKey:@"userName"];
                user.memo = [userInfo objectForKey:@"memo"];
                [user save];

                [[NSNotificationCenter defaultCenter] postNotificationName:APP_LOGIN_SUCCESS_NOTIFICATION object:nil];

                successHandler(data);
                
            } else {
                NSString *errorMsg = [dict objectForKey:@"statuMsg"];
                NSError *error = [NSError errorWithDomain:@"登录失败" code:500 userInfo:@{NSLocalizedDescriptionKey: errorMsg}];
                errorHandler(error);
            }
        }
    } errorHandler:^(NSError * _Nullable error) {
        errorHandler(error);
    }];
    
}

#pragma mark 清除cookie
+(void)clearCookies {
    NSURL *baseUrl = [NSURL URLWithString:[[ConfigInfo sharedInstance] urlApiBase]];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:baseUrl];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}
    
@end
