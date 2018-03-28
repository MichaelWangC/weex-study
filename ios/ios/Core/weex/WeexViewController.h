//
//  WeexViewController.h
//  ios
//
//  Created by Michael on 2017/9/28.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "BaseViewController.h"
#import <WeexSDK/WXModuleProtocol.h>

@interface WeexViewController : BaseViewController

@property (nonatomic, assign) BOOL navBarIsClear;
@property (nonatomic, assign) BOOL isHiddenNavBar;
@property (nonatomic, assign) BOOL closeWebMusic;
@property (nonatomic, copy) void (^onCreate)();
@property (nonatomic, copy) WXKeepAliveCallback navClickCallBack;

-(void)setUrl:(NSString *)url title:(NSString *)title;
-(void)clickBarButtonItem:(UIBarButtonItem *)item;

@end
