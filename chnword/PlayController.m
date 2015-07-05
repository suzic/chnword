//
//  PlayController.m
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "PlayController.h"
#import "GIFPlayer.h"

#import "NetParamFactory.h"
#import "NetManager.h"
#import "Util.h"
#import "DataUtil.h"
#import "MBProgressHUD.h"
#import "SDWebImageManager.h"

#import "UIImage+GIF.h"
#import <MediaPlayer/MediaPlayer.h>



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

@property (nonatomic, retain) MBProgressHUD *hud;

@property (nonatomic, retain) NSString *videoUrl;
@property (nonatomic, retain) NSString *gifUrl;
@property (nonatomic, retain) MPMoviePlayerViewController * moviePlayerView;

@end

@implementation PlayController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 设置播放控件
//    self.framesArray = [GIFPlayer framesInGif:self.fileUrl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(playingDone) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
//    self.frameViewer = [[UIImageView alloc] init];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
//    self.frameViewer.center = self.framePlayer.center;
//    self.frameViewer.backgroundColor = [UIColor redColor];
//    
//    
//    [self.view addSubview:self.frameViewer];
//    
//    self.playViewer.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    [self.view addSubview:self.playViewer];
    
    [self requestWord:self.wordCode];
    
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

- (IBAction) playVideo:(id)sender
{
    if (self.videoUrl) {
        NSURL *url = [NSURL URLWithString:self.videoUrl];
        self.moviePlayerView = [[MPMoviePlayerViewController alloc]
                                                         initWithContentURL:url];
        
        self.moviePlayerView.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
        self.moviePlayerView.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.moviePlayerView.view];
    }
}

- (void) playingDone {
    NSLog(@"播放完成");
    [self.moviePlayerView.view removeFromSuperview];
    self.moviePlayerView = nil;
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

#pragma mark - net request
- (void) requestWord:(NSString *) word
{
    NSDictionary *param = [NetParamFactory wordParam:[Util generateUuid] userid:@"1" device:@"1" word:@"1"];
    
    NSLog(@"%@", URL_SHOW);
    NSLog(@"%@", param);
    
    [self.hud show:YES];
    [NetManager postRequest:URL_SHOW param:param success:^(id json){
        
        NSLog(@"success with json: %@", json);
        NSDictionary *dict = json;
        
        [self.hud hide:YES];
        
        if (dict) {
            NSString *result = [dict objectForKey:@"result"];
            
            if ([result isEqualToString:@"1"]) {
                NSDictionary *data = [dict objectForKey:@"data"];
                
                NSString *video = [data objectForKey:@"video"];
                NSString *gif = [data objectForKey:@"gif"];
                
                self.gifUrl = gif;
                self.videoUrl = video;
                
                // 视图显示后开始设置GIF动画并自动执行
                
                if ([gif containsString:@"http"]) {
                    //通过网络请求
//                    gif = @"http://img4.duitang.com/uploads/item/201303/15/20130315134323_PMTrz.thumb.600_0.gif";
                    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:gif] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    
                        if (finished) {
                            
                            @try {
                                NSString *cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
                                SDImageCache *cache = [SDImageCache sharedImageCache];
                                NSString *path = [cache defaultCachePathForKey:cacheKey];
                                NSURL *url = [NSURL fileURLWithPath:path];
                                self.framesArray = [GIFPlayer framesInGif:url];
                            }
                            @catch (NSException *exception) {
                                NSString *message = [NSString stringWithFormat:@"无效的gif文件:\n%@", imageURL];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                [alert show];
                                self.framesArray = [GIFPlayer framesInGif:self.fileUrl];
                            }
                            @finally {
                                
                            }
                            
                            self.progressSlider.minimumValue = 0;
                            self.progressSlider.maximumValue = self.framesArray.count - 1;
                            self.progressSlider.value = 0;
                            self.inPlaying = NO;
                            
                            
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
                        
                    }];

                } else {
                    //播放默认的
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
                
            }else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
            
        } else {
            [self.hud hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
    }fail:^ (){
        NSLog(@"fail ");
        [self.hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
}

#pragma mark - Getter Method
- (MBProgressHUD *) hud {
    if (!_hud) {
        
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.color = [UIColor clearColor];//这儿表示无背景
        //显示的文字
        _hud.labelText = @"Test";
        //细节文字
        _hud.detailsLabelText = @"Test detail";
        //是否有庶罩
        _hud.dimBackground = YES;
        [self.navigationController.view addSubview:_hud];
    }
    return _hud;
}

@end
