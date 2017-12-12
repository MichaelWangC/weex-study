//
//  ConfigInfo.m
//  ios
//
//  Created by Michael on 2017/9/30.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "ConfigInfo.h"

#if TARGET_IPHONE_SIMULATOR
#define DEMO_HOST @"127.0.0.1"
#else
#define DEMO_HOST @"192.168.2.135"
#endif

@implementation ConfigInfo

+ (ConfigInfo*) sharedInstance {
    static ConfigInfo *sharedObj = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"env.plist" ofType:nil];
        if(!path){
            @throw [NSException exceptionWithName:@"HsError Environmental" reason:@"Error Environmental no file" userInfo:nil];
        }
        NSDictionary* envDict = [NSDictionary dictionaryWithContentsOfFile:path];
        if (!envDict) {
            @throw [NSException exceptionWithName:@"HsError Environmental" reason:@"Error Environmental parse error" userInfo:nil];
        }
        
        sharedObj = [[ConfigInfo alloc] init];
        
        NSString* releaseTypeStr = [envDict objectForKey:@"ReleaseType"];
        if([@"DEBUG" isEqualToString:releaseTypeStr]){
            sharedObj->_releaseType = ReleaseTypeDebug;
        } else if([@"PUBLISH" isEqualToString:releaseTypeStr]){
            sharedObj->_releaseType = ReleaseTypePublish;
        } else if([@"DEV" isEqualToString:releaseTypeStr]){
            sharedObj->_releaseType = ReleaseTypeDev;
        }
    });
    
    return sharedObj;
}

#pragma mark
#pragma mark api url
-(NSString *) urlApiBase {
    static NSString* url = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        switch (self.releaseType) {
            case ReleaseTypeDev: // 开发环境
                url = [self devApiUrl];
                break;
            case ReleaseTypeDebug: // 测试
                url = [self debugApiUrl];
                break;
            case ReleaseTypePublish: // 生成
                url = [self publishApiUrl];
                break;
            default:
                url = @"";
                break;
        }
    });
    
    return url;
}

#pragma mark
#pragma mark weex url
-(NSString *) urlWeexBase {
    static NSString* url = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        switch (self.releaseType) {
            case ReleaseTypeDev: // 开发环境
                url = [self devWeexUrl];
                break;
            case ReleaseTypeDebug: // 测试
                url = [self debugWeexUrl];
                break;
            case ReleaseTypePublish: // 生成
                url = [self publishWeexUrl];
                break;
            default:
                url = @"";
                break;
        }
    });
    
    return url;
}

-(NSString *) urlWeexHome {
    NSString *url = [NSString stringWithFormat:@"%@dist/weex/index.js",[self urlWeexBase]];
    return url;
}

-(NSString *) urlWeexRoot {
    NSString *url = [NSString stringWithFormat:@"%@dist/weex/",[self urlWeexBase]];
    return url;
}

#pragma mark
#pragma mark vue url
-(NSString *) urlVueBase {
    static NSString* url = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        switch (self.releaseType) {
            case ReleaseTypeDev: // 开发环境
                url = [self devVueUrl];
                break;
            case ReleaseTypeDebug: // 测试
                url = [self debugVueUrl];
                break;
            case ReleaseTypePublish: // 生成
                url = [self publishVueUrl];
                break;
            default:
                url = @"";
                break;
        }
    });
    
    return url;
}

#pragma mark
#pragma mark api 地址
-(NSString *) devApiUrl {
    return [NSString stringWithFormat:@"http://192.168.225.35:8088/front/"];
}

-(NSString *) debugApiUrl {
    return [NSString stringWithFormat:@"http://192.168.225.35:8088/front/"];
}

-(NSString *) publishApiUrl {
    return [NSString stringWithFormat:@"http://192.168.225.35:8088/front/"];
}

#pragma mark
#pragma mark weex 开发环境 地址
-(NSString *) devWeexUrl {
    return [NSString stringWithFormat:@"http://%@:8008/",DEMO_HOST];
}

#pragma mark weex 测试 地址
-(NSString *) debugWeexUrl {
    return [NSString stringWithFormat:@"http://%@:8008/",DEMO_HOST];
}

#pragma mark weex 生产环境 地址
-(NSString *) publishWeexUrl {
    return [NSString stringWithFormat:@"http://%@:8008/",DEMO_HOST];
}

#pragma mark
#pragma mark vue 开发环境 地址
-(NSString *) devVueUrl {
    return [NSString stringWithFormat:@"http://%@:8081/",DEMO_HOST];
}

#pragma mark vue 测试 地址
-(NSString *) debugVueUrl {
    return [NSString stringWithFormat:@"http://%@:8081/",DEMO_HOST];
}

#pragma mark vue 生产环境 地址
-(NSString *) publishVueUrl {
    return [NSString stringWithFormat:@"http://%@:8081/",DEMO_HOST];
}

@end
