//
//  WordsController.m
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "WordsController.h"
#import "CategoryHeaderView.h"

@interface WordsController ()

@property (strong, nonatomic) NSMutableArray *wordsList;

@end

@implementation WordsController

static NSString * const reuseIdentifier = @"WordCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // 设置背景图片
    CGRect frame = self.view.frame;
    frame.origin.y -= 20; // 算上状态栏位置
    frame.size.height += 20; // 算上状态栏位置
    UIImageView *bacgroundImageView = [[UIImageView alloc] initWithFrame:frame];
    NSString *bgImageName = [NSString stringWithFormat:@"CATE_BG_%02d", (self.categoryIndex + 1)];
    [bacgroundImageView setImage:[UIImage imageNamed:bgImageName]];
    [self.view insertSubview:bacgroundImageView atIndex:0];
    
    [self setupWordsList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 设置导航背景图片及过渡动画
    NSString *headerImageName = [NSString stringWithFormat:@"CATE_HEADER_%02d", (self.categoryIndex + 1)];
    [UIView animateWithDuration:0.3f animations:^{
        self.navigationController.navigationBar.alpha = 0.2f;
    } completion:^(BOOL finished) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:headerImageName] forBarMetrics:UIBarMetricsDefault];
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.navigationBar.alpha = 1.0f;
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 初始化分类列表
- (void)setupWordsList
{
    self.wordsList = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 10; i++)
    {
        [self.wordsList addObject:@{@"wordName":[NSString stringWithFormat:@"分类%d", i + 1],
                                    @"lockStatus":@"1",
                                    @"wordImageA":[NSString stringWithFormat:@"CATE_A_%02d", i + 1],
                                    @"wordImageB":[NSString stringWithFormat:@"CATE_B_%02d", i + 1]}];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.wordsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WordCell *cell = (WordCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        CategoryHeaderView *sectionHeader = (CategoryHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                     withReuseIdentifier:@"CategoryHeader"
                                                                                                            forIndexPath:indexPath];
        NSString *headerImageName = [NSString stringWithFormat:@"CATE_HEADER_%02d", (self.categoryIndex + 1)];
        [sectionHeader.headerImage setImage:[UIImage imageNamed:headerImageName]];
        return sectionHeader;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width - 50) / 4, (self.view.frame.size.width - 50) / 4);
}

@end
