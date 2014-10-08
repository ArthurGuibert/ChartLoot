//
//  Account.m
//  ChartLoot
//
//  Created by Arthur GUIBERT on 04/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import "ChartboostAPIClient.h"
#import "Account.h"

@implementation Account

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.company = [attributes objectForKey:@"company"];
    self.country = @"France";
    self.formattedEarnings = [attributes objectForKey:@"earnings"];
    
    return self;
}

+ (void)fetchAccount:(void (^)(Account *account, NSError *error))block {
    [[ChartboostAPIClient sharedClient] APICall:@"https://api.chartboost.com/account" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Account* account = [[Account alloc] initWithAttributes:responseObject];
        block(account, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error = %@",error);
        block(nil, error);
    }];
}

@end
