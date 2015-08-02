//
//  ShopViewController.m
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "ShopViewController.h"

@interface ShopViewController ()

@property (strong, nonatomic) IBOutlet UIView *shopSuit;
@property (strong, nonatomic) IBOutlet UIView *shopAnime;
@property (strong, nonatomic) IBOutlet UIView *shopCard;

@end

@implementation ShopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置背景图片
    CGRect frame = self.view.bounds;
    NSLog(@"%@", NSStringFromCGRect(frame));
    frame.size.height += 64;
    
    UIImageView *bacgroundImageView = [[UIImageView alloc] initWithFrame:frame];
    [bacgroundImageView setImage:[UIImage imageNamed:@"Background"]];
    [self.view insertSubview:bacgroundImageView atIndex:0];
    
    self.shopSuit.layer.cornerRadius = 8.0f;
    self.shopAnime.layer.cornerRadius = 8.0f;
    self.shopCard.layer.cornerRadius = 8.0f;
       
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BrandTitle"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setTitle:@"产品商店"];
    
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGRect rect = self.tableView.frame;
    rect.size.height -= 49;
    self.tableView.frame = rect;
    
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


@end
