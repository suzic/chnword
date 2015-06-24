//
//  LoginController.m
//  chnword
//
//  Created by 苏智 on 15/6/20.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "LoginController.h"
#import "NetManager.h"
#import "NetParamFactory.h"
#import "Util.h"
#import "DataUtil.h"

#import "MBProgressHUD.h"

@interface LoginController () <UITextFieldDelegate, UIAlertViewDelegate>
{
    CGFloat rowHeight;
}

@property (strong, nonatomic) IBOutlet UITextField *userCodeInput;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, retain) MBProgressHUD *hud;

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
    NSString *opid = [Util generateUuid];
    NSString *deviceId = [Util getUdid];
//    NSString *userid = [Util generateUuid];

    NSString *userid = userCode;

    //本地用户存储
    NSDictionary *param = [NetParamFactory
                           registParam:opid
                           userid:userid
                           device:deviceId
                           userCode:userCode
                           deviceId:deviceId
                           session:[Util generateUuid]
                           verify:@"verify"];
    [NetManager postRequest:URL_REGIST param:param success:^(id json){
        
        NSLog(@"success with json:\n %@", json);
        
        NSDictionary *dict = json;
        
        if (dict) {
            NSString *result = [dict objectForKey:@"result"];
            if (result && [@"1" isEqualToString:result]) {
#pragma warning 添加默认用户
//                [DataUtil setDefaultUser:userid];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
        
    }fail:^ (){
        NSLog(@"fail ");
        
    }];

}

// 在这里写登录请求验证码
- (void)requestVerifyFromNetwork:(NSString *)verifyCode
{
//    NSString *activeCode = self.activeCodeField.text;
    
    NSString *opid = [Util generateUuid];
    NSString *deviceId = [Util getUdid];    
    NSString *userid = [DataUtil getDefaultUser];
    
    if (!userid) {
        [DataUtil setDefaultUser:@"0"];
        userid = @"0";
    }
    
    
    //本地用户存储
    [self.hud show:YES];
    
    //    NSDictionary *param = [NetParamFactory registParam:opid userid:userid device:deviceId userCode:userid  deviceId:deviceId session:[Util generateUuid] verify:@"verify"];
    NSDictionary *param = [NetParamFactory verifyParam:opid userid:userid device:deviceId code:verifyCode user:userid];
    [NetManager postRequest:URL_VERIFY param:param success:^(id json){
        
        NSLog(@"success with json:\n %@", json);
        
        [self.hud hide:YES];
        
        NSDictionary *dict = json;
        
        NSString *str = [dict objectForKey:@"result"];
        if (str && [@"1" isEqualToString:str]) {
            //成功
            NSDictionary *data = [dict objectForKey:@"data"];
            if (data) {
                
                NSString *unlock_all = [dict objectForKey:@"unlock_all"];
                NSArray *zones = [dict objectForKey:@"unlock_zone"];
                if (unlock_all && [@"1" isEqualToString:unlock_all]) {
                    //解锁全部的
                    NSLog(@"unlock——all");
                    [DataUtil setUnlockAllModelsForUser:[DataUtil getDefaultUser]];
                    
                    
                } else {
                    //得到解锁的其他条目,处理unlock_zone.
                    for (NSString *unlocked in zones) {
                        NSLog(@"unlocked %@", unlocked);
                    }
                    
                    [DataUtil setUnlockModel:userid models:zones];
                    
                    
                }
                NSString *message = [NSString stringWithFormat:@"解锁成功：\n data \n %@", data];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                
                //登录成功的处理
                [self loginSucceed];
                
            }else {
                NSString *message = [dict objectForKey:@"message"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        } else {
//            NSString *message = @"请求失败！";
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
            
            //登录失败
            [self loginNeedsVerify];
            
        }
        
    }fail:^ (){
        NSLog(@"fail ");
        [self.hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];

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

//试用按钮点击
- (IBAction)trailButtonPressed:(id)sender
{
//    [self requestLoginFromNetwork:@"13700845991"];
    
    //设置默认用户为0,然后直接进入即可
    [DataUtil setDefaultUser:@"0"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//登录按钮点击
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

    // 发送网络登录请求，verify接口。
//    [self requestLoginFromNetwork:self.userCodeInput.text];
    [self requestVerifyFromNetwork:self.userCodeInput.text];
    
#warning 现在默认返回需要验证
//    [self loginNeedsVerify];
    // 如果返回登录成功直接调用
//     [self loginSucceed];
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


#pragma mark -getter

- (MBProgressHUD *) hud {
    if (!_hud) {
        
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.color = [UIColor clearColor];//这儿表示无背景
        //显示的文字
        _hud.labelText = @"Test";
        //细节文字
        _hud.detailsLabelText = @"Test detail";
        //是否有庶罩
        _hud.dimBackground = YES;
        [self.navigationController.view addSubview:_hud];
    }
    return _hud;
}


@end
