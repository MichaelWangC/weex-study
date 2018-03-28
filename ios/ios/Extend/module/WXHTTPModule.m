//
//  WXHTTPModule.m
//  ios
//
//  Created by Michael on 2018/1/8.
//  Copyright © 2018年 weexstudy. All rights reserved.
//

#import "WXHTTPModule.h"
#import "HttpUtil.h"
#import "HSJSONKit.h"

@interface WXHTTPModule ()<UIAlertViewDelegate>

@end

@implementation WXHTTPModule {
    BOOL _isAlert;
}

@synthesize weexInstance;
WX_EXPORT_METHOD(@selector(request:callback:))
WX_EXPORT_METHOD(@selector(login:callback:))
WX_EXPORT_METHOD(@selector(doLogout))
WX_EXPORT_METHOD_SYNC(@selector(getApiBaseUrl))
WX_EXPORT_METHOD_SYNC(@selector(getVueBaseUrl))
                                
#pragma mark 数据获取
-(void)request:(NSDictionary *)data callback:(WXModuleCallback)callback {
    NSString *url = [data objectForKey:@"url"];
    NSDictionary *dict = [data objectForKey:@"data"];
    
    NSString *type = [data objectForKey:@"type"];
    BOOL isJsonType = NO;
    if (type != NULL && [type isEqualToString:@"JSON"]) {
        isJsonType = YES;
    }
    // 获取api url base 地址
    NSString *apiBaseUrl = [[ConfigInfo sharedInstance] urlApiBase];
    url = [NSString stringWithFormat:@"%@%@", apiBaseUrl, url];
    [HttpUtil postAsynchronousWithURL:url data:dict isJsonType:isJsonType successHandler:^(id  _Nullable data) {
        id jsonData = data;
        NSString* dataS = [jsonData JSONString];
        if(callback) {
            callback(dataS);
        }
    } errorHandler:^(NSError * _Nullable error) {
        [self handleError:error callback:callback];
    }];
}

#pragma mark 登录
-(void)login:(NSDictionary *)data callback:(WXModuleCallback)callback {
    NSString *usercode = [data objectForKey:@"usercode"];
    NSString *password = [data objectForKey:@"password"];
    
    [HttpUtil login:usercode password:password successHandler:^(id  _Nullable data) {
        id jsonData = data;
        NSString* dataS = [jsonData JSONString];
        if(callback) {
            callback(dataS);
        }
    } errorHandler:^(NSError * _Nullable error) {
        [self handleError:error callback:callback];
    }];
}

#pragma mark 获取错误信息
-(void)handleError:(NSError *)error callback:(WXModuleCallback)callback {
    NSString *errorCode = @"500";
    if (error.code == 100) {
        // 未登录
        errorCode = @"100";
    }
    NSString *errMsg = [error localizedDescription];
    NSDictionary *data = @{
                           @"status": errorCode,
                           @"errMsg": errMsg
                           };
    NSString *dataS = [data JSONString];
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL hasShowAlert = [((CoreAppDelegate *)[UIApplication sharedApplication].delegate) isAlert];
        if (!_isAlert && !hasShowAlert) {
            _isAlert = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:errMsg
                                                           delegate:self
                                                  cancelButtonTitle:@"我知道了"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    });
    if (callback) {
        callback(dataS);
    }
    NSLog(@"web request error : %@", error);
}

#pragma mark login out
-(void) doLogout {
    [((CoreAppDelegate *)[UIApplication sharedApplication].delegate) doLogout];
}

#pragma mark 获取api 的 base url
-(NSString *)getApiBaseUrl {
    NSString *url = [[ConfigInfo sharedInstance] urlApiBase];
    return url;
}

#pragma mark 获取分享模板 的 base url
-(NSString *)getVueBaseUrl {
    NSString *url = [[ConfigInfo sharedInstance] urlVueBase];
    return url;
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    _isAlert = NO;
}

@end
