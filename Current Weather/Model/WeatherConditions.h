//
//  WeatherConditions.h
//  Current Weather
//
//  Created by Serhii Kovtunenko on 21.11.18.
//  Copyright © 2018 Serhii Kovtunenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherConditions : NSObject

@property (nonatomic) NSNumber *temp;
@property (nonatomic) NSNumber *pressure;
@property (nonatomic) NSNumber *humidity;

@end
