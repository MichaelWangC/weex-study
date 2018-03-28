//
//  CoreWebPage.m
//  ios
//
//  Created by Michael on 2017/12/10.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "HybirdWebPage.h"
#import "HSJSONKit.h"
#import "HybridViewController.h"
#import "HttpUtil.h"

#import "UserInfoUtil.h"
#import "MainTabbarController.h"
#import "CoreAppDelegate.h"

@interface HybridUIWebView : UIWebView

@end

@implementation HybridUIWebView

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    return true;
}

@end

#pragma mark
#pragma mark CoreWebPage
@implementation HybirdWebPage

@synthesize webView = _uiWebView;

-(instancetype)init{
    self = [super init];
    if (self) {
        _uiWebView = [HybridUIWebView new];
        _uiWebView.scalesPageToFit = YES;
        _uiWebView.delegate = self;
        [_uiWebView setBackgroundColor:COLOR_COMMON_BACKGROUND];
        [self addSubview:_uiWebView];
        [_uiWebView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        if (@available(iOS 11.0, *)) {
            _uiWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        // 设置这个属性，如果在加载的网页中遇到电话号码，直接单击就可以拨打，非常方便
        _uiWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    }
    return self;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestURL = request.URL.absoluteString;
    if([requestURL hasPrefix:@"hsmbp://"]){
        /******************页面关闭*********************/
        if([requestURL hasPrefix:@"hsmbp://close"]){
            if([_viewController isKindOfClass:[BaseViewController class]]){
                [(BaseViewController*)self.viewController dismissViewControllerAnimated:YES];
            }else{
                [self.viewController dismissViewControllerAnimated:YES completion:nil];
            }
        }
        /********************跳转导航到本地原生界面***********************/
        else if ([requestURL hasPrefix:@"hsmbp://openNaviPage"]) {
            // 先打开主界面 后续考虑 使用原生router进行页面跳转控制
            MainTabbarController *tabbar = [[MainTabbarController alloc] init];
            ((CoreAppDelegate *)[UIApplication sharedApplication].delegate).mainTabbar = tabbar;
            [self.viewController.rt_navigationController pushViewController:tabbar animated:YES complete:^(BOOL finished) {
                [self.viewController.rt_navigationController removeViewController:self.viewController];
            }];
        }
        /******************页面跳转*********************/
        else if([requestURL hasPrefix:@"hsmbp://open"]){
            NSString* dataStr = [self valueForKey:@"data" inURL:request.URL.absoluteString];
//            dataStr = [dataStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* data = [dataStr objectFromJSONString];
            NSString* url = [data objectForKey:@"url"];
            NSString* navBarIsClear = [data objectForKey:@"navBarIsClear"];
            if (!url) {
                NSLog(@"WARN:invalid url for new page!");
                return NO;
            }
            HybridViewController* vc = [HybridViewController new];
            if ([navBarIsClear isEqualToString:@"true"]) {
                vc.navBarIsClear = YES;
            } else {
                vc.navBarIsClear = NO;
            }
            
//            NSString* requestcode = [data objectForKey:@"requestcode"];
//            if(requestcode){
//                __weak UIWebView* webViewRef = webView;
//                [vc setResultCallback:^(int requestcode, int resultcode, NSDictionary *data) {
//                    [webViewRef stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hybrid.onResult(%d,%d,%@)",requestcode,resultcode,[data JSONString]]];
//                } forRequest:[requestcode intValue]];
//            }
            
            [vc setUrl:url title:[data objectForKey:@"title"]];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
        /*******************导航右侧按钮**********************/
        else if([request.URL.absoluteString hasPrefix:@"hsmbp://nav_right_btn"]){
            NSString* dataStr = [self valueForKey:@"titles" inURL:request.URL.absoluteString];
            dataStr = [dataStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray* titles = [dataStr objectFromJSONString];
            NSMutableArray* buttonItems = [NSMutableArray array];
            for (NSString* title in titles) {
                [buttonItems addObject:[[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(hyRightBarButtonItem:)]];
            }
            _viewController.navigationItem.rightBarButtonItems = buttonItems;
        }
        /********************注销***********************/
        else if([request.URL.absoluteString hasPrefix:@"hsmbp://loginOut"]) {
            [((CoreAppDelegate *)[UIApplication sharedApplication].delegate) doLogout];
        }
        /********************保存用户数据***********************/
        else if ([requestURL hasPrefix:@"hsmbp://commitUserData"]) {
            NSString* key = [self valueForKey:@"key" inURL:request.URL.absoluteString];
            NSString* value = [self valueForKey:@"value" inURL:request.URL.absoluteString];
            [[UserInfoUtil sharedInstance] saveValueByKey:key value:value];
        }
        /********************获取用户数据***********************/
        else if ([requestURL hasPrefix:@"hsmbp://getUserData"]) {
            NSString* key = [self valueForKey:@"key" inURL:request.URL.absoluteString];
            NSString* callbackId = [self valueForKey:@"callback" inURL:request.URL.absoluteString];
            
            if (callbackId) {
                id jsonData = [[UserInfoUtil sharedInstance] getValueByKey:key];
                NSString* data;
                if ([jsonData isKindOfClass:[NSString class]]) {
                    data = jsonData;
                } else {
                    data = @"";
                }
                [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hybrid.handle(%@,%@)",callbackId, data]];
            };
        }
        /***************跳转到用户信息页面************/
        else if ([requestURL hasPrefix:@"hsmbp://showMine"]) {
            [((HybridViewController *)_viewController).navigationController popToRootViewControllerAnimated:NO];
            UITabBarController *tab = ((CoreAppDelegate *)[UIApplication sharedApplication].delegate).mainTabbar;
            
            NSUInteger count = tab.viewControllers.count;
            tab.selectedIndex = count - 1;
            ((HybridViewController *)_viewController).hidesBottomBarWhenPushed = NO;
            ((HybridViewController *)_viewController).tabBarController.tabBar.hidden = NO;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:HybridViewControllerNotification object:nil];
        }
        /********************nav_bar_appear***********************/
        else if ([requestURL hasPrefix:@"hsmbp://nav_bar_appear"]) {
            NSDictionary* params = [[self valueForKey:@"params" inURL:request.URL.absoluteString] objectFromJSONString];
            NSString *isHiddenNavBar = [params objectForKey:@"isHiddenNavBar"];
            NSString *isNavBarIsClear = [params objectForKey:@"navBarIsClear"];
            if ([_viewController isKindOfClass:[HybridViewController class]]) {
                // 隐藏导航栏
                if ([isHiddenNavBar isEqualToString:@"true"]) {
                    ((HybridViewController *)_viewController).isHiddenNavBar = YES;
                } else {
                    ((HybridViewController *)_viewController).isHiddenNavBar = NO;
                }
                // 导航栏透明
                if ([isNavBarIsClear isEqualToString:@"true"]) {
                    ((HybridViewController *)_viewController).navBarIsClear = YES;
                } else {
                    ((HybridViewController *)_viewController).navBarIsClear = NO;
                }
            }
        }
        else if ([requestURL hasPrefix:@"hsmbp://postNotification"]) {
            NSString* postName = [self valueForKey:@"name" inURL:request.URL.absoluteString];
            [[NSNotificationCenter defaultCenter] postNotificationName:postName object:nil];
        }
        /********************Request***********************/
        else if([requestURL hasPrefix:@"hsmbp://request"]){
            NSString* requestStr = [self valueForKey:@"request" inURL:request.URL.absoluteString];
            requestStr = [requestStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* requestParams = [requestStr objectFromJSONString];
            NSString* callbackId = [self valueForKey:@"callback" inURL:request.URL.absoluteString];
            
            NSString *url = (NSString*)[requestParams objectForKey:@"url"];
            // 获取api url base 地址
            NSString *apiBaseUrl = [[ConfigInfo sharedInstance] urlApiBase];
            url = [NSString stringWithFormat:@"%@%@", apiBaseUrl, url];
            
//            if (request.url.indexOf('http') !=0) {
//                if(request.url.indexOf('/') == 0){
//                    var port = window.location.port;
//                    request.url = window.location.protocol+'//'+window.location.hostname+((''===port)?'':':')+port+request.url;
//                }else{
//                    var baseUrl = window.location.href.replace(/\?.*/,'');
//                    var index = baseUrl.lastIndexOf('/');
//                    if(index!=-1){
//                        baseUrl = baseUrl.substring(0, index+1);
//                    }
//                    request.url = baseUrl+request.url;
//                }
//            };
            
            __weak UIWebView* webViewRef = webView;
            if ([@"post" isEqualToString:[(NSString*)[requestParams objectForKey:@"type"] lowercaseString]]) {
                [HttpUtil postAsynchronousWithURL:url data:[requestParams objectForKey:@"data"] successHandler:^(id data) {
                    if (callbackId) {
                        id jsonData = data;
                        NSString* data = [jsonData JSONString];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [webViewRef stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hybrid.handle(%@,%@)", callbackId, data]];
                        });
                    };
                } errorHandler:^(NSError *error) {
                    NSString *errorCode = @"-1";
                    if (error.code == 100) {
                        // 未登录
                        errorCode = @"100";
                    }
                    NSDictionary *data = @{
                                           @"code": errorCode,
                                           @"errMsg": [error localizedDescription]
                                           };
                    NSString *dataS = [data JSONString];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [webViewRef stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hybrid.handle(%@,%@)",callbackId, dataS]];
                    });
                    NSLog(@"web request error : %@", error);
                }];
            } else {
                NSDictionary* data = [requestParams objectForKey:@"data"];
                if (data){
                    if([url rangeOfString:@"?"].length==0){
                        url = [url stringByAppendingString:@"?1=1"];
                    }
                    for (NSString* key in [data allKeys]) {
                        url = [url stringByAppendingFormat:@"&%@=%@",key, [data objectForKey:key]];
                    }
                }
                [HttpUtil getAsynchronous:url successHandler:^(id data) {
                    if (callbackId) {
                        id jsonData = [data objectFromJSONData];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [webViewRef stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hybrid.handle(%@,%@)",callbackId,[jsonData JSONString]]];
                        });
                    };
                } errorHandler:^(NSError *error) {
                    NSDictionary *data = @{
                                           @"code": @"-1",
                                           @"errMsg": [error localizedDescription]
                                           };
                    NSString *dataS = [data JSONString];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [webViewRef stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hybrid.handle(%@,%@)",callbackId, dataS]];
                    });
                    NSLog(@"web request error : %@", error);
                }];
            }
        }
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    if ([self.viewController isKindOfClass:[BaseViewController class]]) {
        [((BaseViewController *)self.viewController) showLoadingStatus];
    }
    NSError* error;
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"hybrid" withExtension:@"js"] encoding:NSUTF8StringEncoding error:&error]];
    if(error){
        NSLog(@"WebPage error:%@",error);
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([self.viewController isKindOfClass:[BaseViewController class]]) {
        [((BaseViewController *)self.viewController) hideLoadingStatus];
    }
    
    NSLog(@"UserAgent = %@", [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]);
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    NSError* error;
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"hybridUI" withExtension:@"js"] encoding:NSUTF8StringEncoding error:&error]];
    if(error){
        NSLog(@"WebPage error:%@",error);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"WebPage::%@", [error description]);
    if ([self.viewController isKindOfClass:[BaseViewController class]]) {
        [((BaseViewController *)self.viewController) hideLoadingStatus];
    }
}

#pragma mark 获取参数
- (NSString*)valueForKey:(NSString*)key inURL:(NSString*)url{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(?:^|&|\\?)%@=([^&]*?)(?:&|$)",key];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    if (matches&&matches.count>0) {
        NSString* value = [url substringWithRange:[(NSTextCheckingResult*)[matches firstObject] rangeAtIndex:1]];
        return [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return nil;
}
    
#pragma mark
#pragma mark 按钮
- (void)hyRightBarButtonItem:(UIBarButtonItem*)obj{
    [_uiWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hybrid.onNavRightButtonClicked('%@')",obj.title]];
}

#pragma mark
-(void)appLogin {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_uiWebView stringByEvaluatingJavaScriptFromString:@"hybrid.onAPPLogin()"];
    });
}
    
-(void)appLoginOut {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_uiWebView stringByEvaluatingJavaScriptFromString:@"hybrid.onAPPLoginOut()"];
    });
}

@end
