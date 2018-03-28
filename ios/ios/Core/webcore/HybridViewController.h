//
//  HybridViewController.h
//  ios
//
//  Created by Michael on 2017/12/10.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "BaseViewController.h"

static NSString *HybridViewControllerNotification = @"HybridViewControllerNotification";

@interface HybridViewController : BaseViewController

@property (nonatomic, assign) BOOL isHiddenNavBar;
@property (nonatomic, assign) BOOL couldNoticeRefresh;
@property (nonatomic, assign) BOOL navBarIsClear;
    
-(void)refreshWeb;
-(void)setUrl:(NSString *)url title:(NSString *)title;
-(void)loadPage:(NSString*)url withTitle:(NSString*)title;

@end
