//
//  SampleController.h
//  chnword
//
//  Created by 苏智 on 15/10/27.
//  Copyright © 2015年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleController : UIViewController

@property (assign, nonatomic) BOOL unlockMore;

@property (assign, nonatomic) NSInteger categoryIndex;
@property (nonatomic, retain) NSString *moduleCode;
@property (nonatomic, retain) NSString *cateName;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;

@end
