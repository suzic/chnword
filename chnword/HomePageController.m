//
//  HomePageController.m
//  chnword
//
//  Created by 苏智 on 15/6/20.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageController.h"
#import "QrSearchViewController.h"
#import "PlayController.h"
#import "NetParamFactory.h"
#import "NetManager.h"
#import "Util.h"
#import "DataUtil.h"
#import "MBProgressHUD.h"

@interface HomePageController () <QrSearchViewControllerDelegate>

@property (assign, nonatomic) CGFloat rowHeight01;
@property (assign, nonatomic) CGFloat rowHeight02;
@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation HomePageController

// 主页初始化
- (void)viewDidLoad
{
    [super viewDidLoad];

    //[[UIApplication sharedApplication] setStatusBarHidden:NO];

    // 设置背景图片
    UIImageView *bacgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [bacgroundImageView setImage:[UIImage imageNamed:@"MainPageBG"]];
    bacgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.backgroundView = bacgroundImageView;

    self.rowHeight01 = (self.view.frame.size.height - 44 - 49) / 2;
    self.rowHeight02 = (self.view.frame.size.height - 44 - 49) / 2;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            return self.rowHeight01;
        case 1:
            return self.rowHeight02;
        default:
            return 0.01f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - Navigation

// 配置二维码扫描的结果
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"toCamera" isEqualToString:segue.identifier])
    {
        UINavigationController *nc = segue.destinationViewController;
        QrSearchViewController *controller = (QrSearchViewController *)[nc topViewController];
        controller.delegate = self;
    }
}

// 点击进入扫描界面的检查。对于免费体验用户，功能不开放，提示购买
- (IBAction)enterScan:(id)sender
{
    AppDelegate* appDelegate = [AppDelegate sharedDelegate];
    if (appDelegate.isLogin == NO)
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiDisable object:self];
    else
        [self performSegueWithIdentifier:@"toCamera" sender:self];
}

- (IBAction)showList:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowList object:self];
}

#pragma mark - QRSEarchViewController Delegate Methods

// 扫描撤销
- (void)QRSearchViewControllerDidCanceled:(QrSearchViewController *) controller
{
    // 目前不必对撤销操作进行何种提示
}

// 扫描成功
- (void)QRSearchViewController:(QrSearchViewController *)controller successedWith:(NSString *) str
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self requestWord:str];
}

#pragma mark - net word interface

#warning 该方法获取汉字魔卡的卡字。该方法需要通过网络，得到是否支持该汉字的提示；如果不支持对应汉字，则给出错误提示，要求用户扫描“汉字魔卡”而不是其他
- (void)requestWord:(NSString *) word
{
    NSString *opid = [Util generateUuid];
    NSString *userid = [DataUtil getDefaultUser];
    NSString *deviceId = [Util getUdid];
    NSDictionary *param = [NetParamFactory wordParam:[Util generateUuid] userid:userid device:deviceId word:word];
    
    NSLog(@"%@", URL_WORD);
    NSLog(@"%@", param);
    
    [self.hud show:YES];
    [NetManager postRequest:URL_WORD param:param success:^(id json){
        
        NSLog(@"success with json: %@", json);
        NSDictionary *dict = json;
        
        [self.hud hide:YES];
        
        if (dict)
        {
            NSString *result = [dict objectForKey:@"result"];
            
            if ([result isEqualToString:@"1"])
            {
                NSDictionary *data = [dict objectForKey:@"data"];
                NSArray *wordName = [data objectForKey:@"word"];
                NSArray *wordIndex = [data objectForKey:@"unicode"];
                NSString *unicode ;
                
                for (NSInteger i = 0; i < wordName.count; i ++)
                {
                    NSString *aWrod = [wordName objectAtIndex:i];
                    if ([aWrod isEqualToString:word])
                    {
                        unicode = [wordIndex objectAtIndex:i];
                        break;
                    }
                }
                
                if (unicode)
                {
                    PlayController *playController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayController"];

                    //找wordCode
                    playController.wordCode = unicode;
                    //playController.fileUrl = [[NSBundle mainBundle] URLForResource:@"jiafei" withExtension:@"gif"];
                    
                    [self.navigationController pushViewController:playController animated:YES];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无效的字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
            }
            else
            {
                NSString *message = [dict objectForKey:@"message"];
                NSLog(@"%@", message);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        else
        {
            [self.hud hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
    }fail:^ (){
        NSLog(@"fail ");
        [self.hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
}

#pragma mark - Getter Method

- (MBProgressHUD *)hud
{
    if (!_hud)
    {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.color = [UIColor clearColor];//这儿表示无背景
        //显示的文字
        _hud.labelText = @"加载数据中";
        //细节文字
        _hud.detailsLabelText = @""; //@"Test detail";
        //是否有遮罩
        _hud.dimBackground = YES;
        [self.navigationController.view addSubview:_hud];
    }
    return _hud;
}

@end
