//
//  ShopAnimeController.m
//  chnword
//
//  Created by 苏智 on 15/6/22.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "AppDelegate.h"
#import "ShopAnimeController.h"
#import "ShopCell.h"
#import "HeaderCell.h"
#import "FooterCell.h"

@interface ShopAnimeController ()

@property (strong, nonatomic) NSMutableArray *categoryList;
@property (weak, nonatomic) FooterCell* footer;

@end

@implementation ShopAnimeController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.selectedCategory != NSNotFound)
    {
        // 设置背景图片
        UIImageView *bacgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [bacgroundImageView setImage:[UIImage imageNamed:@"Background"]];
        bacgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.tableView.backgroundView = bacgroundImageView;
    }
    [self setupCategroyList:self.selectedCategory];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedCategory:(NSInteger)selectedCategory
{
    if (_selectedCategory == selectedCategory)
        return;
    _selectedCategory = selectedCategory;
    [self setupCategroyList:_selectedCategory];
}

// 初始化分类列表
- (void)setupCategroyList:(NSInteger)selectedIndex
{
    AppDelegate* appDelegate = [AppDelegate sharedDelegate];
    self.categoryList = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 10; i++)
    {
        [self.categoryList addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"itemName":appDelegate.cateNames[i],
                                                                                     @"itemPrice":[appDelegate.cateUnlocked[i] isEqualToString:@"1"] ? @(0) : @(18),
                                                                                     @"itemCode":[NSString stringWithFormat:@"%d", i],
                                                                                     @"itemImage":[NSString stringWithFormat:@"BUY_CATE_%02d", i + 1],
                                                                                     @"itemSelected":(selectedIndex == i) ? @"1" : @"0"}]];
    }
    [self.tableView reloadData];
}

- (CGFloat)calTotalPrice
{
    CGFloat totalValue = 0;
    for (NSDictionary *dic in self.categoryList)
    {
        if ([dic[@"itemSelected"] isEqualToString:@"1"])
        {
            NSNumber *price = dic[@"itemPrice"];
            totalValue += price.floatValue;
        }
    }
    return totalValue;
}

- (IBAction)stopPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buy:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"进入购买页" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
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
    return self.categoryList.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UITableViewCell* header = [tableView dequeueReusableCellWithIdentifier:@"shopHeader"];
        return header;
    }
    else if (indexPath.row == self.categoryList.count + 1)
    {
        self.footer = [tableView dequeueReusableCellWithIdentifier:@"shopBottom"];
        [self.footer.totalPrice setText:[NSString stringWithFormat:@"¥ %02.02lf", [self calTotalPrice]]];
        return self.footer;
    }
    ShopCell *cell = (ShopCell *)[tableView dequeueReusableCellWithIdentifier:@"shopCell" forIndexPath:indexPath];
    NSDictionary *cateDic = self.categoryList[indexPath.row - 1];
    cell.itemCode = cateDic[@"itemCode"];
    if (indexPath.row % 2 == 1)
        cell.backgroundColor = [UIColor colorWithRed:0x9f/256.0f  green:0x8c/256.0f  blue:0x69/256.0f alpha:0.2f];
    else
        cell.backgroundColor = [UIColor colorWithRed:1  green:1  blue:1 alpha:0.5f];
    [cell.itemName setText:cateDic[@"itemName"]];
    [cell.itemImage setImage:[UIImage imageNamed:cateDic[@"itemImage"]]];
    
    // 关于已购买的差别
    NSNumber *price = cateDic[@"itemPrice"];
    [cell.itemPrice setText:[NSString stringWithFormat:@"¥ %02.02lf", price.floatValue]];
    if ([price isEqualToNumber:@(0)])
    {
        cell.itemBuy.hidden = YES;
        cell.itemPrice.text = @"已购买";
    }
    else
    {
        cell.itemBuy.hidden = NO;
        UIImage *buttonImage = [UIImage imageNamed:@"CheckMark"];
        [cell.itemCheck setImage:([cateDic[@"itemSelected"] isEqualToString:@"0"] ? nil : buttonImage)];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 44.0f;
    else
        return 66.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 || indexPath.row == self.categoryList.count + 1)
        return;
    
    NSMutableDictionary *cateDic = self.categoryList[indexPath.row - 1];
    cateDic[@"itemSelected"] = [cateDic[@"itemSelected"] isEqualToString:@"0"] ? @"1" : @"0";
    ShopCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImage *buttonImage = [UIImage imageNamed:@"CheckMark"];
    [cell.itemCheck setImage:([cateDic[@"itemSelected"] isEqualToString:@"0"] ? nil : buttonImage)];
    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.categoryList.count + 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

@end
