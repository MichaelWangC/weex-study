//
//  CoreWebPage.h
//  ios
//
//  Created by Michael on 2017/12/10.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HybirdWebPage : UIView<UIWebViewDelegate>

@property (nonatomic,weak) UIViewController* viewController;
@property (readonly) UIWebView* webView;

-(void)appLogin;
-(void)appLoginOut;

@end
