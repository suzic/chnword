//
//  GIFPLayer.h
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GIFPlayer : UIView

/*
 * @abstract 构造初始化
 */
- (id)initWithCenter:(CGPoint)center fileURL:(NSURL*)fileURL;
- (id)initWithFrame:(CGRect)frame fileURL:(NSURL*)fileURL;

/*
 * @abstract 开始播放，并设置一个动画代理
 */
- (void)startGif:(UIViewController *)delegateController;

/*
 * @abstract 结束播放
 */
- (void)stopGif;

/*
 * @abstract 获取GIF中的每一帧
 */
+ (NSArray*)framesInGif:(NSURL*)fileURL;

/*
 * @abstract 获取GIF中的每一帧
 */
+ (NSArray *) framesInImage:(UIImage *) image;


@end
