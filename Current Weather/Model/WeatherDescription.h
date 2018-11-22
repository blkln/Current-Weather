//
//  WeatherDescription.h
//  Current Weather
//
//  Created by Serhii Kovtunenko on 21.11.18.
//  Copyright © 2018 Serhii Kovtunenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherDescription : NSObject

@property (nonatomic) NSString *main;
@property (nonatomic, readwrite) NSString *description;

@end
