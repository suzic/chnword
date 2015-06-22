//
//  MainFrameController.m
//  chnword
//
//  Created by 苏智 on 15/6/20.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "MainFrameController.h"
#import "NSObject+Delay.h"
#import "DataUtil.h"

@interface MainFrameController ()

@property (strong, nonatomic) IBOutlet UIView *welcomeView;
@property (strong, nonatomic) IBOutlet UIScrollView *pages;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

@end

@implementation MainFrameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPages];
    self.welcomeView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWelcome:) name:NotiShowWelcome object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginView:) name:NotiShowLogin object:nil];
    
    if ([DataUtil isFirstLogin])
        [self showWelcome:nil];
    else if (![DataUtil getDefaultUser])
        [self performBlock:^{ [self showLoginView:nil]; } afterDelay:0.5];
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
}

- (void)showLoginView:(NSNotification *)notification
{
    if (self.welcomeView.hidden == YES)
        [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void)showWelcome:(NSNotification *)notification
{
    self.welcomeView.hidden = NO;
}

- (void)buttonClicked:(id) sender
{
    self.welcomeView.hidden = YES;
    if (![DataUtil getDefaultUser])
        [self showLoginView:nil];
}

- (void)setupPages
{
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;

    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 3;
    self.pages.contentSize = CGSizeMake(width * 3, height);
    
    for (int i = 0; i < 3; i ++)
    {
        NSString *imageName = [NSString stringWithFormat:@"PageIntro%02d", i + 1];
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
    [button setTitle:@"进入三千字的世界" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.pages addSubview:button];
}

- (IBAction)pageControlValueChanged:(id)sender
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
    int i = (int)((scrollView.contentOffset.x) / width);
    self.pageControl.currentPage = i;
}

@end
