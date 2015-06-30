//
//  QrSearchViewController.h
//  qrcode
//
//  Created by Caland on 14-10-16.
//  Copyright (c) 2014年 Caland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>



//  二维码扫描视图控制器
@interface QrSearchViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, assign) AVCaptureDevicePosition captureType;


//子类应该重写的方法
/**
 *  成功扫到文件的方法。
 */
- (void) successedWithString:(NSString *) str;


/**
 *  @abstract 验证
 */
- (BOOL) verifyQrCode:(NSString *) code;

/**
 *  闪烁的调用方法。
 *  @param view 在那个view上进行闪烁
 *  @param color 闪烁的颜色
 *  @param duration 闪烁的时间
 */
- (void) flashOnView:(UIView *) view withColor:(UIColor *) color duration:(NSTimeInterval) time;

/**
 *  @abstract 移除相册的预览层
 */
- (void) stopSession;

/**
 *  @abstract 关闭扫描
 */
- (void) reStartSession;

/**
 *  @abstract 动画完成
 *
 */
- (void) afterAnimation;

/**
 *  @abstract 更换摄像头
 *
 */
- (void) switchCaptureDevice:(AVCaptureDevicePosition) type;

@end
