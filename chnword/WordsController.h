//
//  WordsController.h
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordCell.h"

@interface WordsController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (assign, nonatomic) NSInteger categoryIndex;
@property (nonatomic, retain) NSString *moduleCode;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;

@end
