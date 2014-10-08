//
//  MasterViewController.m
//  ChartLoot
//
//  Created by Arthur GUIBERT on 04/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <FontAwesome+iOS/FAImageView.h>
#import "ChartboostAPIClient.h"
#import "Account.h"
#import "ChartboostApplication.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ChartboostApplicationTableViewCell.h"
#import "UIImageView+ChartboostApplication.h"

@interface MasterViewController ()

@property (readwrite, nonatomic, strong) NSArray *applications;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:67.0f/255.0f green:170.0f/255.0f blue:222.0f/255.0f alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.translucent = YES;
    
    // Header view borders
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, self.headerView.frame.size.width, 0.5f);
    topBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [self.headerView.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, self.headerView.frame.size.height, self.headerView.frame.size.width, 0.5f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [self.headerView.layer addSublayer:bottomBorder];
    
    self.title = @"Chartboost";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(tapOnSettings:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 53, 32)];
    
    UILabel* settings = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    settings.font = [UIFont fontWithName:kFontAwesomeFamilyName size:16];
    settings.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    settings.text = [NSString fontAwesomeIconStringForEnum:FAIconCog];
    settings.textColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    
    [button addSubview:settings];
    
    self.navigationItem.leftBarButtonItem.customView = button;
    
    // Refresh control
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    [refresh addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;
   
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setDetailItem:self.applications[indexPath.row]];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.applications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = @"ChartboostApplicationTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   
    ChartboostApplication* app = self.applications[indexPath.row];
    cell.textLabel.text = app.name;
    cell.detailTextLabel.text = app.platform;
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f];
    
    [cell.imageView setImage:[UIImage imageNamed:@"default_cell.png"]];
    [cell.imageView setImageWithApplication:app];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Apps";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0f;
}

#pragma mark - Data

- (void)reloadData {
    
    [Account fetchAccount:^(Account *account, NSError *error) {
        self.loadingIndicator.hidden = YES;
        
        if(!error) {
            self.earningsLabel.text = account.formattedEarnings;
            self.earningsLabel.hidden = NO;
            
            self.companyLabel.text = account.company;
            self.companyLabel.hidden = NO;
        }
    }];
    
    [ChartboostApplication fetchApplications:^(NSArray *applications, NSError *error) {
        self.applications = applications;
        [self.tableView reloadData];
    }];
    
    [self.refreshControl endRefreshing];
}

#pragma mark - Settings

- (void)tapOnSettings:(NSObject*)settings {
    [self performSegueWithIdentifier:@"showSettings" sender:self];
}

@end
