//
//  SampleController.m
//  chnword
//
//  Created by 苏智 on 15/10/27.
//  Copyright © 2015年 Suzic. All rights reserved.
//

#import "SampleController.h"
#import "AppDelegate.h"
#import "PlayController.h"
#import "NetParamFactory.h"
#import "NetManager.h"
#import "Util.h"
#import "DataUtil.h"
#import "MBProgressHUD.h"

@interface SampleController ()

@property (nonatomic, retain) MBProgressHUD *hud;
@property (assign, nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) IBOutlet UIView *SplitBar;
@property (strong, nonatomic) IBOutlet UILabel *categoryName;
@property (strong, nonatomic) IBOutlet UIImageView *freeWordBG;
@property (strong, nonatomic) IBOutlet UIButton *freeWord;
@property (strong, nonatomic) IBOutlet UIImageView *freeWordMoreBG;
@property (strong, nonatomic) IBOutlet UIButton *freeWordMore;
@property (strong, nonatomic) IBOutlet UIImageView *shareTip;
@property (strong, nonatomic) IBOutlet UILabel *shareInfo;

@end

@implementation SampleController

// 初始化数据，主要是名称和UI的固定设置初始化
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.SplitBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"GraphicLine"]];
    self.categoryName.text = [NSString stringWithFormat:@"《%@》", self.cateName];
    self.navigationItem.title = self.cateName;
    self.navigationItem.backBarButtonItem.title = @"";
    
    // 设置背景图片
    NSString *bgImageName = [NSString stringWithFormat:@"CATE_BG_%02d", (int)(self.categoryIndex + 1)];
    [self.backgroundImage setImage:[UIImage imageNamed:bgImageName]];
    
    NSString *headerImageName = [NSString stringWithFormat:@"CATE_HEADER_%02d", (int)(self.categoryIndex + 1)];
    [self.headerImage setImage:[UIImage imageNamed:headerImageName]];
}

// 处理免费数据的初始化
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupSampleData];
}

// 显示完成的处理
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

// 在该界面下，如果选择获取用户码，直接进入登陆界面。
- (IBAction)shopBuyCategory:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowLogin object:self];
}

// 设置体验数据
- (void)setupSampleData
{
    AppDelegate* appDelegate = [AppDelegate sharedDelegate];
    if (self.categoryIndex == 0)
    {
#warning 这里默认天文组数据是解锁更多的状态，其他则是最小体验状态。该数据应当从本地配置文件进行存储和读取。
        // 根据配置文件决定显示内容
        NSInteger findCount = 0;
        NSInteger count = appDelegate.wordInTianWen.count;
        for (int i = 0; i < count; i++)
        {
            if (findCount == 0 && [appDelegate.wordInTianWenDemo[i] isEqualToString:@"1"])
            {
                findCount++;
                [self.freeWord setTitle:appDelegate.wordInTianWen[i] forState:UIControlStateNormal];
#warning 将wordCode作为Tag写进字按钮
                [self.freeWord setTag:0];
                [self.freeWord setEnabled:YES];
            }
            else
            {
                self.unlockMore = YES;
                [self.freeWordMore setTitle:appDelegate.wordInTianWen[i] forState:UIControlStateNormal];
#warning 将wordCode作为Tag写进字按钮
                [self.freeWordMore setTag:0];
                [self.freeWordMore setEnabled:YES];
            }
        }
    }
    else
        self.unlockMore = NO;
    
    [self setupUnlockStyle];
}

// 解锁更多项目与否对UI界面的影响（是否显示第二个免费体验字并对应隐藏分享提示信息等
- (void)setupUnlockStyle
{
    if (self.unlockMore)
    {
        self.freeWordMoreBG.hidden = NO;
        self.freeWordMore.hidden = NO;
        self.shareInfo.hidden = YES;
        self.shareTip.hidden = YES;
    }
    else
    {
        self.freeWordMoreBG.hidden = YES;
        self.freeWordMore.hidden = YES;
        self.shareInfo.hidden = NO;
        self.shareTip.hidden = NO;
    }
}

// 点击第一个免费体验字
- (IBAction)pressFree:(id)sender
{
    [self showWordPlayer:[NSString stringWithFormat:@"%ld", (long)self.freeWord.tag]];
}

// 点击第二个免费体验字
- (IBAction)pressFreeMore:(id)sender
{
    [self showWordPlayer:[NSString stringWithFormat:@"%ld", (long)self.freeWordMore.tag]];
}

- (IBAction)showList:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowList object:self];
}

// 导航至汉字页面
- (void)showWordPlayer:(NSString*)wordCode
{
    PlayController *player = (PlayController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PlayController"];
#warning 这里的文件Url，出于测试目的，先写了一个；正式联网场合下不应该写默认值
    player.fileUrl = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];
    player.wordCode = wordCode;
    [self.navigationController pushViewController:player animated:YES];
}

@end
