//
//  HybridViewController.m
//  ios
//
//  Created by Michael on 2017/12/10.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "HybridViewController.h"
#import "HybirdWebPage.h"
#import "AFNetworking.h"

@interface HybridViewController ()

@property (nonatomic,weak) NSURLSessionDataTask* dataTask;

@end

@implementation HybridViewController {
    NSString *_url;
    NSString *_title;
    
    HybirdWebPage *_webPage;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    _webPage = [HybirdWebPage new];
    _webPage.viewController = self;
    [self.view addSubview:_webPage];
    [_webPage autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    if (_couldNoticeRefresh) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWeb) name:HybridViewControllerNotification object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appLogin) name:APP_LOGIN_SUCCESS_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appLoginOut) name:APP_LOGIN_OUT_NOTIFICATION object:nil];
    
    if (_url != nil && ![@"" isEqualToString:_url]) {
        [self loadPage:_url withTitle:_title];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 导航栏初始化
    [self setIsHiddenNavBar:_isHiddenNavBar];
    [self setNavBarIsClear:_navBarIsClear];
}

-(void)setUrl:(NSString *)url title:(NSString *)title {
    _url = url;
    _title = title;
}

-(void)setNavBarIsClear:(BOOL)navBarIsClear {
    _navBarIsClear = navBarIsClear;
    if (_navBarIsClear) {
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    } else {
        self.navigationController.navigationBar.translucent = NO;
    }
}
    
-(void)setIsHiddenNavBar:(BOOL)isHiddenNavBar {
    _isHiddenNavBar = isHiddenNavBar;
    if (isHiddenNavBar) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

-(void)refreshWeb {
    [self loadPage:_url withTitle:_title];
}

-(void)loadPage:(NSString*)url withTitle:(NSString *)title{
    [self setUrl:_url title:_title];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = title;
    
    NSString *baseUrl = [[ConfigInfo sharedInstance] urlVueBase];
    if ([@"" isEqualToString:baseUrl] && ![_url hasPrefix:@"http"]) {
        // 读取本地
        NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"vue"];
        NSString *fileUrlStr;
        // _url 已传有file://的路径
        if ([_url hasPrefix:@"file://"]) {
            // 临时办法 本地绝对路径、相对路径问题处理
            if ([_url rangeOfString:@"ios.app"].location == NSNotFound) {
                fileUrlStr = [_url substringFromIndex:7];
                fileUrlStr = [NSString stringWithFormat:@"%@%@", path, fileUrlStr];
            } else {
                fileUrlStr = _url;
            }
        } else {
            fileUrlStr = [NSString stringWithFormat:@"%@%@", path, _url];
        }
        
        fileUrlStr = [self URLEncodedStringWithUrl:fileUrlStr];
        NSURL *fileUrl = [NSURL URLWithString:fileUrlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
        
        [_webPage removeFromSuperview];
        _webPage = [HybirdWebPage new];
        _webPage.viewController = self;
        [self.view addSubview:_webPage];
        [_webPage autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        [_webPage.webView loadRequest:request];
        return;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    url = [self URLEncodedStringWithUrl:url];
    self.dataTask = [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse* response =  (NSHTTPURLResponse*)task.response;
        NSString* pageType = [response.allHeaderFields objectForKey:@"X-Hs-Type"];
        if([@"react" isEqualToString:pageType]){
            //ReactPage
        }else{
            //WebPage
            NSString* mime = response.MIMEType;
            if ([@"text/plain" isEqualToString:response.MIMEType]) {
                mime = @"text/html";
            }
            [_webPage removeFromSuperview];
            _webPage = [HybirdWebPage new];
            _webPage.viewController = self;
            [self.view addSubview:_webPage];
            [_webPage autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
            
            [_webPage.webView loadData:responseObject MIMEType:mime textEncodingName:response.textEncodingName baseURL:[response URL]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
//    NSURL *URL = [NSURL URLWithString:@"http://httpbin.org/get"];

//    Accept = "*/*";
//    "Accept-Encoding" = "gzip, deflate";
//    "Accept-Language" = "en-us";
//    Host = "httpbin.org";
//    "User-Agent" = "Mozilla/5.0 (iPhone; CPU iPhone OS 10_11_1 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12B411 MBP/1.0";
    
}

- (NSString *)URLEncodedStringWithUrl:(NSString *)url
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)url,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

-(void)dealloc{
    [self.dataTask cancel];
    self.dataTask = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark event
-(void)appLogin{
    [_webPage appLogin];
}
    
-(void)appLoginOut{
    [_webPage appLoginOut];
}
    
@end
