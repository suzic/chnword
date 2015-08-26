//
//  FeedbacjViewController.h
//  chnword
//
//  Created by khtc on 15/8/22.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbacjViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *contactTextField;

@property (nonatomic, retain) IBOutlet UITextView *infoTextView;

- (IBAction) submitFeedBack:(id)sender;

@end
