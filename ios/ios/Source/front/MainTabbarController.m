//
//  MainTabbarController.m
//  ios
//
//  Created by Michael on 2017/12/9.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "MainTabbarController.h"
#import "HybridViewController.h"

@interface MainTabbarController ()<UITabBarControllerDelegate>

@end

@implementation MainTabbarController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 不展示导航栏，tabbar 页面展示导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.translucent=NO;
    self.delegate = self;
    
    HybridViewController *secondController = [[HybridViewController alloc] init];
    secondController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tabbar_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    secondController.tabBarItem.image = [[UIImage imageNamed:@"icon_tabbar_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    secondController.tabBarItem.title = @"首页";
    secondController.isHiddenNavBar = YES;
    NSString *mainUrl = [NSString stringWithFormat:@"%@/#/mainPage", [[ConfigInfo sharedInstance] urlVueBase]];
    [secondController loadPage:mainUrl withTitle:@"首页"];
    
    UIViewController *robotController = [[UIViewController alloc] init];
    robotController.tabBarItem.image = [[UIImage imageNamed:@"icon_tabbar_robot"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    HybridViewController *firstController = [[HybridViewController alloc] init];
    firstController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    firstController.tabBarItem.image = [[UIImage imageNamed:@"icon_tabbar_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    firstController.tabBarItem.title = @"我的";
    NSString *mineUrl = [NSString stringWithFormat:@"%@/#/mineInfo", [[ConfigInfo sharedInstance] urlVueBase]];
    [firstController loadPage:mineUrl withTitle:@"我的"];
    
    [self addItemController:secondController toTabBarController:self];
    [self addItemController:robotController toTabBarController:self];
    [self addItemController:firstController toTabBarController:self];
}

-(void)addItemController:(UIViewController*)itemController toTabBarController:(UITabBarController*)tab{
    if ([itemController isKindOfClass:[BaseViewController class]]) {
        BaseNavViewController * nav = [[BaseNavViewController alloc] initWithRootViewController:itemController];
        [tab addChildViewController:nav];
    } else {
        //中间的 机器人按钮; 通过是否为BaseNavViewController 进行控制
        [tab addChildViewController:itemController];
    }
}

#pragma mark UITabBarControllerDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[BaseNavViewController class]]) {
        return YES;
    }else{
        //中间的 机器人按钮;
        NSLog(@"机器人按钮点击");
        return NO;
    }
}

#pragma mark StatusBar
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
