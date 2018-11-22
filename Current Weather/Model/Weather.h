//
//  Weather.h
//  Current Weather
//
//  Created by Serhii Kovtunenko on 20.11.18.
//  Copyright © 2018 Serhii Kovtunenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSArray *weather;
@property (nonatomic) NSDictionary *main;
@property (nonatomic) NSDictionary *wind;

@property (nonatomic) NSString *weatherState;
@property (nonatomic) NSString *weatherDescription;
@property (nonatomic) NSString *temperature;
@property (nonatomic) NSString *pressure;
@property (nonatomic) NSString *humidity;
@property (nonatomic) NSString *windSpeed;
@property (nonatomic) NSString *windDirection;

-(void) printProperties;

@end
