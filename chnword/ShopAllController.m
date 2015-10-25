//
//  ShopAllController.m
//  chnword
//
//  Created by 苏智 on 15/10/26.
//  Copyright © 2015年 Suzic. All rights reserved.
//

#import "ShopAllController.h"

@interface ShopAllController ()

@end

@implementation ShopAllController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buyAll:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"购买全套字课"
                                                    message:@"等于购买分类字课中的全部"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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
