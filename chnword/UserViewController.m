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

@interface UserViewController ()

@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation UserViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置背景图片
//    CGRect frame = self.view.frame;
//    frame.origin.y -= 64;
//    frame.size.height += 64;
    CGRect frame = self.view.bounds;
    frame.size.height += 64;
    UIImageView *bacgroundImageView = [[UIImageView alloc] initWithFrame:frame];
    [bacgroundImageView setImage:[UIImage imageNamed:@"Background"]];
    [self.view insertSubview:bacgroundImageView atIndex:0];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BrandTitle"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setTitle:@"用户中心"];
    
    
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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
