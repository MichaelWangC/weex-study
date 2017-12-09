//
//  MainTabbarController.m
//  ios
//
//  Created by Michael on 2017/12/9.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "MainTabbarController.h"

@interface MainTabbarController ()

@end

@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *firstController = [[UIViewController alloc] init];
    firstController.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_tabbar_mine_selected"];
    firstController.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_mine"];
    firstController.tabBarItem.title = @"我的";
    
    UIViewController *secondController = [[UIViewController alloc] init];
    secondController.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_tabbar_home_selected"];
    secondController.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_home"];
    secondController.tabBarItem.title = @"首页";
    
    [self addItemController:secondController toTabBarController:self];
    [self addItemController:firstController toTabBarController:self];
}

-(void)addItemController:(UIViewController*)itemController toTabBarController:(UITabBarController*)tab{
    UINavigationController* nav = [[BaseNavViewController alloc] initWithRootViewController:itemController];
    [tab addChildViewController:nav];
}

@end
