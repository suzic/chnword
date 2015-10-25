//
//  UserCell.m
//  chnword
//
//  Created by 苏智 on 15/9/4.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserLevelImage:(NSInteger)level
{
    switch (level)
    {
        case 1:
            [self.userLevel setImage:[UIImage imageNamed:@"UserLogo1"]];
            break;
        case 2:
            [self.userLevel setImage:[UIImage imageNamed:@"UserLogo2"]];
            break;
        case 3:
            [self.userLevel setImage:[UIImage imageNamed:@"UserLogo3"]];
            break;
        case 4:
            [self.userLevel setImage:[UIImage imageNamed:@"UserLogo4"]];
            break;
        default:
            [self.userLevel setImage:[UIImage imageNamed:@"UserLogo"]];
            break;
    }
}

@end
