//
//  BaseViewController.h
//  ios
//
//  Created by Michael on 2017/9/28.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BackButtonType)
{
    // 默认灰色
    BackButtonTypeGray,
    BackButtonTypeWhite
};

@interface BaseViewController : UIViewController

@property (nonatomic, assign) UIEdgeInsets loadingStatusEdgeInset;
@property (nonatomic, assign) BackButtonType backButtonType;
@property (nonatomic, assign) BOOL statusBarIsLightContent;

-(void)dismissViewControllerAnimated:(BOOL)flag;

-(void)showLoadingStatus;
-(void)hideLoadingStatus;

@end
