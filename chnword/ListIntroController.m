//
//  ListIntroController.m
//  chnword
//
//  Created by 苏智 on 15/11/3.
//  Copyright © 2015年 Suzic. All rights reserved.
//

#import "ListIntroController.h"

@interface ListIntroController ()

@end

@implementation ListIntroController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return kScreenWidth * 485 / 1076;
        case 2:
            return kScreenWidth * 3 / 5;
        case 4:
            return kScreenWidth * 890 / 977 * 3 / 4;
        case 6:
            return kScreenWidth * 1167 / 1029;
        case 8:
            return kScreenWidth * 1453 / 861;
        default:
            return 35.0f;
    }
}

@end
