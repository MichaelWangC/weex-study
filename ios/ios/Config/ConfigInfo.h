//
//  ConfigInfo.h
//  ios
//
//  Created by Michael on 2017/9/30.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,ReleaseType)
{
    ReleaseTypeDebug,//现场测试
    ReleaseTypePublish,//上生产
    ReleaseTypeDev//开发
};

@interface ConfigInfo : NSObject

@property (nonatomic,readonly) ReleaseType releaseType;

+(instancetype) sharedInstance;

-(NSString *) urlBase;
-(NSString *) urlHome;
-(NSString *) urlRoot;

@end
