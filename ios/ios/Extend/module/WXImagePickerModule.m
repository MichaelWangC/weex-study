//
//  WXImagePickerModule.m
//  ios
//
//  Created by Michael on 2018/2/22.
//  Copyright © 2018年 weexstudy. All rights reserved.
//

#import "WXImagePickerModule.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "UserDefaultsUtil.h"

@interface  WXImagePickerModule()<TZImagePickerControllerDelegate>
@end

@implementation WXImagePickerModule

@synthesize weexInstance;
WX_EXPORT_METHOD(@selector(pushHeaderImagePickerController:))
WX_EXPORT_METHOD_SYNC(@selector(getHeaderIcon))

-(void)pushHeaderImagePickerController:(WXCallback) callback {
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePicker.allowPickingOriginalPhoto = NO;
    imagePicker.allowPickingVideo = NO;
    imagePicker.navigationBar.barStyle = UIBarStyleBlack;
    imagePicker.allowCrop = YES;
    [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        UIImage *originImage = [photos objectAtIndex:0];
        
        NSData *data = UIImageJPEGRepresentation(originImage, 1.0f);
        
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
        encodedImageStr = [NSString stringWithFormat:@"data:image/jpeg;base64,%@",encodedImageStr];
        
        callback(encodedImageStr);
        
        // 保存头像
        [UserDefaultsUtil setString:encodedImageStr forKey:APP_HEADER_ICON_DATA];
    }];
    
    [weexInstance.viewController presentViewController:imagePicker animated:YES completion:nil];
}

-(NSString *)getHeaderIcon {
    return [UserDefaultsUtil stringForKey:APP_HEADER_ICON_DATA];
}

@end
