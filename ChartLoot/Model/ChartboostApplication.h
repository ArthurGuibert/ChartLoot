//
//  ChartboostApplication.h
//  ChartLoot
//
//  Created by Arthur GUIBERT on 04/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartboostApplication : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) NSString* storeId;
@property (nonatomic, strong) NSString* platform;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (void)fetchApplications:(void (^)(NSArray *applications, NSError *error))block;

@end
