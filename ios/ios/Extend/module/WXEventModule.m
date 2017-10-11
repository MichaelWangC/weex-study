//
//  WXEventModule.m
//  ios
//
//  Created by Michael on 2017/10/11.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "WXEventModule.h"
#import "WeexViewController.h"

@implementation WXEventModule

@synthesize weexInstance;
WX_EXPORT_METHOD(@selector(openURL:))
WX_EXPORT_METHOD(@selector(popPage))

- (void)openURL:(NSString *)url
{
    NSString *newURL = url;
    if ([url hasPrefix:@"//"]) {
        newURL = [NSString stringWithFormat:@"http:%@", url];
    } else if (![url hasPrefix:@"http"]) {
        // relative path
        newURL = [NSURL URLWithString:url relativeToURL:weexInstance.scriptURL].absoluteString;
    }
    
    UIViewController *controller = [[WeexViewController alloc] init];
    ((WeexViewController *)controller).url = [NSURL URLWithString:newURL];
    
    [[weexInstance.viewController navigationController] pushViewController:controller animated:YES];
}

-(void) popPage {
    [[weexInstance.viewController navigationController] popViewControllerAnimated:YES];
}

@end
