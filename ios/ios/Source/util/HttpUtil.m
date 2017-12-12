//
//  HttpUtil.m
//  ios
//
//  Created by Michael on 2017/12/10.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "HttpUtil.h"
#import "AFNetworking.h"

static NSOperationQueue *_sharedNetworkQueue;
static int _hshttputilTimeOut=20;

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
    
    if(!_sharedNetworkQueue) {
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            _sharedNetworkQueue = [[NSOperationQueue alloc] init];
            //            [_sharedNetworkQueue addObserver:[self self] forKeyPath:@"operationCount" options:0 context:NULL];
            [_sharedNetworkQueue setMaxConcurrentOperationCount:6];
        });
    }
}

//
+(void)getAsynchronous:(NSString*)finalURL
        successHandler:(void(^)(NSData *data)) successHandler
          errorHandler:(void(^)(NSError *error)) errorHandler {
    
    NSString *encodedUrl = [finalURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:encodedUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successHandler(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorHandler(error);
    }];
}

//post
+(void)postAsynchronousWithURL:(NSString*)finalURL data:(NSDictionary*)postData
                successHandler:(void(^)(NSData *data)) successHandler
                  errorHandler:(void(^)(NSError *error)) errorHandler {
    NSLog(@"running...");
    
    NSString *encodedUrl = [finalURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];

    AFHTTPSessionManager *manange = [AFHTTPSessionManager manager];
    [manange POST:encodedUrl parameters:postData progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successHandler(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorHandler(error);
    }];
}

@end
