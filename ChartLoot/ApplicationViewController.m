//
//  ApplicationViewController.m
//  ChartLoot
//
//  Created by Arthur GUIBERT on 04/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import <FSLineChart/FSLineChart.h>
#import <FontAwesome+iOS/FAImageView.h>
#import "ApplicationViewController.h"
#import "ApplicationMetrics.h"

@interface ApplicationViewController ()

@property (readwrite, nonatomic, strong) ApplicationMetrics *metrics;
@property (nonatomic, strong) NSArray* parametersDef;
@property (nonatomic) NSInteger metricSelected;

@end

@implementation ApplicationViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(ChartboostApplication*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
    
    self.parametersDef = @[
                           @{
                               @"name" : @"Money Earned",
                               @"unit" : @"$",
                               @"method" : @"sum"
                             },
                           @{
                               @"name" : @"eCPM",
                               @"unit" : @"$",
                               @"method" : @"mean"
                             },
                           @{
                               @"name" : @"Impressions Delivered",
                               @"unit" : @"",
                               @"method" : @"sum"
                               },
                           @{
                               @"name" : @"CTR Delivered",
                               @"unit" : @"%",
                               @"method" : @"mean"
                               }
                           ,
                           @{
                               @"name" : @"Install Rate Delivered",
                               @"unit" : @"%",
                               @"method" : @"mean"
                               }
                           ];
}

#pragma mark - UITableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _detailItem.name;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    
    // Header view borders
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, self.chartView.frame.size.width, 0.5f);
    topBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [self.chartView.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, self.chartView.frame.size.height, self.chartView.frame.size.width, 0.5f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [self.chartView.layer addSublayer:bottomBorder];
    
    UIButton *button2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 addTarget:self action:@selector(tapOnCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setFrame:CGRectMake(0, 0, 53, 32)];
    
    UILabel* calendar = [[UILabel alloc] initWithFrame:CGRectMake(36, 0, 32, 32)];
    calendar.font = [UIFont fontWithName:kFontAwesomeFamilyName size:16];
    calendar.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    calendar.text = [NSString fontAwesomeIconStringForEnum:FAIconCalendar];
    calendar.textColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    
    [button2 addSubview:calendar];
    
    self.navigationItem.rightBarButtonItem.customView = button2;
    
    // Refresh control
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    [refresh addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;
    
    self.metricSelected = 0;
    
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parametersDef.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.textLabel.text = [self.parametersDef[[indexPath row]] objectForKey:@"name"];
    
    // Set the average or the total amount
    if([indexPath row] == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.f",[self sumMetricArray:self.metrics.moneyEarned]];
    } else if([indexPath row] == 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.02f",[self meanValueMetricArray:self.metrics.ecpmEarned]];
    } else if([indexPath row] == 2) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.f",[self sumMetricArray:self.metrics.impressionDelivered]];
    } else if([indexPath row] == 3) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f%%",[self meanValueMetricArray:self.metrics.ctrDelivered] * 100];
    } else if([indexPath row] == 4) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f%%",[self meanValueMetricArray:self.metrics.installRateDelivered] * 100];
    }
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    
    if([indexPath row] == self.metricSelected) {
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Parameters";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for(int i=0;i<self.parametersDef.count;i++) {
        NSIndexPath* index = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:index];
        
        if([index row] == [indexPath row]) {
            cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
        } else {
            cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
        }
    }
    
    self.metricSelected = [indexPath row];
    
    [self updateChartForMetric:self.metricSelected];
}

#pragma mark - Utils
-(float)sumMetricArray:(NSArray*)array {
    float sum = 0;
    for(NSString* obj in array) {
        sum += [obj floatValue];
    }
    return sum;
}

-(float)meanValueMetricArray:(NSArray*)array {
    return [self sumMetricArray:array] / [array count];
}

#pragma mark - Chart

-(void)updateChartForMetric:(NSInteger)metricIndex {
    // First we remove all the subviews from the chart view
    NSArray *viewsToRemove = [self.chartView subviews];
    for (UIView *v in viewsToRemove) {
        if(v != self.loadingIndicator)
            [v removeFromSuperview];
    }
    
    // Then we create the new chart
    FSLineChart* lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width - 40, 166)];
    
    lineChart.gridStep = 3;
    
    // Let's put some color in this chart!
    float hue = fmod(0.55f + (float)((metricIndex * 9) % 50) / 50.0f, 1.0f);
    
    lineChart.color = [UIColor colorWithHue:hue saturation:70.0f/100.0f brightness:87.0f/100.0f alpha:1.0f];
    
    lineChart.labelForIndex = ^(NSUInteger item) {
        if(item == 0) {
            return self.metrics.date[item];
        } else {
            NSString* date = self.metrics.date[item];
            NSArray* splitted = [date componentsSeparatedByString:@"-"];
            return splitted[2];
        }
    };
    
    lineChart.labelForValue = ^(CGFloat value) {
        if(metricIndex == 3 || metricIndex == 4) {
            return [NSString stringWithFormat:@"%.01f%%",value * 100];
        }
        
        return [NSString stringWithFormat:@"%@%.f",[self.parametersDef[metricIndex] objectForKey:@"unit"], value];
    };
    
    if(metricIndex == 0) {
        [lineChart setChartData:self.metrics.moneyEarned];
    } else if(metricIndex == 1) {
        [lineChart setChartData:self.metrics.ecpmEarned];
    } else if(metricIndex == 2) {
        [lineChart setChartData:self.metrics.impressionDelivered];
    } else if(metricIndex == 3) {
        [lineChart setChartData:self.metrics.ctrDelivered];
    } else if(metricIndex == 4) {
        [lineChart setChartData:self.metrics.installRateDelivered];
    }
    
    [self.chartView addSubview:lineChart];
}

#pragma mark - Change the period of time

- (void)tapOnCalendar:(NSObject*)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select the period:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Last week",
                            @"Last month",
                            @"Last three months",
                            @"Last six months",
                            @"Last year",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CLDate newPeriod = [ChartboostAPIClient sharedClient].period;
    if(buttonIndex == 0)
        newPeriod = DateLastWeek;
    else if(buttonIndex == 1)
        newPeriod = DateLastMonth;
    else if(buttonIndex == 2)
        newPeriod = DateLastThreeMonths;
    else if(buttonIndex == 3)
        newPeriod = DateLastSixMonths;
    else if(buttonIndex == 4)
        newPeriod = DateLastYear;
    
    if(newPeriod != [ChartboostAPIClient sharedClient].period) {
        NSArray *viewsToRemove = [self.chartView subviews];
        for (UIView *v in viewsToRemove) {
            if(v != self.loadingIndicator)
                [v removeFromSuperview];
        }
        
        self.loadingIndicator.hidden = NO;
        
        [[ChartboostAPIClient sharedClient] savePeriod:newPeriod];
        
        [self reloadData];
    }
}

#pragma mark - Data

-(void)reloadData {
    [ApplicationMetrics fetchMetricsWithAppId:_detailItem.identifier date:[ChartboostAPIClient sharedClient].period callback:^(ApplicationMetrics *metrics, NSError *error) {
        self.metrics = metrics;
        self.loadingIndicator.hidden = YES;
        [self updateChartForMetric:self.metricSelected];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

@end
