//
//  ShopCell.h
//  chnword
//
//  Created by 苏智 on 15/6/22.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCell : UITableViewCell

@property (strong, nonatomic) NSString *itemCode;

@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) IBOutlet UILabel *itemPrice;
@property (strong, nonatomic) IBOutlet UIView *itemBuy;
@property (strong, nonatomic) IBOutlet UIImageView *itemCheck;

@end
