//
//  WeexViewController.m
//  ios
//
//  Created by Michael on 2017/9/28.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "WeexViewController.h"
#import <WeexSDK/WXSDKInstance.h>
#import "ConfigInfo.h"
#import "UIImage+Color.h"
#import "UIColor+Hex.h"
#import <UMAnalytics/MobClick.h>

@interface WeexViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *weexView;
@property (nonatomic, strong) WXSDKInstance *instance;

@end

@implementation WeexViewController {
    float view_height;
    float view_width;
    NSString *_url;
    NSString *_title;
    NSString *_pageName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // weex 页面加载
    [self refreshWeex];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    // 导航栏 初始化
    [self setNavBarIsClear:_navBarIsClear];
    [self setIsHiddenNavBar:_isHiddenNavBar];
    // 友盟
    [MobClick beginLogPageView:_pageName];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES; //YES：允许右滑返回  NO：禁止右滑返回
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    // 关闭webView 声音
    if (_closeWebMusic) {
        [self findWebView:self.view];
    }
    // 友盟
    [MobClick endLogPageView:_pageName];
}

-(void)findWebView:(UIView*)view
{
    for (UIView* subView in view.subviews)
    {
        if ([subView isKindOfClass:[UIWebView class]]) {
            [((UIWebView *)subView) reload];
        }
        [self findWebView:subView];
    }
}

-(void)viewDidLayoutSubviews{
    float height = self.view.frame.size.height;
    float width = self.view.frame.size.width;
    if (view_width != width || view_height != height) {
        view_height = height;
        view_width = width;
        _instance.frame = CGRectMake(0, 0, view_width, view_height);
    }
}

-(void)dealloc {
    [_instance destroyInstance];
}

#pragma mark setNavBarIsClear
-(void)setNavBarIsClear:(BOOL)navBarIsClear {
    _navBarIsClear = navBarIsClear;
    if (_navBarIsClear) {
        self.navigationController.navigationBar.translucent = YES;
        self.extendedLayoutIncludesOpaqueBars = YES;
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        UIColor *clearColor = [UIColor colorWithHex:0xffffff alpha:0.0];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:clearColor] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    } else {
        self.navigationController.navigationBar.translucent = NO;
    }
}

-(void)setIsHiddenNavBar:(BOOL)isHiddenNavBar {
    _isHiddenNavBar = isHiddenNavBar;
    if (isHiddenNavBar) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark event
-(void)setUrl:(NSString *)url title:(NSString *)title {
    _url = url;
    _title = title;
    
    NSRange jsRange = [url rangeOfString:@".js"];
    if (jsRange.location != NSNotFound) {
        _pageName = [url substringToIndex:jsRange.location+jsRange.length];
        NSArray *spritStrings = [_pageName componentsSeparatedByString:@"/"];
        NSString *lastString = [spritStrings lastObject];
        _pageName = lastString;
    } else {
        _pageName = @"";
    }
}

#pragma mark weex
-(void)refreshWeex {
    if (_title) {
        self.navigationItem.title = _title;
    }
    
    // _instance
    [_instance destroyInstance];
    _instance = [[WXSDKInstance alloc] init];
    _instance.viewController = self;
    
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, weakSelf.weexView);
    };
    _instance.onFailed = ^(NSError *error) {
        //process failure
    };
    
    BOOL navBarIsClear1 = self.navBarIsClear;
    __block WeexViewController *weakself = self;
    _instance.renderFinish = ^ (UIView *view) {
        //process renderFinish
        if (weakSelf.onCreate) {
            weakSelf.onCreate();
        }
        
        if (navBarIsClear1) {
            // 取消ios11 scroller view 自适应
            if (@available(iOS 11.0, *)) {
                [weakself setNoScroller:weakSelf.view];
            }
        }
    };
    
    if (_url == NULL) {
        _url = @"";
    }
    
    _url = [self URLEncodedStringWithUrl:_url];
    NSURL *weexUrl = [NSURL URLWithString:_url];
    // 防止本地加载过快 导致scroller长度未调整
    dispatch_async(dispatch_get_main_queue(), ^{
        [_instance renderWithURL:weexUrl options:@{@"bundleUrl":[weexUrl absoluteString]} data:nil];
    });
}

-(void) setNoScroller:(UIView *) view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            if (@available(iOS 11.0, *)) {
                ((UIScrollView *)subview).contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        }
        if (subview.subviews.count > 0) {
            [self setNoScroller:subview];
        } else {
            continue;
        }
    }
}

#pragma mark url转换
- (NSString *)URLEncodedStringWithUrl:(NSString *)url
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)url,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

#pragma mark navClick
-(void)clickBarButtonItem:(UIBarButtonItem *)item {
    _navClickCallBack(item.title, YES);
}

@end
