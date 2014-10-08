//
//  HelpViewController.m
//  ChartLoot
//
//  Created by Arthur GUIBERT on 08/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    NSString* filePath = [NSString stringWithFormat:@"%@/help.html",[[NSBundle mainBundle] bundlePath]];
    NSURL *folderUrl = [[NSURL URLWithString:filePath] URLByDeletingLastPathComponent];
    
    [self.webView loadData:[NSData dataWithContentsOfFile:filePath]  MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:folderUrl];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark – WebView delegate functions

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
