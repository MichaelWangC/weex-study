//
//  HybridViewController.h
//  ios
//
//  Created by Michael on 2017/12/10.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "BaseViewController.h"

@interface HybridViewController : BaseViewController

@property (nonatomic) BOOL isHiddenNavBar;

-(void)loadPage:(NSString*)url withTitle:(NSString*)title;

@end
