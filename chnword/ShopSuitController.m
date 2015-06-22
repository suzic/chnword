//
//  ShopSuitController.m
//  chnword
//
//  Created by 苏智 on 15/6/22.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "ShopSuitController.h"

@interface ShopSuitController ()

@end

@implementation ShopSuitController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置背景图片
    CGRect frame = self.view.frame;
    frame.origin.y -= 64;
    frame.size.height += 64;
    UIImageView *bacgroundImageView = [[UIImageView alloc] initWithFrame:frame];
    [bacgroundImageView setImage:[UIImage imageNamed:@"Background"]];
    [self.view insertSubview:bacgroundImageView atIndex:0];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"功能实现方法"
                                                        message:@"提供一个网页（或者淘宝店地址），供用户购买"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
