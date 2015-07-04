//
//  HomePageController.m
//  chnword
//
//  Created by 苏智 on 15/6/20.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "HomePageController.h"
#import "QrSearchViewController.h"


#import "NetParamFactory.h"
#import "NetManager.h"
#import "Util.h"
#import "DataUtil.h"
#import "MBProgressHUD.h"



@interface HomePageController () <QrSearchViewControllerDelegate>

@property (assign, nonatomic) CGFloat savedNavigationBarHeight;

@property (assign, nonatomic) CGFloat rowHeight01;
@property (assign, nonatomic) CGFloat rowHeight02;
@property (assign, nonatomic) CGFloat rowHeight03;


@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation HomePageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    self.savedNavigationBarHeight = self.navigationController.navigationBar.frame.size.height;

    // 设置背景图片
    CGRect frame = self.view.frame;
    frame.origin.y -= 20; // 算上状态栏位置
    UIImageView *bacgroundImageView = [[UIImageView alloc] initWithFrame:frame];
    [bacgroundImageView setImage:[UIImage imageNamed:@"Background"]];
    [self.view insertSubview:bacgroundImageView atIndex:0];
    
    self.rowHeight01 = (self.view.frame.size.width) * 59 / 122;
    self.rowHeight02 = (self.view.frame.size.width * 3 / 4) * 42 / 127;
    self.rowHeight03 = (self.view.frame.size.width * 2 / 3) * 367 / 445;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGRect orgFrame = self.navigationController.navigationBar.frame;
    orgFrame.size.height = self.savedNavigationBarHeight;
    [self.navigationController.navigationBar setFrame:orgFrame];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
        case 2:
            return self.rowHeight03;
        default:
            return 0.01f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat screenHeight = self.view.frame.size.height - 49.0f;
    CGFloat sectionHeight = (screenHeight - self.rowHeight01 - self.rowHeight02 - self.rowHeight03) / 3;
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
- (void) QRSearchViewControllerDidCanceled:(QrSearchViewController *) controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void) QRSearchViewController:(QrSearchViewController *)controller successedWith:(NSString *) str
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - net word interface
- (void) requestWord:(NSString *) word
{
    NSDictionary *param = [NetParamFactory wordParam:[Util generateUuid] userid:@"1" device:@"1" word:@"1"];
    
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
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:data delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                
                
//                NSString *videoUrl = [data objectForKey:@"video"];
//                NSString *gifUrl = [data objectForKey:@"gif"];
                
                
            }else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
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
