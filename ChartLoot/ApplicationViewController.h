//
//  ApplicationViewController.h
//  ChartLoot
//
//  Created by Arthur GUIBERT on 04/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartboostApplication.h"

@interface ApplicationViewController : UITableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIView* chartView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* loadingIndicator;

@property (strong, nonatomic) ChartboostApplication* detailItem;

- (void)setDetailItem:(ChartboostApplication*)newDetailItem;

@end
