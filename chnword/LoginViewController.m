//
//  LoginViewController.m
//  chnword
//
//  Created by 苏智 on 15/6/20.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *userCodeInput;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *trialButtonWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *loginButtonWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inputCodeBottomWidth;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat screenHeight = self.view.frame.size.height;
    self.trialButtonWidth.constant = screenWidth;
    self.loginButtonWidth.constant = screenWidth - 20;
    self.inputCodeBottomWidth.constant = screenWidth - 60;
    
    [super viewWillLayoutSubviews];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)trailButtonPressed:(id)sender
{
}

- (IBAction)loginButtonPressed:(id)sender
{
}

@end
