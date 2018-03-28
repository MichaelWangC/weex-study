//
//  WXLOTAnimationView.m
//  ios
//
//  Created by Michael on 2017/11/13.
//  Copyright © 2017年 weexstudy. All rights reserved.
//  展示动画 组件

#import "WXLOTAnimationView.h"
#import <WeexSDK/WXConvert.h>
#import <Lottie/Lottie.h>

@interface WXLOTAnimationView()

@property (nonatomic, strong) LOTAnimationView *laAnimation;
@property (nonatomic, copy) NSString *animationSrc;

@end

@implementation WXLOTAnimationView

WX_EXPORT_METHOD(@selector(play))
WX_EXPORT_METHOD(@selector(stop))

-(instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance {
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];
    if (self) {
        [self setLOTAnimationAttributes:attributes];
    }
    return self;
}

-(UIView *)loadView {
    return _laAnimation;
}

-(void)viewDidLoad {
    _laAnimation.contentMode = UIViewContentModeScaleAspectFit;
    _laAnimation.clipsToBounds = YES;
}

-(void)updateAttributes:(NSDictionary *)attributes {
    [self setLOTAnimationAttributes:attributes];
}

#pragma mark 属性设置
-(void)setLOTAnimationAttributes: (NSDictionary *)attributes {
    // 获取动画json文件名
    if (attributes[@"src"]) {
        _animationSrc = [WXConvert NSString:attributes[@"src"]];
    } else {
        _animationSrc = @"";
    }
    
    // 初始化组件
    _laAnimation = [LOTAnimationView animationNamed:_animationSrc];
    // 动画是否循环播放
    if (attributes[@"loop"]) {
        BOOL loop = [WXConvert BOOL:attributes[@"loop"]];
        _laAnimation.loopAnimation = loop;
    }
}

#pragma mark 方法暴露
-(void)play {
    [_laAnimation play];
}

-(void)stop {
    [_laAnimation stop];
}

@end
