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

@interface WeexViewController ()

@property (nonatomic, strong) UIView *weexView;
@property (nonatomic, strong) WXSDKInstance *instance;

@end

@implementation WeexViewController {
    float view_height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 导航栏透明
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.backgroundColor = nil;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    // 状态栏 设置为白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // 返回按钮隐藏 weex处理导航栏
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    
    // 防止列表下移
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self refreshWeex];
}

-(void)dealloc {
    [_instance destroyInstance];
}

-(void)refreshWeex {
    [_instance destroyInstance];
    _instance = [[WXSDKInstance alloc] init];
    _instance.viewController = self;
    
    view_height = self.view.frame.size.height;
    _instance.frame = CGRectMake(0, 0, self.view.frame.size.width, view_height);
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
    _instance.renderFinish = ^ (UIView *view) {
        //process renderFinish
        if (weakSelf.onCreate) {
            weakSelf.onCreate();
        }
    };
    
    if (self.url == NULL) {
        NSString *url = [[ConfigInfo sharedInstance] urlHome];
        self.url = [NSURL URLWithString:url];
    }
    
    NSString *randomURL = [NSString stringWithFormat:@"%@%@random=%d",self.url.absoluteString,self.url.query?@"&":@"?",arc4random()];
    [_instance renderWithURL:[NSURL URLWithString:randomURL] options:@{@"bundleUrl":[self.url absoluteString]} data:nil];
}

@end
