//
//  WordsController.m
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "AppDelegate.h"
#import "WordsController.h"
#import "PlayController.h"
#import "NetParamFactory.h"
#import "NetManager.h"
#import "Util.h"
#import "DataUtil.h"
#import "MBProgressHUD.h"

@interface WordsController ()

@property (strong, nonatomic) NSMutableArray *wordsList;

@property (nonatomic, retain) MBProgressHUD *hud;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation WordsController

static NSString * const reuseIdentifier = @"WordCell";

// 初始化界面元素
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.navigationItem.title = self.cateName;
    self.navigationItem.backBarButtonItem.title = @"";
    
    // 设置背景图片
    NSString *bgImageName = [NSString stringWithFormat:@"CATE_BG_%02d", (int)(self.categoryIndex + 1)];
    [self.backgroundImage setImage:[UIImage imageNamed:bgImageName]];
}

// 界面显示时更新分类列表。
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupWordsList];
}

// 初始化分类列表
- (void)setupWordsList
{
    [self requestWordsList:self.moduleCode];
}

#pragma mark - Navigation

// 导航准备
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPlay"])
    {
#warning 这里设置正确的播放动画资源
        
        if ([@"0" isEqualToString:[DataUtil getDefaultUser]])
        {
            if (self.selectedIndex < 2) {
                PlayController *player = (PlayController *)[segue destinationViewController];
                //        player.fileUrl = [[NSBundle mainBundle] URLForResource:@"jiafei" withExtension:@"gif"];
                player.wordCode = [[self.wordsList objectAtIndex: self.selectedIndex] objectForKey:@"wordCode"];
                player.canShare = YES;
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"默认用户只能查看第一条数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }
        else
        {
            PlayController *player = (PlayController *)[segue destinationViewController];
            //        player.fileUrl = [[NSBundle mainBundle] URLForResource:@"jiafei" withExtension:@"gif"];
            player.wordCode = [[self.wordsList objectAtIndex: self.selectedIndex] objectForKey:@"wordCode"];
            if (self.selectedIndex < 2) {
                player.canShare = YES;
            }
        }
    }
}

#pragma mark - UICollection View DataSource & Delegate

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
    NSString *wordName = [[self.wordsList objectAtIndex: indexPath.row] objectForKey:@"wordName"];
    cell.wordNameLabel.text = wordName;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;
    
    if ([@"0" isEqualToString:[DataUtil getDefaultUser]])
    {
        PlayController *player = (PlayController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PlayController"];
        //player.fileUrl = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];
        player.wordCode = [[self.wordsList objectAtIndex: self.selectedIndex] objectForKey:@"wordCode"];
        [self.navigationController pushViewController:player animated:YES];
    }
    else
    {
        PlayController *player = (PlayController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PlayController"];
        //player.fileUrl = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];
        player.wordCode = [[self.wordsList objectAtIndex: self.selectedIndex] objectForKey:@"wordCode"];
    }
}

#pragma mark - net request

// 测试：直接写天文分类的字列表
- (void)setupTianWenWords
{
    AppDelegate* appDelegate = [AppDelegate sharedDelegate];
    [self.wordsList removeAllObjects];
    for (NSString *word in appDelegate.wordInTianWen)
    {
        [self.wordsList addObject:@{@"wordName":word,
                                    @"lockStatus":@"1",
                                    @"wordImageA":@"",
                                    @"wordImageB":@"",
                                    @"wordCode": @"0"}];
    }
    [self.collectionView reloadData];
}

#warning TO DO
// 请求一个具体的字信息
- (void)requestWord:(NSString *)word
{
    NSDictionary *param = [NetParamFactory wordParam:[Util generateUuid] userid:@"1" device:@"1" word:@"1"];
    
    NSLog(@"%@", URL_SHOW);
    NSLog(@"%@", param);
    
    [self.hud show:YES];
    [NetManager postRequest:URL_SHOW param:param success:^(id json){
        
        NSLog(@"success with json: %@", json);
        NSDictionary *dict = json;
        
        [self.hud hide:YES];
        
        if (dict)
        {
            NSString *result = [dict objectForKey:@"result"];
            
            if ([result isEqualToString:@"1"]) {
                NSDictionary *data = [dict objectForKey:@"data"];
                
                NSString *videoUrl = [data objectForKey:@"video"];
                NSString *gifUrl = [data objectForKey:@"gif"];
                // self.mediaPlayer.contentURL = [NSURL URLWithString:videoUrl];
                // [self.mediaPlayer play];
                
                // 视图显示后开始设置GIF动画并自动执行
                
//                if ([gifUrl containsString:@"http"]) {
//                    self.playViewer = [[GIFPlayer alloc] initWithCenter:self.framePlayer.center fileURL:[NSURL URLWithString:gifUrl]];
//                    NSString *message = [NSString stringWithFormat:@"无效的url: \n%@\n%@", gifUrl, videoUrl];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                    [alert show];
//                } else {
//                    self.playViewer = [[GIFPlayer alloc] initWithCenter:self.framePlayer.center fileURL:self.fileUrl];
//                    
//                }
//                
//                self.playViewer.backgroundColor = [UIColor clearColor];
//                self.playViewer.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//                [self.view addSubview:self.playViewer];
            }else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
            
        } else {
            [self.hud hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
    }fail:^ (){
        NSLog(@"fail ");
        [self.hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
}

#warning TO DO
// 请求当前的字列表
- (void)requestWordsList:(NSString *) moduleCode
{
    NSString *opid = [Util generateUuid];
    NSString *userid = [DataUtil getDefaultUser];
    NSString *deviceId = [Util getUdid];
    
    NSString *str = moduleCode;
    
    NSDictionary *param = [NetParamFactory subListParam:opid userid:userid device:deviceId zone:str page:0 size:0];
    
    [self.hud show:YES];
    
    NSLog(@"%@", URL_SUBLIST);
    NSLog(@"%@", param);
    [NetManager postRequest:URL_SUBLIST param:param success:^(id json){
        
        NSLog(@"%@", json);
        
        NSDictionary *dict = json;
        NSString *result = [dict objectForKey:@"result"];
        [self.hud hide:YES];
        if (result && [result isEqualToString:@"1"]) {
            
            NSArray *data = [dict objectForKey:@"data"];
            if (data) {
                
                for (NSInteger i = 0; i < data.count; i ++) {
                    
                    NSDictionary *word = [data objectAtIndex:i];
                    NSString *wordName = [word objectForKey:@"word"];
                    NSString *wordCode = [word objectForKey:@"unicode"];
                    
                    [self.wordsList addObject:@{@"wordName":wordName,
                                                @"lockStatus":@"1",
                                                @"wordImageA":[NSString stringWithFormat:@"CATE_A_%02d", i + 1],
                                                @"wordImageB":[NSString stringWithFormat:@"CATE_B_%02d", i + 1],
                                                @"wordCode": wordCode}];
                }
                
                //[self.collectionView reloadData];
                
            } else  {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无结果返回" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
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

- (MBProgressHUD *)hud
{
    if (!_hud)
    {
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

- (NSMutableArray *)wordsList
{
    if (!_wordsList)
        _wordsList = [NSMutableArray array];
    return _wordsList;
}

@end
