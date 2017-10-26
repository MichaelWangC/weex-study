//
//  WXDeviceModule.h
//  ios
//
//  Created by Michael on 2017/10/26.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WXModuleProtocol.h>

@interface WXDeviceModule : NSObject <WXModuleProtocol>

-(NSString *)getDeviceName;

@end
