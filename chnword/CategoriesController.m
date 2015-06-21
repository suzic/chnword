//
//  CategoriesController.m
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "CategoriesController.h"
#import "WordsController.h"

@interface CategoriesController ()

@property (strong, nonatomic) NSMutableArray *categoryList;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation CategoriesController

static NSString * const reuseIdentifier = @"CategoryCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedIndex = NSNotFound;
    self.clearsSelectionOnViewWillAppear = NO;
    
    // 设置背景图片
    CGRect frame = self.view.frame;
    frame.origin.y -= 20; // 算上状态栏位置
    frame.size.height += 20; // 算上状态栏位置
    UIImageView *bacgroundImageView = [[UIImageView alloc] initWithFrame:frame];
    [bacgroundImageView setImage:[UIImage imageNamed:@"Background"]];
    [self.view insertSubview:bacgroundImageView atIndex:0];
    
    [self setupCategroyList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BrandTitle"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect orgFrame = self.navigationController.navigationBar.frame;
    orgFrame.size.height = self.view.frame.size.width * 532 / 1440 - 20;
    [self.navigationController.navigationBar setFrame:orgFrame];
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
    for (int i = 0; i < 10; i++)
    {
        [self.categoryList addObject:@{@"cateName":[NSString stringWithFormat:@"分类%d", i + 1],
                                       @"cateImageA":[NSString stringWithFormat:@"CATE_A_%02d", i + 1],
                                       @"cateImageB":[NSString stringWithFormat:@"CATE_B_%02d", i + 1]}];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"gotoCategory"])
    {
        WordsController *wordController = (WordsController *)[segue destinationViewController];
        wordController.categoryIndex = self.selectedIndex;
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categoryList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = (CategoryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *cateDic = self.categoryList[indexPath.row];
    [cell.categoryName setText:cateDic[@"cateName"]];
    [cell.categoryImage setImage:[UIImage imageNamed:cateDic[@"cateImageA"]]];
    [cell.categoryImage setHighlightedImage:[UIImage imageNamed:cateDic[@"cateImageB"]]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width - 50) / 3, (self.view.frame.size.width - 50) / 3 + 20);
}

// 用户选择一个cell时，首先判断highlight状态
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
	return YES;
}

// 其次再判断select状态
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
