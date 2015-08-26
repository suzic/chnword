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
    UIImageView *bacgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [bacgroundImageView setImage:[UIImage imageNamed:@"Background"]];
    bacgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.backgroundView = bacgroundImageView;
    
    //[self.navigationController setNavigationBarHidden:YES];
    
    self.shopSuit.layer.cornerRadius = 8.0f;
    self.shopAnime.layer.cornerRadius = 8.0f;
    self.shopCard.layer.cornerRadius = 8.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.navigationItem setTitle:@"产品商店"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BrandTitle"]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.navigationController.navigationBar.alpha = 1.0f;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect orgFrame = self.navigationController.navigationBar.frame;
    orgFrame.size.height = self.view.frame.size.width * 532 / 1440 - 20;
    [self.navigationController.navigationBar setFrame:orgFrame];
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
