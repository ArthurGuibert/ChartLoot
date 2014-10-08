//
//  ChartboostApplication.m
//  ChartLoot
//
//  Created by Arthur GUIBERT on 04/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import "ChartboostAPIClient.h"
#import "ChartboostApplication.h"

@implementation ChartboostApplication

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.name = [attributes objectForKey:@"name"];
    self.identifier = [attributes objectForKey:@"id"];
    self.storeId = [attributes objectForKey:@"store_id"];
    self.platform = [attributes objectForKey:@"platform"];
  
    return self;
}

+ (void)fetchApplications:(void (^)(NSArray *array, NSError *error))block {
    [[ChartboostAPIClient sharedClient] APICall:@"https://api.chartboost.com/apps/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* responseDict = responseObject;
        NSArray* allKeys = [responseDict allKeys];
        NSMutableArray *mutableApps = [NSMutableArray arrayWithCapacity:[allKeys count]];
        
        for(NSString* key in allKeys) {
            NSDictionary* appDict = [responseDict objectForKey:key];
            
            ChartboostApplication *app = [[ChartboostApplication alloc] initWithAttributes:appDict];
            [mutableApps addObject:app];
        }
        
        block([NSArray arrayWithArray:mutableApps], nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error = %@",error);
        block(nil, error);
    }];
}

@end
