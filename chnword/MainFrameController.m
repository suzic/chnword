//
//  MainFrameController.m
//  chnword
//
//  Created by 苏智 on 15/6/20.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "MainFrameController.h"
#import "DataUtil.h"

@interface MainFrameController ()

@property (strong, nonatomic) IBOutlet UIScrollView *pages;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

@end

@implementation MainFrameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 3;
    self.pages.contentSize = CGSizeMake(self.pages.bounds.size.width * 3, self.pages.bounds.size.height);
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    for (int i = 0; i < 3; i ++)
    {
        NSString *imageName = [NSString stringWithFormat:@"PageIntro%02d.png", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(i * width, 0, width, height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.pages addSubview:imageView];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 200, 100)];
    button.center = CGPointMake(2.5 * width, height - 100);
    button.backgroundColor = [UIColor greenColor];
    [button setImage:[UIImage imageNamed:@"btn_start.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.pages addSubview:button];
    
    [self showWelcome:NO];
    if ([DataUtil isFirstLogin])
        [self showWelcome:YES];
    else  if (![DataUtil getDefaultUser])
        [self showLoginView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoginView
{
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void)showWelcome:(BOOL)show
{
    self.pages.hidden = !show;
    self.pageControl.hidden = !show;
}

- (void)buttonClicked:(id) sender
{
    [self showWelcome:NO];
    if (![DataUtil getDefaultUser])
        [self showLoginView];
}

/**
 *  page control 值改变的控制方法
 */
- (IBAction)pageControlValueChanded:(id)sender
{
    NSInteger i = self.pageControl.currentPage;
    float width = self.pages.frame.size.width;
    self.pages.contentOffset = CGPointMake(i * width, 0);
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGRect screen = scrollView.frame;
    float width = screen.size.width;
    int i = (int)(scrollView.contentOffset.x + 1) / width;
    self.pageControl.currentPage = i;
}

@end
