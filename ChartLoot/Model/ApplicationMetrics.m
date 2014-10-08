//
//  ApplicationMetrics.m
//  ChartLoot
//
//  Created by Arthur GUIBERT on 04/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import "ChartboostAPIClient.h"
#import "ApplicationMetrics.h"

@implementation ApplicationMetrics

- (instancetype)initWithAttributes:(NSArray *)array period:(CLDate)period {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // If there is no data for a date, we want to set the values to zero.
    NSArray* dayCountForPeriod = @[@0,@7,@31,@91,@181,@366];
    NSInteger dayCount = [dayCountForPeriod[period] integerValue];
    
    NSMutableArray* mutableEarnings = [NSMutableArray arrayWithCapacity:dayCount];
    NSMutableArray* mutableDates = [NSMutableArray arrayWithCapacity:dayCount];
    NSMutableArray* mutableEcpm = [NSMutableArray arrayWithCapacity:dayCount];
    NSMutableArray* mutableImpression = [NSMutableArray arrayWithCapacity:dayCount];
    NSMutableArray* mutableCTR = [NSMutableArray arrayWithCapacity:dayCount];
    NSMutableArray* mutableInstallRate = [NSMutableArray arrayWithCapacity:dayCount];
    
    NSDate *endDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    
    // Complexity... I'm not a big fan of these loops.
    for(NSInteger i=dayCount - 1;i>=0;i--) {
        NSDate *startDate = [endDate dateByAddingTimeInterval:-i*24*60*60];
        NSString* dateKey = [dateFormat stringFromDate:startDate];
        
        __block NSNumber* moneyEarned = @0;
        __block NSNumber* ecpmEarned = @0;
        __block NSNumber* impression = @0;
        __block NSNumber* ctr = @0;
        __block NSNumber* installRate = @0;
        
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString* objDate = [obj objectForKey:@"dt"];
            
            if([dateKey isEqualToString:objDate]) {
                moneyEarned = [obj objectForKey:@"moneyEarned"];
                ecpmEarned = [obj objectForKey:@"ecpmEarned"];
                impression = [obj objectForKey:@"impressionsDelivered"];
                ctr = [obj objectForKey:@"ctrDelivered"];
                installRate = [obj objectForKey:@"installRateDelivered"];
                *stop = YES;
            }
            
        }];
        
        [mutableEarnings addObject:moneyEarned];
        [mutableEcpm addObject:ecpmEarned];
        [mutableImpression addObject:impression];
        [mutableCTR addObject:ctr];
        [mutableInstallRate addObject:installRate];
        [mutableDates addObject:dateKey];
    }
    
    self.moneyEarned = [NSArray arrayWithArray:mutableEarnings];
    self.ecpmEarned = [NSArray arrayWithArray:mutableEcpm];
    self.impressionDelivered = [NSArray arrayWithArray:mutableImpression];
    self.ctrDelivered = [NSArray arrayWithArray:mutableCTR];
    self.installRateDelivered = [NSArray arrayWithArray:mutableInstallRate];
    self.date = [NSArray arrayWithArray:mutableDates];
    
    return self;
}

+ (void)fetchMetricsWithAppId:(NSString*)appId date:(CLDate)date callback:(void (^)(ApplicationMetrics *, NSError *))block {
    
    NSDictionary* params = @{@"appId" : appId,
                             @"dateMin" : [[ChartboostAPIClient sharedClient] getDate:date],
                             @"dateMax" : [[ChartboostAPIClient sharedClient] getDate:DateToday]};
    
    [[ChartboostAPIClient sharedClient] APICall2:@"https://analytics.chartboost.com/v3/metrics/app?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ApplicationMetrics* metrics = [[ApplicationMetrics alloc] initWithAttributes:responseObject period:date];
        block(metrics, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error = %@",error);
        block(nil, error);
    }];
}

@end
