//
//  Account.h
//  ChartLoot
//
//  Created by Arthur GUIBERT on 04/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (nonatomic, strong) NSString* company;
@property (nonatomic, strong) NSString* country;
@property (nonatomic, strong) NSString* formattedEarnings;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (void)fetchAccount:(void (^)(Account *account, NSError *error))block;

@end
