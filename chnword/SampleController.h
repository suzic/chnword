//
//  SampleController.h
//  chnword
//
//  Created by 苏智 on 15/10/27.
//  Copyright © 2015年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleController : UIViewController

/**
 *  @abstract 用以标识体验分类里是否解锁更多动画。该奖励来自于用户的分享操作，无需保存到服务器，只要本地有缓存记录即可。
 */
@property (assign, nonatomic) BOOL unlockMore;

/**
 *  @abstract 记录分类索引号，并记录网络通讯所需的模块编号及分类名称
 */
@property (nonatomic, assign) NSInteger categoryIndex;
@property (nonatomic, retain) NSString *moduleCode;
@property (nonatomic, retain) NSString *cateName;

/**
 *  @abstract 在UI界面上对应的元素
 */
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;

@end
