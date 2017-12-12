//
//  HttpUtil.h
//  ios
//
//  Created by Michael on 2017/12/10.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpUtil : NSObject

+(void)getAsynchronous:(NSString*)finalURL
        successHandler:(void(^)(NSData *data)) successHandler
          errorHandler:(void(^)(NSError *error)) errorHandler;

+(void)postAsynchronousWithURL:(NSString*)finalURL data:(NSDictionary*)postData
                successHandler:(void(^)(NSData *data)) successHandler
                  errorHandler:(void(^)(NSError *error)) errorHandler;

@end
