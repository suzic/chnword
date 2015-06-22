//
//  WordsController.m
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "WordsController.h"
#import "PlayController.h"

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect orgFrame = self.navigationController.navigationBar.frame;
    orgFrame.size.height = self.view.frame.size.width * 532 / 1440 - 20;
    [self.navigationController.navigationBar setFrame:orgFrame];
}

// 初始化分类列表
- (void)setupWordsList
{
    self.wordsList = [NSMutableArray arrayWithCapacity:40];
    for (int i = 0; i < 40; i++)
    {
        [self.wordsList addObject:@{@"wordName":@"",
                                    @"lockStatus":@"1",
                                    @"wordImageA":[NSString stringWithFormat:@"CATE_A_%02d", i + 1],
                                    @"wordImageB":[NSString stringWithFormat:@"CATE_B_%02d", i + 1]}];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPlay"])
    {
#warning 这里设置正确的播放动画资源
        PlayController *player = (PlayController *)[segue destinationViewController];
        player.fileUrl = [[NSBundle mainBundle] URLForResource:@"jiafei" withExtension:@"gif"];
    }
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

/*
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
*/

@end
