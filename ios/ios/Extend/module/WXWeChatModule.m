//
//  WXWeChatModule.m
//  ios
//
//  Created by Michael on 2018/2/7.
//  Copyright © 2018年 weexstudy. All rights reserved.
//

#import "WXWeChatModule.h"
#import "WXApi.h"

@implementation WXWeChatModule
WX_EXPORT_METHOD(@selector(sendLinkContent:description:url:callback:))

-(void)sendLinkContent:(NSString *)title description:(NSString *)description url:(NSString *)url callback:(WXModuleCallback)callback {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:[UIImage imageNamed:@"AppIcon"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

@end
