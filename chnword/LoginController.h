//
//  LoginController.h
//  chnword
//
//  Created by 苏智 on 15/6/20.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginHolderController.h"

@interface LoginController : UITableViewController

/**
 *  @abstract 该引用告诉登录控制器的父容器控制器，以便使用定制的方式弹出错误提示信息
 */
@property (nonatomic, retain) LoginHolderController *errorContainer;

@end
