//
//  PlayController.m
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "PlayController.h"
#import "SvGifView.h"

@interface PlayController ()

@property (strong, nonatomic) IBOutlet UIWebView *webPlayer;
@property (strong, nonatomic) SvGifView *playViewer;
@property (assign, nonatomic) BOOL inPlaying;

@end

@implementation PlayController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.playViewer.hidden = YES;
    self.inPlaying = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"jiafei" withExtension:@"gif"];
    self.playViewer = [[SvGifView alloc] initWithCenter:self.webPlayer.center fileURL:fileUrl];
    self.playViewer.backgroundColor = [UIColor clearColor];
    self.playViewer.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:self.playViewer];

    [self playButtonPressed:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backward:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)playButtonPressed:(id)sender
{
    self.inPlaying = !self.inPlaying;
    if (self.inPlaying)
        [self.playViewer startGif];
    else
        [self.playViewer stopGif];
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
