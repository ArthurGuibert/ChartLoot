//
//  LoginViewController.m
//  ChartLoot
//
//  Created by Arthur GUIBERT on 05/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:67.0f/255.0f green:170.0f/255.0f blue:222.0f/255.0f alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.translucent = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
    
    self.title = @"Sign In";
    
    // Pre-fill with you userId/userSignature if you're lazy... 
    self.userId.text = @"";
    self.userSignature.text = @"";
    
    [self addUnderlay];
}

- (void)addUnderlay {
    // Text fields
    CALayer* backgroundLayer = [CALayer layer];
    backgroundLayer.frame = CGRectMake(0, 82, self.view.frame.size.width, 80);
    backgroundLayer.backgroundColor = [UIColor whiteColor].CGColor;
    backgroundLayer.zPosition = -1;
    [self.view.layer addSublayer:backgroundLayer];
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, backgroundLayer.frame.origin.y, backgroundLayer.frame.size.width, 0.5f);
    border.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [self.view.layer addSublayer:border];
    
    border = [CALayer layer];
    border.frame = CGRectMake(0, backgroundLayer.frame.origin.y + 39, backgroundLayer.frame.size.width, 0.5f);
    border.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [self.view.layer addSublayer:border];
    
    border = [CALayer layer];
    border.frame = CGRectMake(0, backgroundLayer.frame.origin.y + 80, backgroundLayer.frame.size.width, 0.5f);
    border.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [self.view.layer addSublayer:border];
    
    // Continue button
    
    backgroundLayer = [CALayer layer];
    backgroundLayer.frame = CGRectMake(0, 169, self.view.frame.size.width, 40);
    backgroundLayer.backgroundColor = [UIColor whiteColor].CGColor;
    backgroundLayer.zPosition = -1;
    [self.view.layer addSublayer:backgroundLayer];
    
    border = [CALayer layer];
    border.frame = CGRectMake(0, backgroundLayer.frame.origin.y, backgroundLayer.frame.size.width, 0.5f);
    border.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [self.view.layer addSublayer:border];
    
    border = [CALayer layer];
    border.frame = CGRectMake(0, backgroundLayer.frame.origin.y + 40, backgroundLayer.frame.size.width, 0.5f);
    border.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [self.view.layer addSublayer:border];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Check if the user is already logged in
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"userId"] && [userDefaults objectForKey:@"userSignature"]) {
        [self performSegueWithIdentifier:@"signIn" sender:self];
    }
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"signIn"]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if(![userDefaults objectForKey:@"userId"] || ![userDefaults objectForKey:@"userSignature"]) {
            [userDefaults setObject:self.userId.text forKey:@"userId"];
            [userDefaults setObject:self.userSignature.text forKey:@"userSignature"];
            [userDefaults synchronize];
        }
    }
}

- (IBAction)unwindToViewControllerNameHere:(UIStoryboardSegue *)segue {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"userId"];
    [userDefaults setObject:nil forKey:@"userSignature"];
    [userDefaults synchronize];
}

@end
