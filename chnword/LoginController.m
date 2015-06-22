//
//  LoginController.m
//  chnword
//
//  Created by 苏智 on 15/6/20.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "LoginController.h"

@interface LoginController () <UITextFieldDelegate, UIAlertViewDelegate>
{
    CGFloat rowHeight;
}

@property (strong, nonatomic) IBOutlet UITextField *userCodeInput;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loginButton.alpha = 0.5f;

    CGFloat screenWidth = self.view.frame.size.width;
    rowHeight = screenWidth * 4 / 9;
    
    // 设置背景图片
    UIImageView *bacgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [bacgroundImageView setImage:[UIImage imageNamed:@"Background"]];
    [self.view insertSubview:bacgroundImageView atIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 在这里写调用登录请求
- (void)requestLoginFromNetwork:(NSString *)userCode
{
    
}

// 在这里写登录请求验证码
- (void)requestVerifyFromNetwork:(NSString *)verifyCode
{
    
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
        return rowHeight - 40;
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat totalHeaderAndFooterSpace = screenHeight - rowHeight * 3;
    if (totalHeaderAndFooterSpace < 0)
        return 0.01f;
    return totalHeaderAndFooterSpace / 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
        return 40.0f;
    return 0.01f;
}

- (IBAction)trailButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginButtonPressed:(id)sender
{
    if (self.loginButton.alpha < 1.0f)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入您的用户码然后再点击登录"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    // 发送网络登录请求
    [self requestLoginFromNetwork:self.userCodeInput.text];
    
#warning 现在默认返回需要验证
    [self loginNeedsVerify];
    // 如果返回登录成功直接调用
    // [self loginSucceed];
}

- (void)loginSucceed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginFailed:(NSString *)errMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:errMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)loginNeedsVerify
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您已经在超过两台设备上登录"
                                                    message:@"系统将向该用户码绑定的手机发送验证码，得到验证码后请在下方输入："
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)
    {
        UITextField *tf = [alertView textFieldAtIndex:0];
        [self requestVerifyFromNetwork:tf.text];

#warning 现在默认直接登录成功
        [self loginSucceed];
    }
}

#pragma mark - UITextFeildDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""])
        self.loginButton.alpha = 0.5f;
    else
        self.loginButton.alpha = 1.0f;
}

@end
