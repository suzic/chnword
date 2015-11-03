//
//  LoginController.m
//  chnword
//
//  Created by 苏智 on 15/6/20.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginController.h"
#import "NetManager.h"
#import "NetParamFactory.h"
#import "Util.h"
#import "DataUtil.h"

#import "MBProgressHUD.h"

#define TEST_CODE 9999

@interface LoginController () <UITextFieldDelegate, UIAlertViewDelegate>
{
    CGFloat rowHeight;
}

@property (strong, nonatomic) IBOutlet UITextField *userCodeInput;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation LoginController

// 登录界面的初始设置
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loginButton.alpha = 0.5f;

    CGFloat screenWidth = self.view.frame.size.width;
    rowHeight = screenWidth * 4 / 9;
    
    // 设置背景图片
    UIImageView *bacgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [bacgroundImageView setImage:[UIImage imageNamed:@"Background"]];
    bacgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.backgroundView = bacgroundImageView;
}

// 在这里写调用登录请求
- (void)requestLoginFromNetwork:(NSString *)userCode
{
    NSString *opid = [Util generateUuid];
    NSString *deviceId = [Util getUdid];
    // NSString *userid = [Util generateUuid];

    NSString *userid = userCode;

    //本地用户存储
    NSDictionary *param = [NetParamFactory registParam:opid
                                                userid:userid
                                                device:deviceId
                                              userCode:userCode
                                              deviceId:deviceId
                                               session:[Util generateUuid]
                                                verify:@"verify"];
    
    [NetManager postRequest:URL_LOGIN param:param success:^(id json){
        
        NSLog(@"success with json:\n %@", json);
        NSDictionary *dict = json;
        if (dict != nil)
        {
            NSString *result = [dict objectForKey:@"result"];
            if (result && [@"1" isEqualToString:result])
            {
#warning 添加默认用户
                // [DataUtil setDefaultUser:userid];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"注册失败"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"网络连接失败"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }fail:^ (){
        NSLog(@"Login Failed.");
    }];
}

// 在这里写登录请求验证码
- (void)requestVerifyFromNetwork:(NSString *)verifyCode
{
    // NSString *activeCode = self.activeCodeField.text;
    NSString *opid = [Util generateUuid];
    NSString *deviceId = [Util getUdid];    
    NSString *userid = [DataUtil getDefaultUser];
    
    if (!userid)
    {
        [DataUtil setDefaultUser:@"0"];
        userid = @"0";
    }
    
    //本地用户存储
    [self.hud show:YES];
    
    // NSDictionary *param = [NetParamFactory registParam:opid userid:userid device:deviceId userCode:userid  deviceId:deviceId session:[Util generateUuid] verify:@"verify"];
    NSDictionary *param = [NetParamFactory verifyParam:opid userid:userid device:deviceId code:verifyCode user:userid];
    [NetManager postRequest:URL_VERIFY param:param success:^(id json){
        
        NSLog(@"success with json:\n %@", json);
        
        [self.hud hide:YES];
        NSDictionary *dict = json;
        NSString *str = [dict objectForKey:@"result"];
        if (str && [@"1" isEqualToString:str])
        {
            //成功
            NSDictionary *data = [dict objectForKey:@"data"];
            if (data)
            {
                NSString *unlock_all = [dict objectForKey:@"unlock_all"];
                NSArray *zones = [dict objectForKey:@"unlock_zone"];
                if (unlock_all && [@"1" isEqualToString:unlock_all])
                {
                    //解锁全部的
                    NSLog(@"unlock_all");
                    [DataUtil setUnlockAllModelsForUser:[DataUtil getDefaultUser]];
                }
                else
                {
                    //得到解锁的其他条目,处理unlock_zone.
                    for (NSString *unlocked in zones)
                        NSLog(@"unlocked %@", unlocked);
                    [DataUtil setUnlockModel:userid models:zones];
                }
                NSString *message = [NSString stringWithFormat:@"解锁成功：\n data \n %@", data];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                
                //登录成功的处理
                [self loginSucceed];
            }
            else
            {
                NSString *message = [dict objectForKey:@"message"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        else
        {
            // NSString *message = @"请求失败！";
            // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            // [alert show];
            // 登录失败
            [self loginNeedsVerify];
        }
    } fail:^ () {
        NSLog(@"Login Failed.");
        [self.hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"你并不一定真正认识汉字，不信？试试看！\n体验用户，请点击——";
    return @"";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
        return rowHeight - 30;
    if (indexPath.section == 2)
        return rowHeight - 40;
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 80;
    
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat totalHeaderAndFooterSpace = screenHeight - rowHeight * 3;
    if (totalHeaderAndFooterSpace < 0)
        return 0.01f;
    return totalHeaderAndFooterSpace / 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
        return 20.0f;
    return 0.01f;
}

#pragma mark - User actions

// 试用按钮点击
- (IBAction)trailButtonPressed:(id)sender
{
    // [self requestLoginFromNetwork:@"13700845991"];
    
    // 设置默认用户为0,然后直接进入即可
    [DataUtil setDefaultUser:@"0"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 登录按钮点击
- (IBAction)loginButtonPressed:(id)sender
{
#warning 测试登录出错效果
    [self testErrorResult];
    
//    if (self.loginButton.alpha < 1.0f)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"请输入您的用户码然后再点击登录"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }

    // 发送网络登录请求，verify接口。
    [self requestLoginFromNetwork:self.userCodeInput.text];
    // [self requestVerifyFromNetwork:self.userCodeInput.text];
    
#warning 现在默认返回需要验证
    // [self loginNeedsVerify];
    // 如果返回登录成功直接调用
    // [self loginSucceed];
}

// 登录成功处理
- (void)loginSucceed
{
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    appDelegate.isLogin = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 登录失败处理
- (void)loginFailed
{
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    appDelegate.isLogin = NO;
    [self.errorContainer showLoginErrorWrong];
}

// 登录需要验证
- (void)loginNeedsVerify
{
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    appDelegate.isLogin = NO;
    [self.errorContainer showLoginErrorTooMany];
}

#pragma mark - UIAlertViewDelegate

// 提示信息用户操作反馈
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 当提示信息是测试对话框时
    if (alertView.tag == TEST_CODE)
    {
        switch (buttonIndex)
        {
            case 1:
                [self loginNeedsVerify];
                break;
            case 2:
                [self loginFailed];
                break;
            case 0:
            default:
                [self loginSucceed];
                break;
        }
        
        return;
    }

    // 关于验证窗口的提示结果
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

#pragma mark -getter

- (MBProgressHUD *) hud
{
    if (!_hud)
    {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.color = [UIColor clearColor]; //这儿表示无背景
        //显示的文字
        _hud.labelText = @"登录中...";
        //细节文字
        _hud.detailsLabelText = @""; //@"Test detail";
        //是否有庶罩
        _hud.dimBackground = YES;
        [self.navigationController.view addSubview:_hud];
    }
    return _hud;
}

#pragma mark - Functions for test only

// 直接提示出各种登录错误结果
- (void)testErrorResult
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[功能测试]"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"登录成功"
                                          otherButtonTitles:@"过多设备",@"用户码错",nil];
    alert.tag = TEST_CODE;
    [alert show];
}

@end
