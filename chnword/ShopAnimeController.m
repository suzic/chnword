//
//  ShopAnimeController.m
//  chnword
//
//  Created by 苏智 on 15/6/22.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "ShopAnimeController.h"
#import "ShopCell.h"

@interface ShopAnimeController ()

@property (strong, nonatomic) NSMutableArray *categoryList;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation ShopAnimeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedIndex = NSNotFound;
    
    // 设置背景图片
    CGRect frame = self.view.frame;
    frame.origin.y -= 64;
    frame.size.height += 64;
    UIImageView *bacgroundImageView = [[UIImageView alloc] initWithFrame:frame];
    [bacgroundImageView setImage:[UIImage imageNamed:@"Background"]];
    [self.view insertSubview:bacgroundImageView atIndex:0];

    [self setupCategroyList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 初始化分类列表
- (void)setupCategroyList
{
    self.categoryList = [NSMutableArray arrayWithCapacity:10];
    NSArray *cateNames = @[@"天文篇完整版", @"地理篇完整版", @"植物篇完整版", @"动物篇完整版", @"人姿篇完整版",
                           @"身体篇完整版", @"生理篇完整版", @"生活篇完整版", @"活动篇完整版", @"文化篇完整版"];
    for (int i = 0; i < 10; i++)
    {
        [self.categoryList addObject:@{@"itemName":cateNames[i],
                                       @"itemPrice":@"¥ 20.00",
                                       @"itemCode":[NSString stringWithFormat:@"%d", i],
                                       @"itemImage":[NSString stringWithFormat:@"BUY_CATE_%02d", i + 1]}];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.categoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCell *cell = (ShopCell *)[tableView dequeueReusableCellWithIdentifier:@"shopCell" forIndexPath:indexPath];
    NSDictionary *cateDic = self.categoryList[indexPath.row];
    cell.itemCode = cateDic[@"itemCode"];
    [cell.itemName setText:cateDic[@"itemName"]];
    [cell.itemImage setImage:[UIImage imageNamed:cateDic[@"itemImage"]]];
    [cell.itemPrice setText:cateDic[@"itemPrice"]];
    cell.itemBuy.hidden = (self.selectedIndex != indexPath.row);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex == indexPath.row)
    {
        self.selectedIndex = NSNotFound;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
    {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
        self.selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:@[indexPath, lastIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

@end
