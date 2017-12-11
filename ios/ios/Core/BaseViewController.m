//
//  BaseViewController.m
//  ios
//
//  Created by Michael on 2017/9/28.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 防止列表下移
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    5291ff
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0x52/255.0 green:0x91/255.0 blue:0xff/255.0 alpha:1]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = false;
}

#pragma mark
#pragma mark dismiss
- (void)dismiss{
    [super dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissViewControllerAnimated:(BOOL)flag{
    if(self.navigationController.viewControllers.count>1){
        [self.navigationController popViewControllerAnimated:flag];
    }else{
        [self dismiss];
    }
}

#pragma mark status bar
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
