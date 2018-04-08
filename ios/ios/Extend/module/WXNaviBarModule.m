//
//  WXNaviBarModule.m
//  ios
//
//  Created by Michael on 2018/1/9.
//  Copyright © 2018年 weexstudy. All rights reserved.
//

#import "WXNaviBarModule.h"
#import "WeexViewController.h"
#import "UIColor+Hex.h"
#import "UIImage+Color.h"

@implementation WXNaviBarModule 

@synthesize weexInstance;
WX_EXPORT_METHOD(@selector(setNavRightButtonsWithTitles:callback:))
WX_EXPORT_METHOD(@selector(setNavRightButtonsWithImages:callback:))
WX_EXPORT_METHOD(@selector(setNavBarColor:alpha:callback:))

#pragma mark 控制导航栏 右侧按钮
-(void)setNavRightButtonsWithTitles:(NSArray *)titles callback:(WXKeepAliveCallback)callback {
    NSMutableArray* buttonItems = [NSMutableArray array];
    for (NSString* title in titles) {
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:weexInstance.viewController action:@selector(clickBarButtonItem:)];
        [buttonItems addObject:barItem];
    }
    if (callback) {
        ((WeexViewController *)weexInstance.viewController).navClickCallBack = callback;
    }
    weexInstance.viewController.navigationItem.rightBarButtonItems = buttonItems;
}

#pragma mark 控制导航栏 右侧图标
-(void)setNavRightButtonsWithImages:(NSArray *)images callback:(WXKeepAliveCallback)callback {
    NSMutableArray* imageItems = [NSMutableArray array];
    // 添加按钮
    int i = 0;
    for (NSString* image in images) {
        UIImage *barimage = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setImage:barimage forState:UIControlStateNormal];
//        [button addTarget:weexInstance.viewController action:@selector(clickBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
//        [button setFrame:CGRectMake(0, 0, 30, 30)];
        UIBarButtonItem *barImgItem = [[UIBarButtonItem alloc] initWithImage:barimage style:UIBarButtonItemStylePlain target:weexInstance.viewController action:@selector(clickBarButtonItem:)];
        barImgItem.title = image;
        [barImgItem setImageInsets:UIEdgeInsetsMake(0, 15*i, 0, -15*i)];
        [imageItems addObject:barImgItem];
        i++;
    }
    if (callback) {
        ((WeexViewController *)weexInstance.viewController).navClickCallBack = callback;
    }
    weexInstance.viewController.navigationItem.rightBarButtonItems = imageItems;
}

#pragma mark 设置导航栏颜色
-(void)setNavBarColor:(NSString *)color alpha:(float)opacity callback:(WXKeepAliveCallback)callback {
    UIColor *colorHex = [UIColor colorWithHexString:color alpha:opacity];
    UIImage *colorImage = [[UIImage imageWithColor:colorHex] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [weexInstance.viewController.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    [weexInstance.viewController.navigationController.navigationBar setShadowImage:colorImage];
    [weexInstance.viewController.navigationController.navigationBar setBarTintColor:colorHex];
    
    if (opacity >= 1) {
        weexInstance.viewController.navigationController.navigationBar.translucent = NO;
    } else {
        weexInstance.viewController.navigationController.navigationBar.translucent = YES;
    }
}

-(void)setNavBarTitle:(NSString *)title {
    [weexInstance.viewController.navigationItem setTitle:title];
}

-(void)setStatusBarStyle:(BOOL)isLightContent {
    BaseViewController *baseController = (BaseViewController *)weexInstance.viewController;
    if (isLightContent) {
        baseController.statusBarIsLightContent = YES;
    } else {
        baseController.statusBarIsLightContent = NO;
    }
    
    [baseController setNeedsStatusBarAppearanceUpdate];
}

@end
