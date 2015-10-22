//
//  LoginHolderController.h
//  chnword
//
//  Created by 苏智 on 15/10/14.
//  Copyright © 2015年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginHolderController : UIViewController

/**
 *  @abstract 当登录用户过多显示错误信息
 */
- (void)showLoginErrorTooMany;

/**
 *  @abstract 当登录验证码出错后显示错误信息
 */
- (void)showLoginErrorWrong;

@end
