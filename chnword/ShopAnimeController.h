//
//  ShopAnimeController.h
//  chnword
//
//  Created by 苏智 on 15/6/22.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopAnimeController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
