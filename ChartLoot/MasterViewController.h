//
//  MasterViewController.h
//  ChartLoot
//
//  Created by Arthur GUIBERT on 04/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UILabel* earningsLabel;
@property (nonatomic, strong) IBOutlet UILabel* companyLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* loadingIndicator;
@property (nonatomic, strong) IBOutlet UIView* headerView;

@property (nonatomic, strong) UILabel* back;

@end

