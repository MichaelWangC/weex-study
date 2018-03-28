//
//  WXWebView.m
//  ios
//
//  Created by Michael on 2018/3/24.
//  Copyright © 2018年 weexstudy. All rights reserved.
//

#import "WXMyWebView.h"
#import <WeexSDK/WXConvert.h>

@interface WXMyWebView() <UIWebViewDelegate>

@property (nonatomic, assign) BOOL startLoadEvent;

@property (nonatomic, assign) BOOL finishLoadEvent;

@property (nonatomic, assign) BOOL failLoadEvent;

@end

@implementation WXMyWebView {
    UIWebView *_webView;
}

-(instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance {
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];
    if (self) {
        [self setWebViewAttributes:attributes];
    }
    return self;
}

-(UIView *)loadView {
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    return _webView;
}

-(void)updateAttributes:(NSDictionary *)attributes {
    [self setWebViewAttributes:attributes];
}

-(void)setWebViewAttributes: (NSDictionary *)attributes {
    NSString *url = attributes[@"src"];
    if (url && ![url isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:[WXConvert NSString:attributes[@"src"]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
}

-(void)addEvent:(NSString *)eventName {
    if ([eventName isEqualToString:@"pagestart"]) {
        _startLoadEvent = YES;
    }
    else if ([eventName isEqualToString:@"pagefinish"]) {
        _finishLoadEvent = YES;
    }
    else if ([eventName isEqualToString:@"error"]) {
        _failLoadEvent = YES;
    }
}

#pragma mark UIWebViewDelegate
- (NSMutableDictionary<NSString *, id> *)baseInfo
{
    NSMutableDictionary<NSString *, id> *info = [NSMutableDictionary new];
    [info setObject:_webView.request.URL.absoluteString ?: @"" forKey:@"url"];
    [info setObject:[_webView stringByEvaluatingJavaScriptFromString:@"document.title"] ?: @"" forKey:@"title"];
    [info setObject:@(_webView.canGoBack) forKey:@"canGoBack"];
    [info setObject:@(_webView.canGoForward) forKey:@"canGoForward"];
    return info;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_finishLoadEvent) {
        NSDictionary *data = [self baseInfo];
        [self fireEvent:@"pagefinish" params:data domChanges:@{@"attrs": @{@"src":_webView.request.URL.absoluteString}}];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (_failLoadEvent) {
        NSMutableDictionary *data = [self baseInfo];
        [data setObject:[error localizedDescription] forKey:@"errorMsg"];
        [data setObject:[NSString stringWithFormat:@"%ld", (long)error.code] forKey:@"errorCode"];
        if(error.userInfo && ![error.userInfo[NSURLErrorFailingURLStringErrorKey] hasPrefix:@"http"]){
            return;
        }
        [self fireEvent:@"error" params:data];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (_startLoadEvent) {
        NSMutableDictionary<NSString *, id> *data = [NSMutableDictionary new];
        [data setObject:request.URL.absoluteString ?:@"" forKey:@"url"];
        [self fireEvent:@"pagestart" params:data];
    }
    return YES;
}

@end
