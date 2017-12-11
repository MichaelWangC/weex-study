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

@implementation HybridViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 导航栏初始化
    [self setIsHiddenNavBar:_isHiddenNavBar];
}

-(void)setIsHiddenNavBar:(BOOL)isHiddenNavBar {
    _isHiddenNavBar = isHiddenNavBar;
    if (isHiddenNavBar) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

-(void)loadPage:(NSString*)url withTitle:(NSString *)title{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = title;
//    url = @"http://www.qq.com";
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    [configuration setHTTPAdditionalHeaders:@{@"User-Agent" : [[NSUserDefaults standardUserDefaults] stringForKey:@"UserAgent"]}];
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    self.dataTask = [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse* response =  (NSHTTPURLResponse*)task.response;
        NSString* pageType = [response.allHeaderFields objectForKey:@"X-Hs-Type"];
        if([@"react" isEqualToString:pageType]){
            //ReactPage
        }else{
            //WebPage
            HybirdWebPage* webPage = [HybirdWebPage new];
            webPage.viewController = self;
            [self.view addSubview:webPage];
            [webPage autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
            NSString* mime = response.MIMEType;
            if ([@"text/plain" isEqualToString:response.MIMEType]) {
                mime = @"text/html";
            }
            [webPage.webView loadData:responseObject MIMEType:mime textEncodingName:response.textEncodingName baseURL:[response URL]];
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

-(void)dealloc{
    [self.dataTask cancel];
    self.dataTask = nil;
}

@end
