//
//  ApplicationMetrics.h
//  ChartLoot
//
//  Created by Arthur GUIBERT on 04/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartboostAPIClient.h"

@interface ApplicationMetrics : NSObject

@property (nonatomic, strong) NSArray* moneyEarned;
@property (nonatomic, strong) NSArray* ecpmEarned;
@property (nonatomic, strong) NSArray* impressionDelivered;
@property (nonatomic, strong) NSArray* ctrDelivered;
@property (nonatomic, strong) NSArray* installRateDelivered;
@property (nonatomic, strong) NSArray* date;

- (instancetype)initWithAttributes:(NSArray *)array period:(CLDate)period;
+ (void)fetchMetricsWithAppId:(NSString*)appId date:(CLDate)date callback:(void (^)(ApplicationMetrics *, NSError *))block;


@end
