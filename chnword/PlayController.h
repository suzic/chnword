//
//  PlayController.h
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayController : UIViewController

/**
 * @abstract 将要播放的动画的文件路径
 */
@property (strong, nonatomic) NSString *fileUrl;

/**
 * @abstract 将要播放的动画的字的编码
 */
@property (nonatomic, retain) NSString *wordCode;

/**
 * @abstract 该动画是否可以分享（仅免费体验字可以分享）
 */
@property (nonatomic, assign) BOOL canShare;

@end
