//
//  HomePageController.m
//  chnword
//
//  Created by 苏智 on 15/6/20.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "HomePageController.h"

@interface HomePageController ()

@property (assign, nonatomic) CGFloat savedNavigationBarHeight;

@property (assign, nonatomic) CGFloat rowHeight01;
@property (assign, nonatomic) CGFloat rowHeight02;
@property (assign, nonatomic) CGFloat rowHeight03;

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
}

@end
