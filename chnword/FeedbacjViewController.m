//
//  FeedbacjViewController.m
//  chnword
//
//  Created by khtc on 15/8/22.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "FeedbacjViewController.h"

#import "MBProgressHUD.h"


@interface FeedbacjViewController ()

@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation FeedbacjViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction) submitFeedBack:(id)sender
{
    //提交feedBack，提交成功，回退，否则，不回退。
    
    [self.hud show:YES];
    
    
    [self.hud hide:YES];
    
    
}

#pragma mark -getter

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
