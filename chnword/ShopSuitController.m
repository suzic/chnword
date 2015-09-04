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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)naviBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return [tableView dequeueReusableCellWithIdentifier:@"cellSuit"];
        case 1:
            return [tableView dequeueReusableCellWithIdentifier:@"cellIntro"];
        case 2:
        default:
            return [tableView dequeueReusableCellWithIdentifier:@"cellBuy"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 210;
        case 1:
            return 140;
        case 2:
        default:
            return 100;
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
