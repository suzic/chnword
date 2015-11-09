//
//  ShopConfirmController.m
//  chnword
//
//  Created by 苏智 on 15/11/8.
//  Copyright © 2015年 Suzic. All rights reserved.
//

#import "ShopConfirmController.h"

@interface ShopConfirmController ()

@property (strong, nonatomic) IBOutlet UIView *orderPane;
@property (strong, nonatomic) IBOutlet UIView *methodPane;

@end

@implementation ShopConfirmController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.orderPane.layer.cornerRadius = 5.0f;
    self.methodPane.layer.cornerRadius = 5.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
