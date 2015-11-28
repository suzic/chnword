//
//  LoginHolderController.m
//  chnword
//
//  Created by 苏智 on 15/10/14.
//  Copyright © 2015年 Suzic. All rights reserved.
//

#import "LoginHolderController.h"
#import "LoginController.h"
#import "NetManager.h"
#import "NetParamFactory.h"
#import "Util.h"
#import "DataUtil.h"
#import "MBProgressHUD.h"


@interface LoginHolderController ()

@property (strong, nonatomic) IBOutlet UIView *errorView;
@property (strong, nonatomic) IBOutlet UIView *errorContent;
@property (strong, nonatomic) IBOutlet UIView *errorBuy;
@property (nonatomic, retain) MBProgressHUD *hud;

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
    NSDictionary *param = [NetParamFactory verifyParam:opid userid:userid device:deviceId code:verifyCode];
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
                //[self loginSucceed];
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
            //[self loginNeedsVerify];
        }
    } fail:^ () {
        NSLog(@"Login Failed.");
        [self.hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
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
