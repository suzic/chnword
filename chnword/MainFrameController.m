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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWelcome:) name:NotiShowWelcome object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginView:) name:NotiShowLogin object:nil];
    
    if ([DataUtil isFirstLogin])
        [self showWelcome:nil];
    else if ( [@"0" isEqualToString:[DataUtil getDefaultUser]])
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
    if (notification)
    {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    else
    {
        if (self.welcomeView.hidden == YES)
            [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

- (void)showWelcome:(NSNotification *)notification
{
    self.welcomeView.hidden = NO;
    [UIView animateWithDuration:0.5f animations:^{
        self.welcomeView.alpha = 1.0f;
    }];
}

- (void)buttonClicked:(id) sender
{
    [UIView animateWithDuration:0.5f animations:^{
        self.welcomeView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.welcomeView.hidden = YES;
        if (![DataUtil getDefaultUser])
            [self showLoginView:nil];
    }];
}

- (void)setupPages
{
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    NSLog(@"%@", NSStringFromCGRect([UIScreen mainScreen].bounds));

    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 4;
    self.pages.contentSize = CGSizeMake(width * 4 + 100, height);
    
    for (int i = 0; i < 4; i ++)
    {
        NSString *imageName = [NSString stringWithFormat:@"PageIntro%02d", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(i * width, 0, width, height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.pages addSubview:imageView];
        
        if (i == 3)
        {
            // 引导页最后的一页的点击即关闭
            UITapGestureRecognizer *hiddenWelcomeImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClicked:)];
            [imageView addGestureRecognizer:hiddenWelcomeImage];
            hiddenWelcomeImage.numberOfTapsRequired = 1;
        }
    }
}

- (IBAction)pageControlValueChanged:(id)sender
{
    NSInteger i = self.pageControl.currentPage;
    float width = self.pages.frame.size.width;
    self.pages.contentOffset = CGPointMake(i * width, 0);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGRect screen = scrollView.frame;
    float width = screen.size.width;
    int i = (int)((scrollView.contentOffset.x) / width);
    self.pageControl.currentPage = i;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((scrollView.contentOffset.x - kScreenWidth * 3) > 20)
    {
        //向右轻扫做的事情
        [self buttonClicked:nil];
    }
}

@end
