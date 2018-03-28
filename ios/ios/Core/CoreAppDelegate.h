//
//  CoreAppDelegate.h
//  ios
//
//  Created by Michael on 2017/12/25.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "AppDelegate.h"

@interface CoreAppDelegate : AppDelegate

@property (strong, nonatomic) UITabBarController *mainTabbar;
    
#pragma mark loginOut
-(void) doLogout;
-(BOOL)isAlert;

@end
