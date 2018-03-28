//
//  WXHTTPModule.h
//  ios
//
//  Created by Michael on 2018/1/8.
//  Copyright © 2018年 weexstudy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WXModuleProtocol.h>

@interface WXHTTPModule : NSObject <WXModuleProtocol>

-(void)request:(NSDictionary *)data callback:(WXModuleCallback)callback;
-(void)login:(NSDictionary *)data callback:(WXModuleCallback)callback;

@end
