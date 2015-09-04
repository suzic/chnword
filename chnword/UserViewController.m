//
//  UserViewController.m
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "UserViewController.h"

#import "NetManager.h"
#import "NetParamFactory.h"
#import "Util.h"
#import "DataUtil.h"
#import "MBProgressHUD.h"
#import "WebViewController.h"
#import "FeedbackViewController.h"
#import "UMSocial.h"

#import "ShopHeaderCell.h"
#import "UserCell.h"
#import "SettingsCell.h"
#import "AboutCell.h"

@interface UserViewController () <UMSocialUIDelegate>

@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation UserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置背景图片
    UIImageView *bacgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [bacgroundImageView setImage:[UIImage imageNamed:@"Background"]];
    bacgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.backgroundView = bacgroundImageView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 0.01f;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.alpha = 0.01f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITable View delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return 1;
        case 2:
            return 4;
        case 3:
            return 1;
        case 0:
        default:
            return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2)
    {
        switch (indexPath.row)
        {
            case 0:
                // 会员特权
                [self showUserVip];
                break;
            case 1:
                // 意见反馈
                [self showFeedback];
                break;
            case 2:
                // 引导页
                [self showUserGuide];
                break;
            case 3:
                // 邀请好友
                [self inviteShare];
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 3)
    {
        // ABOUT
        [self showAbout];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ShopHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
        return cell;
    }
    else if (indexPath.section == 2)
    {
        SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"functionCell"];
        switch (indexPath.row) {
            case 0:
                [cell.functionTitle setText:@"会员特权"];
                break;
            case 1:
                [cell.functionTitle setText:@"用户反馈"];
                break;
            case 2:
                [cell.functionTitle setText:@"产品介绍"];
                break;
            case 3:
                [cell.functionTitle setText:@"邀请好友"];
                break;
        }
        return cell;
    }
    else
    {
        AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell"];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return kScreenWidth * 100.0f / 360.0f;
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 0.01f;
    return 11.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 11.0f;
}

#pragma mark - Setting functions

- (IBAction)recallWelcome:(id)sender
{
    // [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowWelcome object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowLogin object:self];
}

- (IBAction)registerUser:(id)sender
{
    NSString *opid = [Util generateUuid];
    NSString *deviceId = [Util getUdid];
    //    NSString *userid = [Util generateUuid];
    NSString *userid = self.phoneNumberField.text;
    
    //本地用户存储
    NSDictionary *param = [NetParamFactory
                           registParam:opid
                           userid:userid
                           device:deviceId
                           userCode:userid
                           deviceId:deviceId
                           session:[Util generateUuid]
                           verify:@"verify"];
    [NetManager postRequest:URL_LOGIN param:param success:^(id json){
        
        NSLog(@"success with json:\n %@", json);
        
        NSDictionary *dict = json;
        
        if (dict) {
            NSString *result = [dict objectForKey:@"result"];
            if (result && [@"1" isEqualToString:result]) {
#pragma warning 添加默认用户
                [DataUtil setDefaultUser:userid];
                //                [self dismissViewControllerAnimated:YES completion:nil];
                NSString *message = [NSString stringWithFormat:@"注册成功.账号为：%@", userid];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                
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

- (void)showUserGuide
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowWelcome object:self];
}

- (void)inviteShare
{
    //邀请好友，就是进行分享
    //进行分享
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:@"三千字"
                                     shareImage:[UIImage imageNamed:@"LOGO1.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToQzone, UMShareToQQ, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToWechatFavorite, nil]
                                       delegate:self];
    
    [UMSocialData defaultData].urlResource.url = @"http://app.3000zi.com/web/download.php";
}

- (void)showFeedback
{
    //意见反馈
    FeedbackViewController *feedbackViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbacjViewController"];
    [self.navigationController pushViewController:feedbackViewController animated:YES];
}

- (void)showUserVip
{
    //关于
    WebViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webViewController.urlString = URL_USER_LOGIN;
    webViewController.titleText = @"会员特权";
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)showAbout
{
    //关于
    WebViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webViewController.urlString = URL_USER_ABOUT;
    webViewController.titleText = @"关于";
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark -getter

- (MBProgressHUD *) hud
{
    if (!_hud)
    {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.color = [UIColor clearColor];//这儿表示无背景
        //显示的文字
        _hud.labelText = @"正在加载";
        //细节文字
        _hud.detailsLabelText = @"";// @"Test detail";
        //是否有庶罩
        _hud.dimBackground = YES;
        [self.navigationController.view addSubview:_hud];
    }
    return _hud;
}

#pragma mark - UMSocial delegate method

/**
 * @abstract 自定义关闭授权页面事件
 * @param navigationCtroller 关闭当前页面的navigationCtroller对象
 */
- (BOOL)closeOauthWebViewController:(UINavigationController *)navigationCtroller socialControllerService:(UMSocialControllerService *)socialControllerService
{
    return NO;
}

/**
 * @abstract 关闭当前页面之后
 * @param fromViewControllerType 关闭的页面类型
 */
- (void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{

}

/**
 * @abstract 各个页面执行授权完成、分享完成、或者评论完成时的回调函数
 * @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
 */
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

/**
 * 点击分享列表页面，之后的回调方法，你可以通过判断不同的分享平台，来设置分享内容。
 * 例如：
 * - (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
 * {
 *     if (platformName == UMShareToSina)
 *     {
 *         socialData.shareText = @"分享到新浪微博的文字内容";
 *     }
 *     else
 *     {
 *         socialData.shareText = @"分享到其他平台的文字内容";
 *     }
 * }
 * @param platformName 点击分享平台
 * @param socialData   分享内容
 */
- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    if (platformName == UMShareToSina)
    {
        socialData.shareText = @"分享到新浪微博的文字内容";
    }
    else if (platformName == UMShareToWechatSession)
    {
        socialData.shareText = @"分享到微信好友的文字内容";
    }
    else if (platformName == UMShareToWechatTimeline)
    {
        socialData.shareText = @"分享到微信朋友圈的文字内容";
    }
    else
    {
        socialData.shareText = @"分享到其他平台的文字内容";
    }
}

/**
 * 配置点击分享列表后是否弹出分享内容编辑页面，再弹出分享，默认需要弹出分享编辑页面
 * @result 设置是否需要弹出分享内容编辑页面，默认需要
 *
 */
- (BOOL)isDirectShareInIconActionSheet
{
    return YES;
}

@end
