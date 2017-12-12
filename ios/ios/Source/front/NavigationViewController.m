//
//  NavigationViewController.m
//  ios
//
//  Created by Michael on 2017/12/12.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "NavigationViewController.h"
#import "HybirdWebPage.h"
#import "AFNetworking.h"

@interface NavigationViewController ()

@property (nonatomic,weak) NSURLSessionDataTask* dataTask;

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *mineUrl = [NSString stringWithFormat:@"%@/#/navigationPage", [[ConfigInfo sharedInstance] urlVueBase]];
    [self loadPage:mineUrl withTitle:@""];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
            webPage.webView.scrollView.scrollEnabled = NO;
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
}

-(void)dealloc{
    [self.dataTask cancel];
    self.dataTask = nil;
}

@end
