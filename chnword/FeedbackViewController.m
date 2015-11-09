//
//  FeedbacjViewController.m
//  chnword
//
//  Created by khtc on 15/8/22.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "FeedbackViewController.h"

#import "MBProgressHUD.h"


@interface FeedbackViewController () <UIAlertViewDelegate>

@property (nonatomic, retain) MBProgressHUD *hud;
@property (strong, nonatomic) IBOutlet UIView *resultView;
@property (strong, nonatomic) IBOutlet UIView *resultBg;

@end

@implementation FeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.resultBg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ErrorBG"]]];
}

- (IBAction)submitFeedBack:(id)sender
{
    //[self showSuccess:YES];
    [self showSimpleSuccess];

#warning 提交feedBack，提交成功，回退，否则，不回退。
    //[self.hud show:YES];
    //[self.hud hide:YES];
}

- (void)showSimpleSuccess
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"反馈提交成功"
                                                    message:@"您的意见就是我们改进的动力，谢谢支持！"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showSuccess:(BOOL)show
{
    CGRect hidePos = CGRectMake(0, kScreenHeight, kScreenWidth, 320);
    CGRect showPos = CGRectMake(0, kScreenHeight - 320, kScreenWidth, 320);

    if (show)
    {
        self.resultView.hidden = NO;
        self.resultView.alpha = 0;
        self.resultBg.frame = hidePos;
        
        [UIView animateWithDuration:0.2f animations:^{
            self.resultView.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3f animations:^{
                [self.resultBg setFrame:showPos];
            } completion:nil];
        }];
    }
    else
    {
        self.resultView.hidden = NO;
        self.resultView.alpha = 1;
        self.resultBg.frame = showPos;

        [UIView animateWithDuration:0.3f animations:^{
            [self.resultBg setFrame:hidePos];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f animations:^{
                self.resultView.alpha = 0;
            } completion:^(BOOL finished) {
                self.resultView.hidden = YES;
            }];
        }];

    }
}

- (IBAction)hideResult:(id)sender
{
    [self showSuccess:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -getter

- (MBProgressHUD *) hud
{
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
