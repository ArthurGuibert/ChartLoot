//
//  LoginViewController.h
//  ChartLoot
//
//  Created by Arthur GUIBERT on 05/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField* userId;
@property (nonatomic, strong) IBOutlet UITextField* userSignature;
@property (nonatomic, strong) IBOutlet UIButton* loginButton;

@end
