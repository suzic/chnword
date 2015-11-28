//
//  GifView.h
//  chnword
//
//  Created by 苏智 on 15/11/28.
//  Copyright © 2015年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface GifView : UIView
{
    CGImageSourceRef gif; // 保存gif动画
    NSDictionary *gifProperties; // 保存gif动画属性
    size_t index; // gif动画播放开始的帧序号
    size_t count; // gif动画的总帧数
    NSTimer *timer; // 播放gif动画所使用的timer
}

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)filePath;
- (void)resumeGif;
- (void)stopGif;

@end