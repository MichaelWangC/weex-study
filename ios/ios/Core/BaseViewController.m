//
//  BaseViewController.m
//  ios
//
//  Created by Michael on 2017/9/28.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "BaseViewController.h"
#import <Lottie/Lottie.h>

@interface BaseViewController ()

@property (atomic) int loadingStatusShowTimes;

@end

@implementation BaseViewController {
    UIActivityIndicatorView *_loadingIndicator;
    LOTAnimationView *_laAnimation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 防止列表下移
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIColor *textColor = COLOR_TEXT_DEFAULT;
    UIColor *titleColor = [UIColor blackColor];
    if (self.backButtonType == BackButtonTypeWhite) {
        textColor = [UIColor whiteColor];
        titleColor = [UIColor whiteColor];
    }
    // 导航栏设置
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:textColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor,//文字字体颜色
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:18]//文字字体大小
                                                                      }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action
{
    NSString *imageName = @"icon_back_gray";
    if (self.backButtonType == BackButtonTypeWhite) {
        imageName = @"icon_back_white";
    }
    // 返回按钮设置
    return [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                            style:UIBarButtonItemStylePlain
                                           target:target
                                           action:action];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    if (_statusBarIsLightContent) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark
#pragma mark dismiss
- (void)dismiss{
    [super dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissViewControllerAnimated:(BOOL)flag{
    if(self.navigationController.viewControllers.count>1){
        [self.navigationController popViewControllerAnimated:flag];
    }else{
        [self dismiss];
    }
}

#pragma mark Loading Status
-(void)showLoadingStatus{
    @synchronized(self){
        self.loadingStatusShowTimes+=1;
        if(_laAnimation==nil){
            UIView* spinnerContainer = [[UIView alloc]init];
            spinnerContainer.backgroundColor=[UIColor clearColor];
            [self.view addSubview:spinnerContainer];
            spinnerContainer.translatesAutoresizingMaskIntoConstraints=NO;
            
            [spinnerContainer autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:self.loadingStatusEdgeInset.left];
            [spinnerContainer autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:self.loadingStatusEdgeInset.right];
            [spinnerContainer autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:self.loadingStatusEdgeInset.top];
            [spinnerContainer autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:self.loadingStatusEdgeInset.bottom];
            
            _laAnimation = [LOTAnimationView animationNamed:@"Watermelon"];
            _laAnimation.contentMode = UIViewContentModeScaleAspectFit;
            _laAnimation.loopAnimation = YES;
            _laAnimation.backgroundColor = [UIColor whiteColor];
            
            _laAnimation.layer.cornerRadius = 10;
            _laAnimation.clipsToBounds = NO;
            _laAnimation.layer.shadowColor = [UIColor blackColor].CGColor;
            _laAnimation.layer.shadowOpacity = 0.1;
            _laAnimation.layer.shadowOffset = CGSizeMake(0,0);
            _laAnimation.layer.shadowRadius = 2;
            
            [spinnerContainer addSubview:_laAnimation];
            
            [_laAnimation autoSetDimension:ALDimensionWidth toSize:100];
            [_laAnimation autoSetDimension:ALDimensionHeight toSize:100];
            [_laAnimation autoConstrainAttribute:ALAttributeVertical toAttribute:ALAttributeVertical ofView:self.view];
            [_laAnimation autoConstrainAttribute:ALAttributeHorizontal toAttribute:ALAttributeHorizontal ofView:self.view];
            
            [_laAnimation play];
        }
    }
}

-(void)hideLoadingStatus{
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self){
            if(self.loadingStatusShowTimes>0){
                self.loadingStatusShowTimes-=1;
            }
            if(_laAnimation&&self.loadingStatusShowTimes==0){
                [_laAnimation stop];
                [_laAnimation.superview removeFromSuperview];
                _laAnimation = nil;
            }
        }
    });
}

@end
