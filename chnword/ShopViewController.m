//
//  ShopViewController.m
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopHeaderCell.h"
#import "ShopItemCell.h"

@interface ShopViewController ()

@end

@implementation ShopViewController

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
    
    //[self.navigationItem setTitle:@"产品商店"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kScreenWidth * 100.0f / 360.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0f;
}

// 创建section头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShopHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    cell.contentView.tag = section;

    NSArray *gestures = [NSArray arrayWithArray:cell.contentView.gestureRecognizers];
    for (UIGestureRecognizer *gs in gestures)
        [cell.contentView removeGestureRecognizer:gs];
    
    return cell.contentView;
}

// 创建表格中的单元格
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell"];
    cell.cellImage.layer.cornerRadius = 8.0f;

    switch (indexPath.row)
    {
        case 0:
            [cell.cellTitle setText:@"三千字超值套装"];
            break;
        case 1:
            [cell.cellTitle setText:@"动画资源库"];
            break;
        case 2:
            [cell.cellTitle setText:@"实体汉字卡片"];
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
        case 0:
            [self performSegueWithIdentifier:@"showSuit" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"showCategory" sender:self];
            break;
        case 2:
            // [self performSegueWithIdentifier:@"showSuit" sender:self];
            break;
            
        default:
            break;
    }
}

@end
