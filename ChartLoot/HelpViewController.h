//
//  HelpViewController.h
//  ChartLoot
//
//  Created by Arthur GUIBERT on 08/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView* webView;

@end
