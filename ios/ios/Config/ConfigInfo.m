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
#define DEMO_HOST @"192.168.2.130"
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

-(NSString *) urlBase {
    static NSString* url = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        switch (self.releaseType) {
            case ReleaseTypeDev: // 开发环境
                url = [self devUrl];
                break;
            case ReleaseTypeDebug: // 测试
                url = [self debugUrl];
                break;
            case ReleaseTypePublish: // 生成
                url = [self publishUrl];
                break;
            default:
                url = @"http://192.168.178.103:8081/";
                break;
        }
    });
    
    return url;
}

-(NSString *) urlHome {
    NSString *url = [NSString stringWithFormat:@"%@dist/weex/index.js",[self urlBase]];
    return url;
}

#pragma mark 开发环境 地址
-(NSString *) devUrl {
    return [NSString stringWithFormat:@"http://%@:8081/",DEMO_HOST];
}

#pragma mark 公司测试 地址
-(NSString *) debugUrl {
    return [NSString stringWithFormat:@"http://%@:8081/",DEMO_HOST];
}

#pragma mark 生产环境 地址
-(NSString *) publishUrl {
    return [NSString stringWithFormat:@"http://%@:8081/",DEMO_HOST];
}

@end
