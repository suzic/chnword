//
//  MainTabController.m
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "MainTabController.h"

@interface MainTabController ()

@end

@implementation MainTabController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 调整TabBar颜色
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont fontWithName:@"Libian SC" size:15.0], NSFontAttributeName, nil] forState:UIControlStateNormal];

    // 仅显示TabBar图片，枚举所有子项调整图片偏移位置
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        vc.title = nil;
        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // 如果需要调整TabBar高度则使用这部分代码

//    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
//    tabFrame.size.height = 60;
//    tabFrame.origin.y = self.view.frame.size.height - 60;
//    self.tabBar.frame = tabFrame;
    
    CGRect orgFrame = self.navigationController.navigationBar.frame;
    orgFrame.size.height = self.view.frame.size.width * 532 / 1440 - 20;
    [self.navigationController.navigationBar setFrame:orgFrame];
}

@end
