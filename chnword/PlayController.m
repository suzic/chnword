//
//  PlayController.m
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "PlayController.h"
#import "GIFPlayer.h"

@interface PlayController ()

@property (strong, nonatomic) IBOutlet UIView *framePlayer;
@property (strong, nonatomic) UIImageView *frameViewer;
@property (strong, nonatomic) GIFPlayer *playViewer;
@property (assign, nonatomic) BOOL inPlaying;

@property (strong, nonatomic) NSArray *framesArray;

@property (strong, nonatomic) IBOutlet UIButton *playAndStopButton;
@property (strong, nonatomic) IBOutlet UIButton *prevButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UISlider *progressSlider;

@end

@implementation PlayController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 设置播放控件
    self.framesArray = [GIFPlayer framesInGif:self.fileUrl];
    self.progressSlider.minimumValue = 0;
    self.progressSlider.maximumValue = self.framesArray.count - 1;
    self.progressSlider.value = 0;
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
    
    // 设置图片模式的播放
    if (self.framesArray != nil && self.framesArray.count > 0)
    {
        self.frameViewer = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:(CGImageRef)self.framesArray[0]]];
        self.frameViewer.center = self.framePlayer.center;
        [self.view addSubview:self.frameViewer];
    }

    // 视图显示后开始设置GIF动画并自动执行
    self.playViewer = [[GIFPlayer alloc] initWithCenter:self.framePlayer.center fileURL:self.fileUrl];
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

#pragma mark - Animation Controls

// 帧控制
- (IBAction)gotoFrame:(id)sender
{
    int currentIndex = (int)self.progressSlider.value;
    [self.frameViewer setImage:[UIImage imageWithCGImage:(CGImageRef)self.framesArray[currentIndex]]];
}

// 下一帧
- (IBAction)frameNext:(id)sender
{
    if (self.progressSlider.value <= self.progressSlider.maximumValue - 1)
    {
        [self.progressSlider setValue:(self.progressSlider.value + 1)];
        [self gotoFrame:nil];
    }
}

// 上一帧
- (IBAction)framePrev:(id)sender
{
    if (self.progressSlider.value >= self.progressSlider.minimumValue + 1)
    {
        [self.progressSlider setValue:(self.progressSlider.value - 1)];
        [self gotoFrame:nil];
    }
}

// 播放或停止
- (IBAction)playButtonPressed:(id)sender
{
    self.inPlaying = !self.inPlaying;
    if (self.inPlaying)
        [self.playViewer startGif:self];
    else
        [self.playViewer stopGif];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    self.progressSlider.value = 0;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.inPlaying = NO;
}

// 根据播放状态选择控制按钮的显示
- (void)setInPlaying:(BOOL)inPlaying
{
    if (_inPlaying != inPlaying)
    {
        _inPlaying = inPlaying;
        [self.playAndStopButton setTitle:inPlaying ? @"停止" : @"播放"
                                forState:UIControlStateNormal];
        
        self.prevButton.hidden = _inPlaying;
        self.nextButton.hidden = _inPlaying;
        self.progressSlider.hidden = _inPlaying;
    }
}

@end
