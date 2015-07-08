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


#import "UMSocial.h"


@interface PlayController () <UMSocialUIDelegate>

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

- (IBAction) shareVideo:(id)sender
{
//    self.canShare = YES;
    if (self.canShare) {
        //进行分享
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:nil
                                          shareText:@"让国人羞愧，汉字原来如此简单……"
                                         shareImage:[UIImage imageNamed:@"AppIcon"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToQzone, UMShareToQQ, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToWechatFavorite, nil]
                                           delegate:self];
        //分享video
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeVideo url:self.videoUrl];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您无法分享此内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
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


#pragma mark - UMSocial delegate method
/**
 自定义关闭授权页面事件
 
 @param navigationCtroller 关闭当前页面的navigationCtroller对象
 
 */
-(BOOL)closeOauthWebViewController:(UINavigationController *)navigationCtroller socialControllerService:(UMSocialControllerService *)socialControllerService
{
    return NO;
}

/**
 关闭当前页面之后
 
 @param fromViewControllerType 关闭的页面类型
 
 */
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{

    
}

/**
 各个页面执行授权完成、分享完成、或者评论完成时的回调函数
 
 @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

/**
 点击分享列表页面，之后的回调方法，你可以通过判断不同的分享平台，来设置分享内容。
 例如：
 
 -(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
 {
 if (platformName == UMShareToSina) {
 socialData.shareText = @"分享到新浪微博的文字内容";
 }
 else{
 socialData.shareText = @"分享到其他平台的文字内容";
 }
 }
 
 @param platformName 点击分享平台
 
 @prarm socialData   分享内容
 */
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    if (platformName == UMShareToSina) {
        
        socialData.shareText = @"分享到新浪微博的文字内容";
        
    } else if (platformName == UMShareToWechatSession) {
        
        socialData.shareText = @"分享到微信好友的文字内容";
        
    }else if (platformName == UMShareToWechatTimeline) {
        socialData.shareText = @"分享到微信朋友圈的文字内容";
    }
    else{
        socialData.shareText = @"分享到其他平台的文字内容";
    }
}


/**
 配置点击分享列表后是否弹出分享内容编辑页面，再弹出分享，默认需要弹出分享编辑页面
 
 @result 设置是否需要弹出分享内容编辑页面，默认需要
 
 */
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}

@end
