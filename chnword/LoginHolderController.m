//
//  LoginHolderController.m
//  chnword
//
//  Created by 苏智 on 15/10/14.
//  Copyright © 2015年 Suzic. All rights reserved.
//

#import "LoginHolderController.h"
#import "LoginController.h"

@interface LoginHolderController ()

@property (strong, nonatomic) IBOutlet UIView *errorView;
@property (strong, nonatomic) IBOutlet UIView *errorContent;
@property (strong, nonatomic) IBOutlet UIView *errorBuy;

@end

@implementation LoginHolderController

// 初始化登录容器界面
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.errorView.hidden = YES;
    self.errorContent.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ErrorBG"]];
    self.errorBuy.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ErrorBG"]];
}

// 显示同一个用户号码在太多设备上登录
- (void)showLoginErrorTooMany
{
    CGRect showPos = CGRectMake(0, kScreenHeight - self.errorContent.frame.size.height, kScreenWidth, self.errorContent.frame.size.height);
    CGRect hidePos = CGRectMake(0, kScreenHeight, kScreenWidth, self.errorContent.frame.size.height);

    self.errorContent.frame = hidePos;
    self.errorBuy.frame = hidePos;
    self.errorView.hidden = NO;
    [UIView animateWithDuration:0.2f animations:^{
        self.errorContent.frame = showPos;
    } completion:nil];
}

// 显示错误的用户码输入
- (void)showLoginErrorWrong
{
    CGRect showPos = CGRectMake(0, kScreenHeight - self.errorContent.frame.size.height, kScreenWidth, self.errorContent.frame.size.height);
    CGRect hidePos = CGRectMake(0, kScreenHeight, kScreenWidth, self.errorContent.frame.size.height);
    
    self.errorContent.frame = hidePos;
    self.errorBuy.frame = hidePos;
    self.errorView.hidden = NO;
    [UIView animateWithDuration:0.2f animations:^{
        self.errorBuy.frame = showPos;
    } completion:nil];
}

// 关闭错误提示界面
- (IBAction)closeError:(id)sender
{
    CGRect hidePos = CGRectMake(0, kScreenHeight, kScreenWidth, self.errorContent.frame.size.height);
    
    [UIView animateWithDuration:0.3f animations:^{
        self.errorContent.frame = hidePos;
        self.errorBuy.frame = hidePos;
    } completion:^(BOOL finished) {
        self.errorView.hidden = YES;
    }];
}

// 进入商店
- (IBAction)gotoBuy:(id)sender
{
    [self closeError:sender];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowShop object:self];
    }];
}

#pragma mark - Navigation

// 内嵌导航到实际登录窗口并告知其错误处理代理
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loginContent"])
    {
        LoginController *loginVC = (LoginController *)[segue destinationViewController];
        loginVC.errorContainer = self;
    }
}

@end
