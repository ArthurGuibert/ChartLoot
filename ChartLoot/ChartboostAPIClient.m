//
//  ChartboostAPIClient.m
//  ChartLoot
//
//  Created by Arthur GUIBERT on 04/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import "ChartboostAPIClient.h"

@implementation ChartboostAPIClient

+ (instancetype)sharedClient {
    static ChartboostAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ChartboostAPIClient alloc] init];
    });
    return _sharedClient;
}

- (id)init {
    self = [super init];
    
    if(self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"period"]) {
            self.period = [[userDefaults objectForKey:@"period"] integerValue];
        } else {
            self.period = DateLastWeek;
        }
        
        [self updateAPIKey];
    }
    
    return self;
}

- (void)updateAPIKey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"userId"] && [userDefaults objectForKey:@"userSignature"]) {
        self.apiUserId = [userDefaults objectForKey:@"userId"];
        self.apiUserSignature = [userDefaults objectForKey:@"userSignature"];
    }
}

- (void)APICall:(NSString *)URLString
     parameters:(id)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // We add the userId and the userSignature to every request as we don't want to do that manually every time!
    NSMutableDictionary* signedParameters;
    
    if(parameters == nil) {
        signedParameters = [[NSMutableDictionary alloc] init];
    } else {
        signedParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    }
    
    [signedParameters setValue:self.apiUserId forKey:@"user_id"];
    [signedParameters setValue:self.apiUserSignature forKey:@"user_signature"];
    [manager GET:URLString parameters:signedParameters success:success failure:failure];
}

- (void)APICall2:(NSString *)URLString
     parameters:(id)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // We add the userId and the userSignature to every request as we don't want to do that manually every time!
    NSMutableDictionary* signedParameters;
    
    if(parameters == nil) {
        signedParameters = [[NSMutableDictionary alloc] init];
    } else {
        signedParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    }
    
    // There are two version of the chartboost api, with two different way of passing the userId/userSignature...
    [signedParameters setValue:self.apiUserId forKey:@"userId"];
    [signedParameters setValue:self.apiUserSignature forKey:@"userSignature"];
    [manager GET:URLString parameters:signedParameters success:success failure:failure];
}

- (NSString*)getDate:(CLDate)period {
    NSDate *endDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    
    if(period == DateToday) {
        return [dateFormat stringFromDate:endDate];
    } else if(period == DateLastWeek) {
        NSDate *startDate = [endDate dateByAddingTimeInterval:-6*24*60*60];
        return [dateFormat stringFromDate:startDate];
    } else if(period == DateLastMonth) {
        NSDate *startDate = [endDate dateByAddingTimeInterval:-30*24*60*60];
        return [dateFormat stringFromDate:startDate];
    } else if(period == DateLastThreeMonths) {
        NSDate *startDate = [endDate dateByAddingTimeInterval:-90*24*60*60];
        return [dateFormat stringFromDate:startDate];
    } else if(period == DateLastSixMonths) {
        NSDate *startDate = [endDate dateByAddingTimeInterval:-180*24*60*60];
        return [dateFormat stringFromDate:startDate];
    } else if(period == DateLastYear) {
        NSDate *startDate = [endDate dateByAddingTimeInterval:-365*24*60*60];
        return [dateFormat stringFromDate:startDate];
    }
    
    return nil;
}

- (void)savePeriod:(CLDate)period {
    self.period = period;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInteger:period] forKey:@"period"];
    [userDefaults synchronize];
}

@end