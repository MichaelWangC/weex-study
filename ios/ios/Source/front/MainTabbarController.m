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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.translucent=NO;
    self.delegate = self;
    
    HybridViewController *firstController = [[HybridViewController alloc] init];
    firstController.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_tabbar_mine_selected"];
    firstController.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_mine"];
    firstController.tabBarItem.title = @"我的";
    [firstController loadPage:@"http://localhost:8080/#/mineInfo" withTitle:@"我的"];
    
    UIViewController *robotController = [[UIViewController alloc] init];
    robotController.tabBarItem.image = [[UIImage imageNamed:@"icon_tabbar_robot"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    HybridViewController *secondController = [[HybridViewController alloc] init];
    secondController.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_tabbar_home_selected"];
    secondController.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_home"];
    secondController.tabBarItem.title = @"首页";
    [secondController loadPage:@"http://localhost:8080/#/homePage" withTitle:@"首页"];
    
    [self addItemController:secondController toTabBarController:self];
    [self addItemController:robotController toTabBarController:self];
    [self addItemController:firstController toTabBarController:self];
}

-(void)addItemController:(UIViewController*)itemController toTabBarController:(UITabBarController*)tab{
    if ([itemController isKindOfClass:[BaseViewController class]]) {
        UINavigationController* nav = [[BaseNavViewController alloc] initWithRootViewController:itemController];
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

@end
