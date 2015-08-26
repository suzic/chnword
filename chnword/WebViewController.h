//
//  WebViewController.h
//  chnword
//
//  Created by khtc on 15/8/18.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
