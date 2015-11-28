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
@property (strong, nonatomic) NSMutableArray *wordsList;

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
    [self requestWordsList:self.moduleCode];
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
#warning 根据配置文件决定显示内容。这里，unlockMore的数据来源需要读配置完成
    self.unlockMore = NO;
    
    NSInteger findCount = 0;
    NSInteger count = self.wordsList.count;
    for (int i = 0; i < count; i++)
    {
        NSDictionary* word = self.wordsList[i];
        if ([word[@"free"] intValue] != 0)
            continue;
        UIImageView *wordImage = [[UIImageView alloc] init];
        [wordImage sd_setImageWithURL:[NSURL URLWithString:word[@"wordImage"]]];

        if (findCount == 0)
        {
            findCount++;
            [self.freeWord setImage:wordImage.image forState:UIControlStateNormal];
            [self.freeWord setTitle:word[@"wordName"] forState:UIControlStateNormal];
            [self.freeWord setTag:[word[@"wordCode"] intValue]];
            [self.freeWord setEnabled:YES];
        }
        else if (self.unlockMore)
        {
            [self.freeWord setImage:wordImage.image forState:UIControlStateNormal];
            [self.freeWord setTitle:word[@"wordName"] forState:UIControlStateNormal];
            [self.freeWordMore setTag:[word[@"wordCode"] intValue]];
            [self.freeWordMore setEnabled:YES];
        }
    }

    [self setupUnlockStyle];
}

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
    [NetManager postRequest:URL_SUBLIST param:param success:^(id json)
    {
        
        NSLog(@"%@", json);
        
        NSDictionary *dict = json;
        NSString *result = [dict objectForKey:@"result"];
        [self.hud hide:YES];
        if (result && [result isEqualToString:@"1"])
        {
            NSArray *data = [dict objectForKey:@"data"];
            if (data != nil && [data isKindOfClass:[NSArray class]])
            {
                for (NSInteger i = 0; i < data.count; i ++)
                {
                    NSDictionary *word = [data objectAtIndex:i];
                    [self.wordsList addObject:@{@"wordName":word[@"word"],
                                                @"free":word[@"free"],
                                                @"wordImage":word[@"icon"],
                                                @"wordCode": word[@"unicode"]}];
                }
                [self setupSampleData];
            }
            else
            {
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
    //player.fileUrl = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];
    player.wordCode = wordCode;
    [self.navigationController pushViewController:player animated:YES];
}

- (NSMutableArray *)wordsList
{
    if (!_wordsList)
        _wordsList = [NSMutableArray array];
    return _wordsList;
}

@end
