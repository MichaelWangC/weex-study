//
//  UMConfigManager.m
//  ios
//
//  Created by Michael on 2018/3/15.
//  Copyright © 2018年 weexstudy. All rights reserved.
//

#import "UMConfigManager.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>

@implementation UMConfigManager

+(void)setup {
    [UMConfigure initWithAppkey:[UMConfigManager getAppKey] channel:@"iOS"];
    [MobClick setScenarioType:E_UM_NORMAL];
}

+(NSString *)getAppKey {
    if ([ConfigInfo sharedInstance].releaseType == ReleaseTypePublish) {
        return @"";
    } else {
        return @"";
    }
}

@end
