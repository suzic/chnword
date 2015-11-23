//
//  CategoriesController.m
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "AppDelegate.h"
#import "ShopAnimeController.h"
#import "CategoriesController.h"
#import "WordsController.h"
#import "SampleController.h"
#import "NetManager.h"
#import "NetParamFactory.h"
#import "Util.h"
#import "DataUtil.h"
#import "MBProgressHUD.h"

@interface CategoriesController () <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *categoryList;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation CategoriesController

static NSString * const reuseIdentifier = @"CategoryCell";

// 初始化UI元素, 根据付费、免费用户（isLogin == NO)，显示不同的布局
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedIndex = NSNotFound;
    AppDelegate* appDelegate = [AppDelegate sharedDelegate];
    self.navigationItem.title = appDelegate.isLogin ? @"三千字课体系" : @"免费体验";
    self.navigationItem.backBarButtonItem.title = @"";
}

// 显示界面时调用初始化分类列表功能，创造两个不同的界面
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

// 显示界面时调用初始化分类列表功能，创造两个不同的界面
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupCategroyList];
}

// 初始化分类列表，根据付费、免费用户进行区分，设置初始数据。collectionView重建时将用到这些数据。
- (void)setupCategroyList
{
    [self requestModules];
}

- (void)updateCategoryList
{
    AppDelegate* appDelegate = [AppDelegate sharedDelegate];
    self.categoryList = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 10; i++)
    {
        if (appDelegate.isLogin)
        {
            [self.categoryList addObject:@{@"cateName":appDelegate.cateNames[i],
                                           @"cateUnlocked":appDelegate.cateUnlocked[i],
                                           @"cateImageA":[NSString stringWithFormat:@"CATE_L_%02d", i + 1],
                                           @"cateImageB":[NSString stringWithFormat:@"CATE_U_%02d", i + 1]}];
        }
        else
        {
            [self.categoryList addObject:@{@"cateName":appDelegate.cateNames[i],
                                           @"cateImageA":[NSString stringWithFormat:@"CATE_A_%02d", i + 1],
                                           @"cateImageB":[NSString stringWithFormat:@"CATE_B_%02d", i + 1]}];
        }
    }
}

#pragma mark - Navigation

// 导航到付费或免费用户的二级页面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goCategory"])
    {
        WordsController *wordController = (WordsController *)[segue destinationViewController];
        wordController.categoryIndex = self.selectedIndex;
        wordController.moduleCode = [[self.categoryList objectAtIndex:self.selectedIndex] objectForKey:@"cateCode"];
        wordController.cateName = [[self.categoryList objectAtIndex:self.selectedIndex] objectForKey:@"cateName"];
    }
    else
    {
        SampleController *sampleController = (SampleController *)[segue destinationViewController];
        sampleController.categoryIndex = self.selectedIndex;
        sampleController.moduleCode = [[self.categoryList objectAtIndex:self.selectedIndex] objectForKey:@"cateCode"];
        sampleController.cateName = [[self.categoryList objectAtIndex:self.selectedIndex] objectForKey:@"cateName"];
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
    
    AppDelegate* appDelegate = [AppDelegate sharedDelegate];
    if (appDelegate.isLogin)
    {
        if ([cateDic[@"cateUnlocked"] isEqualToString:@"0"])
            [cell.categoryImage setImage:[UIImage imageNamed:cateDic[@"cateImageA"]]];
        else
            [cell.categoryImage setImage:[UIImage imageNamed:cateDic[@"cateImageB"]]];
        [cell.categoryImage setHighlightedImage:nil];
    }
    else
    {
        [cell.categoryImage setImage:[UIImage imageNamed:cateDic[@"cateImageA"]]];
        [cell.categoryImage setHighlightedImage:[UIImage imageNamed:cateDic[@"cateImageB"]]];
    }
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
    
    AppDelegate* appDelegate = [AppDelegate sharedDelegate];
    if (appDelegate.isLogin)
    {
        NSDictionary *cateDic = self.categoryList[indexPath.row];
        if ([cateDic[@"cateUnlocked"] isEqualToString:@"0"])
            [self gotoShopBuy:indexPath.row];
        else
            [self performSegueWithIdentifier:@"goCategory" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"goSample" sender:self];
    }
}

