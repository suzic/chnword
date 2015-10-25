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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.errorView.hidden = YES;
    self.errorContent.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ErrorBG"]];
    self.errorBuy.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ErrorBG"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (IBAction)closeError:(id)sender
{
    CGRect showPos = CGRectMake(0, kScreenHeight - self.errorContent.frame.size.height, kScreenWidth, self.errorContent.frame.size.height);
    CGRect hidePos = CGRectMake(0, kScreenHeight, kScreenWidth, self.errorContent.frame.size.height);
    
    [UIView animateWithDuration:0.3f animations:^{
        self.errorContent.frame = hidePos;
        self.errorBuy.frame = hidePos;
    } completion:^(BOOL finished) {
        self.errorView.hidden = YES;
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loginContent"])
    {
        LoginController *loginVC = (LoginController *)[segue destinationViewController];
        loginVC.errorContainer = self;
    }
}

@end
