//
//  CategoriesController.m
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "CategoriesController.h"
#import "WordsController.h"

#import "NetManager.h"
#import "NetParamFactory.h"
#import "Util.h"
#import "DataUtil.h"

#import "MBProgressHUD.h"



@interface CategoriesController ()

@property (strong, nonatomic) NSMutableArray *categoryList;
@property (assign, nonatomic) NSInteger selectedIndex;

@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation CategoriesController

static NSString * const reuseIdentifier = @"CategoryCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedIndex = NSNotFound;
    
    // 设置背景图片
//    CGRect frame = self.view.frame;
//    frame.origin.y -= 20; // 算上状态栏位置
//    frame.size.height += 20; // 算上状态栏位置
//    UIImageView *bacgroundImageView = [[UIImageView alloc] initWithFrame:frame];
//    [bacgroundImageView setImage:[UIImage imageNamed:@"Background"]];
//    [self.view insertSubview:bacgroundImageView atIndex:0];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BrandTitle"] forBarMetrics:UIBarMetricsDefault];
    [self setupCategroyList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BrandTitle"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    
//    CGRect orgFrame = self.navigationController.navigationBar.frame;
//    orgFrame.size.height = self.view.frame.size.width * 532 / 1440 - 20;
//    [self.navigationController.navigationBar setFrame:orgFrame];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 初始化分类列表
- (void)setupCategroyList
{
//    self.categoryList = [NSMutableArray arrayWithCapacity:10];
//    NSArray *cateNames = @[@"天文篇", @"地理篇", @"植物篇", @"动物篇", @"人姿篇", @"身体篇", @"生理篇", @"生活篇", @"活动篇", @"文化篇"];
//    for (int i = 0; i < 10; i++)
//    {
//        [self.categoryList addObject:@{@"cateName":cateNames[i],
//                                       @"cateImageA":[NSString stringWithFormat:@"CATE_A_%02d", i + 1],
//                                       @"cateImageB":[NSString stringWithFormat:@"CATE_B_%02d", i + 1]}];
//    }
    
    [self requestModules];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"gotoCategory"])
    {
        WordsController *wordController = (WordsController *)[segue destinationViewController];
        wordController.categoryIndex = self.selectedIndex;
        wordController.moduleCode = [[self.categoryList objectAtIndex:self.selectedIndex] objectForKey:@"cateCode"];
        
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

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 在highlight时就先记录选择
    self.selectedIndex = indexPath.row;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    
    // 设置导航背景图片及过渡动画
//    NSString *headerImageName = [NSString stringWithFormat:@"CATE_HEADER_%02ld", (self.selectedIndex + 1)];
    NSString *headerImageName = [NSString stringWithFormat:@"CATE_HEADER_%02ld", self.categoryList.count - indexPath.row];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:headerImageName] forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - request net work

- (void) requestModules {
    
    NSString *opid = [Util generateUuid];
    NSString *userid = [DataUtil getDefaultUser];
    NSString *deviceId = [Util getUdid];
    NSDictionary *param = [NetParamFactory listParam:opid userid:userid device:deviceId page:0 size:0];
    
    [self.hud show:YES];
    
    NSLog(@"%@", URL_LIST);
    NSLog(@"%@", param);
    
    [NetManager postRequest:URL_LIST param:param success:^(id json){
        
        NSDictionary *dict = json;
        NSString *result = [dict objectForKey:@"result"];
        [self.hud hide:YES];
        
        NSLog(@"%@", dict);
        
        if (result && [result isEqualToString:@"1"]) {
            
            NSArray *data = [dict objectForKey:@"data"];
            if (data) {
                
                for (NSInteger i = 0; i < data.count; i ++) {
                    NSDictionary *category = [data objectAtIndex:i];
                    NSString *categoryName = [category objectForKey:@"name"];
                    NSString *categoryCode = [category objectForKey:@"cname"];
                    BOOL isLock = true;
                    if (![category objectForKey:@"lock"]) {
                        isLock = false;
                    }
                    [self.categoryList addObject:@{@"cateName":categoryName,
                                                   @"cateImageA":[NSString stringWithFormat:@"CATE_A_%02ld", (i%10) + 1],
                                                   @"cateImageB":[NSString stringWithFormat:@"CATE_B_%02ld", (i%10) + 1],
                                                   @"cateCode":categoryCode}];
                }
                [self.collectionView reloadData];
            
            
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无参数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络参数不对" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
        
    }fail:^ (){
        NSLog(@"fail ");
        
        [self.hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络参数不对" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
}

#pragma mark - Getter Method
- (NSMutableArray *) categoryList
{
    if (!_categoryList) {
        _categoryList = [NSMutableArray array];
    }
    return _categoryList;
}

- (MBProgressHUD *) hud {
    if (!_hud) {
        
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.color = [UIColor clearColor];//这儿表示无背景
        //显示的文字
        _hud.labelText = @"Test";
        //细节文字
        _hud.detailsLabelText = @"Test detail";
        //是否有庶罩
        _hud.dimBackground = YES;
        [self.navigationController.view addSubview:_hud];
    }
    return _hud;
}

@end
