//
//  MainTabbarController.m
//  ios
//
//  Created by Michael on 2017/12/9.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "MainTabbarController.h"
#import "HybridViewController.h"
#import "WeexViewController.h"
#import <UMAnalytics/MobClick.h>
#import "UIColor+Hex.h"

@interface MainTabbarController ()<UITabBarControllerDelegate>

@end

@implementation MainTabbarController {
    BOOL _isSelectedHome;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.translucent=NO;
    self.delegate = self;
    
    // 添加tab
    NSString *baseUrl = [[ConfigInfo sharedInstance] urlWeexBase];
    BOOL isLoadLocalFile = YES;
    if (![baseUrl isEqualToString:@""]) isLoadLocalFile = NO;
    //mainPage
    WeexViewController *secondController = [[WeexViewController alloc] init];
    secondController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tabbar_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    secondController.tabBarItem.image = [[UIImage imageNamed:@"icon_tabbar_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    secondController.tabBarItem.title = @"首页";
    secondController.navBarIsClear = YES;
    secondController.statusBarIsLightContent = YES;
    NSString *mainUrl = [NSString stringWithFormat:@"%@/modules/home/home.js", [[ConfigInfo sharedInstance] urlWeexRoot]];
    if (isLoadLocalFile) {
        mainUrl = [[NSBundle mainBundle] pathForResource:@"modules/home/home" ofType:@"js" inDirectory:@"weex"];
        mainUrl = [NSString stringWithFormat:@"%@%@", [[ConfigInfo sharedInstance] urlWeexRoot], mainUrl];
    }
    [secondController setUrl:mainUrl title:@""];
    
    //看看
    WeexViewController *lookThemeController = [[WeexViewController alloc] init];
    lookThemeController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tabbar_look_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    lookThemeController.tabBarItem.image = [[UIImage imageNamed:@"icon_tabbar_look"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    lookThemeController.tabBarItem.title = @"看看";
    NSString *lookUrl = [NSString stringWithFormat:@"%@/modules/financial/financial.js", [[ConfigInfo sharedInstance] urlWeexRoot]];
    if (isLoadLocalFile) {
        lookUrl = [[NSBundle mainBundle] pathForResource:@"modules/financial/financial" ofType:@"js" inDirectory:@"weex"];
        lookUrl = [NSString stringWithFormat:@"%@%@", [[ConfigInfo sharedInstance] urlWeexRoot], lookUrl];
    }
    [lookThemeController setUrl:lookUrl title:@"看看"];
    
    //notifica
    WeexViewController *customerController = [[WeexViewController alloc] init];
    customerController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tabbar_notifica_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    customerController.tabBarItem.image = [[UIImage imageNamed:@"icon_tabbar_notifica"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    customerController.tabBarItem.title = @"客户";
    [customerController setIsHiddenNavBar:YES];
    NSString *customerUrl = [NSString stringWithFormat:@"%@/modules/customer/customer.js", [[ConfigInfo sharedInstance] urlWeexRoot]];
    if (isLoadLocalFile) {
        customerUrl = [[NSBundle mainBundle] pathForResource:@"modules/customer/customer" ofType:@"js" inDirectory:@"weex"];
        customerUrl = [NSString stringWithFormat:@"%@%@", [[ConfigInfo sharedInstance] urlWeexRoot], customerUrl];
    }
    [customerController setUrl:customerUrl title:@"客户"];

    //mine
    WeexViewController *firstController = [[WeexViewController alloc] init];
    firstController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    firstController.tabBarItem.image = [[UIImage imageNamed:@"icon_tabbar_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    firstController.tabBarItem.title = @"我的";
    firstController.navBarIsClear = YES;
    NSString *mineUrl = [NSString stringWithFormat:@"%@/modules/mine/mine.js", [[ConfigInfo sharedInstance] urlWeexRoot]];
    if (isLoadLocalFile) {
        mineUrl = [[NSBundle mainBundle] pathForResource:@"modules/mine/mine" ofType:@"js" inDirectory:@"weex"];
        mineUrl = [NSString stringWithFormat:@"%@%@", [[ConfigInfo sharedInstance] urlWeexRoot], mineUrl];
    }
    [firstController setUrl:mineUrl title:@""];
    _mineViewController = firstController;
    
    [self addItemController:secondController toTabBarController: self];
    [self addItemController:lookThemeController toTabBarController: self];
    [self addItemController:customerController toTabBarController: self];
    [self addItemController:firstController toTabBarController: self];
}

-(void)addItemController:(UIViewController*)itemController toTabBarController:(UITabBarController*)tab{
    if ([itemController isKindOfClass:[BaseViewController class]]) {
        BaseNavViewController * nav = [[BaseNavViewController alloc] initWithRootViewController:itemController];
        [tab addChildViewController:nav];
    }
}

@end
