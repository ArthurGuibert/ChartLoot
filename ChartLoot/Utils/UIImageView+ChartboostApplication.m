//
//  UIImageView+ChartboostApplication.m
//  ChartLoot
//
//  Created by Arthur GUIBERT on 04/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+ChartboostApplication.h"

@implementation UIImageView (ChartboostApplication)

-(void)setImageWithApplication:(ChartboostApplication*)application {
    // Just iOS for now as the Google Play Store doesn't have any API to access the apps metadata
    if([application.platform isEqualToString:@"ios"] && application.storeId && ![application.storeId isKindOfClass:[NSNull class]]) {
        NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", application.storeId];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *results = [responseObject objectForKey:@"results"];
            NSDictionary *result = [results objectAtIndex:0];
            NSString *imageUrlStr = [result objectForKey:@"artworkUrl60"];
            
            [self setImageWithURL:[NSURL URLWithString:imageUrlStr]];
        } failure:nil];
    } else {
        
    }
}

@end
