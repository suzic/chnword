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
@property (strong, nonatomic) IBOutlet UILabel *freeWord;
@property (strong, nonatomic) IBOutlet UIImageView *freeWordMoreBG;
@property (strong, nonatomic) IBOutlet UILabel *freeWordMore;

@property (strong, nonatomic) IBOutlet UIImageView *shareTip;
@property (strong, nonatomic) IBOutlet UILabel *shareInfo;

@end

@implementation SampleController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.unlockMore = NO;
    self.SplitBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"GraphicLine"]];
    self.categoryName.text = [NSString stringWithFormat:@"《%@》", self.cateName];
    self.navigationItem.title = self.cateName;
    
    // 设置背景图片
    NSString *bgImageName = [NSString stringWithFormat:@"CATE_BG_%02d", (int)(self.categoryIndex + 1)];
    [self.backgroundImage setImage:[UIImage imageNamed:bgImageName]];
    
    NSString *headerImageName = [NSString stringWithFormat:@"CATE_HEADER_%02d", (int)(self.categoryIndex + 1)];
    [self.headerImage setImage:[UIImage imageNamed:headerImageName]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)shopBuyCategory:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowLogin object:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
