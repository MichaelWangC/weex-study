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
WX_EXPORT_METHOD(@selector(getViewHeight:))
WX_EXPORT_METHOD_SYNC(@selector(getDeviceHeight))

-(NSString *)getDeviceName {
    NSUInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight == 812) {
        return @"iPhoneX";
    }
    return @"iPhone";
}

-(void)getViewHeight:(WXCallback)callback {
    dispatch_async(dispatch_get_main_queue(), ^{
        double height = weexInstance.viewController.view.frame.size.height;
        NSNumber *heightNum = [NSNumber numberWithDouble:height];
        callback(heightNum);
    });
}

-(double)getDeviceHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

@end
