//
//  ChartboostAPIClient.h
//  ChartLoot
//
//  Created by Arthur GUIBERT on 04/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>

@interface ChartboostAPIClient : NSObject

typedef NS_ENUM(NSInteger, CLDate) {
    DateToday,
    DateLastWeek,
    DateLastMonth,
    DateLastThreeMonths,
    DateLastSixMonths,
    DateLastYear
};

@property (nonatomic, readwrite) CLDate period;
@property (nonatomic, strong) NSString* apiUserId;
@property (nonatomic, strong) NSString* apiUserSignature;

+ (instancetype)sharedClient;

- (void)APICall:(NSString *)URLString
     parameters:(id)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)APICall2:(NSString *)URLString
      parameters:(id)parameters
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (NSString*)getDate:(CLDate)period;
- (void)savePeriod:(CLDate)period;

- (void)updateAPIKey;

@end
