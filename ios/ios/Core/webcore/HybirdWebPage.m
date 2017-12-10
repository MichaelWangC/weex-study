//
//  CoreWebPage.m
//  ios
//
//  Created by Michael on 2017/12/10.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "HybirdWebPage.h"

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
        [self addSubview:_uiWebView];
        [_uiWebView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        // 设置这个属性，如果在加载的网页中遇到电话号码，直接单击就可以拨打，非常方便
        _uiWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    }
    return self;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if([request.URL.absoluteString hasPrefix:@"hsmbp://"]){
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
//    if ([self.viewController isKindOfClass:[BaseViewController class]]) {
//        [((BaseViewController *)self.viewController) showLoadingStatus];
//    }
    NSError* error;
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"hybrid" withExtension:@"js"] encoding:NSUTF8StringEncoding error:&error]];
    if(error){
        NSLog(@"WebPage error:%@",error);
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    if ([self.viewController isKindOfClass:[BaseViewController class]]) {
//        [((BaseViewController *)self.viewController) hideLoadingStatus];
//    }
    
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
//    if ([self.viewController isKindOfClass:[BaseViewController class]]) {
//        [((BaseViewController *)self.viewController) hideLoadingStatus];
//    }
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

@end
