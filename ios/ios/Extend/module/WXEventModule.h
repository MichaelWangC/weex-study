//
//  WXEventModule.h
//  ios
//
//  Created by Michael on 2017/10/11.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WXEventModuleProtocol.h>
#import <WeexSDK/WXModuleProtocol.h>

@interface WXEventModule : NSObject <WXEventModuleProtocol, WXModuleProtocol>

-(void) popPage;

@end
