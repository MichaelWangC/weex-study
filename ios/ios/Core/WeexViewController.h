//
//  WeexViewController.h
//  ios
//
//  Created by Michael on 2017/9/28.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "BaseViewController.h"

@interface WeexViewController : BaseViewController

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, copy) void (^onCreate)();

@end
