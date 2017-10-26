//
//  WXDeviceModule.m
//  ios
//
//  Created by Michael on 2017/10/26.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "WXDeviceModule.h"

@implementation WXDeviceModule

@synthesize weexInstance;

WX_EXPORT_METHOD_SYNC(@selector(getDeviceName))

-(NSString *)getDeviceName {
    NSUInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight == 812) {
        return @"iPhoneX";
    }
    return @"iPhone";
}

@end
