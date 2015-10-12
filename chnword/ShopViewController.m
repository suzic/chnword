//
//  ShopViewController.m
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "ShopViewController.h"

@interface ShopViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *segmentPicture;
@property (strong, nonatomic) IBOutlet UIView *page00;
@property (strong, nonatomic) IBOutlet UIView *page01;
@property (strong, nonatomic) IBOutlet UIView *page02;

@end

@implementation ShopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segementChanged:(id)sender
{
    self.page00.hidden = YES;
    self.page01.hidden = YES;
    self.page02.hidden = YES;
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    switch (segment.selectedSegmentIndex)
    {
        case 0:
            [self.segmentPicture setImage:[UIImage imageNamed:@"Shop00"]];
            self.page00.hidden = NO;
            break;
        case 1:
            [self.segmentPicture setImage:[UIImage imageNamed:@"Shop01"]];
            self.page01.hidden = NO;
            break;
        case 2:
        default:
            [self.segmentPicture setImage:[UIImage imageNamed:@"Shop02"]];
            self.page02.hidden = NO;
            break;
    }
}

@end
