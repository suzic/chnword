//
//  HomePageController.m
//  chnword
//
//  Created by 苏智 on 15/6/20.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    CGFloat screenHeight = self.view.frame.size.height - 39.0f;
    CGFloat sectionHeight = (screenHeight - self.rowHeight01 - self.rowHeight02) / 2;
    return sectionHeight > 0 ? sectionHeight : 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([@"QRSEARCH" isEqualToString:segue.identifier]) {
        QrSearchViewController *controller = (QrSearchViewController *) segue.destinationViewController;
        controller.delegate = self;
    }
}

#pragma mark - QRSEarchViewController Delegate Methods

- (void)QRSearchViewControllerDidCanceled:(QrSearchViewController *) controller
{
//    [controller dismissViewControllerAnimated:YES completion:nil];
//    [controller.navigationController dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popoverPresentationController];
}

- (void)QRSearchViewController:(QrSearchViewController *)controller successedWith:(NSString *) str
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self requestWord:str];
}

#pragma mark - net word interface

- (void)requestWord:(NSString *) word
{
    NSString *opid = [Util generateUuid];
    NSString *userid = [DataUtil getDefaultUser];
//    userid = @"userid";
    NSString *deviceId = [Util getUdid];
    NSDictionary *param = [NetParamFactory wordParam:[Util generateUuid] userid:userid device:deviceId word:word];
    
    NSLog(@"%@", URL_WORD);
    NSLog(@"%@", param);
    
    [self.hud show:YES];
    [NetManager postRequest:URL_WORD param:param success:^(id json){
        
        NSLog(@"success with json: %@", json);
        NSDictionary *dict = json;
        
        [self.hud hide:YES];
        
        if (dict) {
            NSString *result = [dict objectForKey:@"result"];
            
            if ([result isEqualToString:@"1"]) {
                NSDictionary *data = [dict objectForKey:@"data"];
                
                NSArray *wordName = [data objectForKey:@"word"];
                NSArray *wordIndex = [data objectForKey:@"unicode"];
                NSString *unicode ;
                
                for (NSInteger i = 0; i < wordName.count; i ++) {
                    NSString *aWrod = [wordName objectAtIndex:i];
                    if ([aWrod isEqualToString:word]) {
                        unicode = [wordIndex objectAtIndex:i];
                        
                        break;
                    }
                }
                
                if (unicode) {
                    PlayController *playController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayController"];
                    
                    
                    //找wordCode
                    playController.wordCode = unicode;
                    playController.fileUrl = [[NSBundle mainBundle] URLForResource:@"jiafei" withExtension:@"gif"];
                    
                    [self.navigationController pushViewController:playController animated:YES];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无效的字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
                
                
                
                
            }else {
                NSString *message = [dict objectForKey:@"message"];
                NSLog(@"%@", message);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
            
        } else {
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
