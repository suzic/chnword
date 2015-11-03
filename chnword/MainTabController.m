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

// Tab控制器的初始化，置入一些自定义外观、自动跳转事件监听的内容
- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showShop:) name:NotiShowShop object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showShop:) name:NotiShowShopSuit object:nil];

    // 调整TabBar颜色
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont fontWithName:@"Libian SC" size:15.0], NSFontAttributeName, nil] forState:UIControlStateNormal];

    // 仅显示TabBar图片，枚举所有子项调整图片偏移位置
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }];
}

// 直接进入商店Tab的方法
- (void)showShop:(NSNotification *)notification
{
    self.selectedIndex = 1;
}

@end
