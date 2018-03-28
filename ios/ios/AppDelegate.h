//
//  AppDelegate.h
//  ios
//
//  Created by Michael on 2017/9/28.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UIViewController *loginController;
@property (nonatomic, strong) UIViewController *mainController;
@property (nonatomic, strong) UIViewController *gestureController;

-(UIViewController *) gestureController:(NSString *)type;

@end