#pragma mark - User actions

- (IBAction)showList:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowList object:self];
}

// 提示进入商店
- (void)gotoShopBuy:(NSInteger)categoryIndex
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"该分组未解锁"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"查看免费体验字课"
                                          otherButtonTitles:@"购买该分类", nil];
    [alert show];
}

// 对提示进入商店的结果响应
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self performSegueWithIdentifier:@"goSample" sender:self];
    }
    else
    {
        UINavigationController *navi = (UINavigationController *) [self.storyboard instantiateViewControllerWithIdentifier:@"buyCategory"];
        ShopAnimeController* shop = (ShopAnimeController*)[navi topViewController];
        shop.selectedCategory = self.selectedIndex;
        [self presentViewController:navi animated:YES completion:^{
        }];
    }
}

#pragma mark - request net work

- (void)requestModules
{
    AppDelegate* appDelegate = [AppDelegate sharedDelegate];

    NSString *opid = [Util generateUuid];
    NSString *userid = [DataUtil getDefaultUser];
    NSString *deviceId = [Util getUdid];
    NSDictionary *param = [NetParamFactory listParam:opid userid:userid device:deviceId page:0 size:12];
    
    [self.hud show:YES];
    
    NSLog(@"%@", URL_LIST);
    NSLog(@"%@", param);
    
    [NetManager postRequest:URL_LIST param:param success:^(id json){
        
        NSDictionary *dict = json;
        NSString *result = [dict objectForKey:@"result"];
        [self.hud hide:YES];
        NSLog(@"%@", dict);
        
        if (result && [result isEqualToString:@"1"])
        {
            NSArray *data = [dict objectForKey:@"data"];
            if (data)
            {
                [self.categoryList removeAllObjects];
                
                for (NSInteger i = 0; i < data.count; i ++)
                {
                    NSDictionary *category = [data objectAtIndex:i];
                    NSString *categoryName = [category objectForKey:@"name"];
                    NSString *categoryCode = [category objectForKey:@"cname"];
                    NSString *categoryUnlocked = ((int)[category objectForKey:@"lock"] == 1) ? @"0" : @"1";

                    if (appDelegate.isLogin)
                    {
                        [self.categoryList addObject:@{@"cateName":categoryName,
                                                       @"cateUnlocked":categoryUnlocked,
                                                       @"cateCode":categoryCode,
                                                       @"cateImageA":[NSString stringWithFormat:@"CATE_L_%02d", i + 1],
                                                       @"cateImageB":[NSString stringWithFormat:@"CATE_U_%02d", i + 1]}];
                    }
                    else
                    {
                        [self.categoryList addObject:@{@"cateName":categoryName,
                                                       @"cateCode":categoryCode,
                                                       @"cateImageA":[NSString stringWithFormat:@"CATE_A_%02d", i + 1],
                                                       @"cateImageB":[NSString stringWithFormat:@"CATE_B_%02d", i + 1]}];
                    }
                }
                [self.collectionView reloadData];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无参数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络参数不对" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    } fail:^ (){
        NSLog(@"fail ");
        
        [self.hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络参数不对" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
}

#pragma mark - Getter Method

- (NSMutableArray *)categoryList
{
    if (!_categoryList) {
        _categoryList = [NSMutableArray array];
    }
    return _categoryList;
}

- (MBProgressHUD *)hud
{
    if (!_hud)
    {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.color = [UIColor clearColor];//这儿表示无背景
        //显示的文字
        _hud.labelText = @"正在加载";
        //细节文字
        _hud.detailsLabelText = @"";//@"Test detail";
        //是否有庶罩
        _hud.dimBackground = YES;
        [self.navigationController.view addSubview:_hud];
    }
    return _hud;
}

@end
