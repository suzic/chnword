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
#import "FeedbacjViewController.h"

#import "UMSocial.h"

@interface UserViewController () <UMSocialUIDelegate>

@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation UserViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置背景图片
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BrandTitle"] forBarMetrics:UIBarMetricsDefault];

    
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationItem.title = @"我的";
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BrandTitle"] forBarMetrics:UIBarMetricsDefault];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recallWelcome:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowWelcome object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowLogin object:self];

}



- (IBAction) registerUser:(id)sender
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

#pragma mark - Table view data source

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.backgroundColor = [UIColor clearColor];
//}

#pragma mark - TableViewDelegate Method
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
        {
            //ignore
        }
            break;
            
        case 1:{
            
            NSInteger row = indexPath.row;
            WebViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            NSString *urlString = nil;
            if (row == 0) {
                //会员特权
                urlString = @"";
                [self.navigationController pushViewController:webViewController animated:YES];
            } else if (row == 1) {
                //意见反馈
                FeedbacjViewController *feedbackViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbacjViewController"];
                [self.navigationController pushViewController:feedbackViewController animated:YES];
                
            } else if (row == 2) {
                //引导页面
                
                
            } else if (row == 3) {
                //邀请好友，就是进行分享
                //进行分享
                [UMSocialSnsService presentSnsIconSheetView:self
                                                     appKey:nil
                                                  shareText:@"三千字"
                                                 shareImage:[UIImage imageNamed:@"LOGO1.png"]
                                            shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToQzone, UMShareToQQ, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToWechatFavorite, nil]
                                                   delegate:self];
                //分享video
//                [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeVideo url:@"http://app.3000zi.com/web/download.php"];
                [UMSocialData defaultData].urlResource.url = @"http://app.3000zi.com/web/download.php";
            }
            
            
            
        }
            break;
            
        case 2:{
            
            //关于
            WebViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            webViewController.urlString = URL_USER_ABOUT;
            [self.navigationController pushViewController:webViewController animated:YES];
            
        }
            break;
        default:
            break;
    }
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


#pragma mark - UMSocial delegate method
/**
 自定义关闭授权页面事件
 
 @param navigationCtroller 关闭当前页面的navigationCtroller对象
 
 */
-(BOOL)closeOauthWebViewController:(UINavigationController *)navigationCtroller socialControllerService:(UMSocialControllerService *)socialControllerService
{
    return NO;
}

/**
 关闭当前页面之后
 
 @param fromViewControllerType 关闭的页面类型
 
 */
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    
    
}

/**
 各个页面执行授权完成、分享完成、或者评论完成时的回调函数
 
 @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

/**
 点击分享列表页面，之后的回调方法，你可以通过判断不同的分享平台，来设置分享内容。
 例如：
 
 -(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
 {
 if (platformName == UMShareToSina) {
 socialData.shareText = @"分享到新浪微博的文字内容";
 }
 else{
 socialData.shareText = @"分享到其他平台的文字内容";
 }
 }
 
 @param platformName 点击分享平台
 
 @prarm socialData   分享内容
 */
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    if (platformName == UMShareToSina) {
        
        socialData.shareText = @"分享到新浪微博的文字内容";
        
    } else if (platformName == UMShareToWechatSession) {
        
        socialData.shareText = @"分享到微信好友的文字内容";
        
    }else if (platformName == UMShareToWechatTimeline) {
        socialData.shareText = @"分享到微信朋友圈的文字内容";
    }
    else{
        socialData.shareText = @"分享到其他平台的文字内容";
    }
}


/**
 配置点击分享列表后是否弹出分享内容编辑页面，再弹出分享，默认需要弹出分享编辑页面
 
 @result 设置是否需要弹出分享内容编辑页面，默认需要
 
 */
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}



@end
