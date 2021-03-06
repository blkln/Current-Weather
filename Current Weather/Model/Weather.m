//
//  Weather.m
//  Current Weather
//
//  Created by Serhii Kovtunenko on 20.11.18.
//  Copyright © 2018 Serhii Kovtunenko. All rights reserved.
//

#import "Weather.h"

@implementation Weather

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.weather forKey:@"weather"];
    [encoder encodeObject:self.main forKey:@"main"];
    [encoder encodeObject:self.wind forKey:@"wind"];
    [encoder encodeObject:self.weatherState forKey:@"weatherState"];
    [encoder encodeObject:self.weatherDescription forKey:@"weatherDescription"];
    [encoder encodeObject:self.temperature forKey:@"temperature"];
    [encoder encodeObject:self.pressure forKey:@"pressure"];
    [encoder encodeObject:self.humidity forKey:@"humidity"];
    [encoder encodeObject:self.windSpeed forKey:@"windSpeed"];
    [encoder encodeObject:self.windDirection forKey:@"windDirection"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.name = [decoder decodeObjectForKey:@"name"];
        self.weather = [decoder decodeObjectForKey:@"weather"];
        self.main = [decoder decodeObjectForKey:@"main"];
        self.wind = [decoder decodeObjectForKey:@"wind"];
        self.weatherState = [decoder decodeObjectForKey:@"weatherState"];
        self.weatherDescription = [decoder decodeObjectForKey:@"weatherDescription"];
        self.temperature = [decoder decodeObjectForKey:@"temperature"];
        self.pressure = [decoder decodeObjectForKey:@"pressure"];
        self.humidity = [decoder decodeObjectForKey:@"humidity"];
        self.windSpeed = [decoder decodeObjectForKey:@"windSpeed"];
        self.windDirection = [decoder decodeObjectForKey:@"windDirection"];
    }
    return self;
}

-(NSString *)name
{
    if (!_name) {
        _name = [self.name capitalizedString];
    }
    return  _name;
}

-(NSString *)weatherState
{
    if (!_weatherState) {
        NSDictionary *weatherItem = self.weather.firstObject;
        _weatherState = [weatherItem[@"main"] capitalizedString];
    }
    return _weatherState;
}

-(NSString *)weatherDescription
{
    if (!_weatherDescription) {
        NSDictionary *weatherItem = self.weather.firstObject;
        _weatherDescription = [weatherItem[@"description"] capitalizedString];
    }
    return _weatherDescription;
}

-(NSString *)temperature
{
    if (!_temperature) {
        NSNumber *temp = self.main[@"temp"];
        _temperature = [NSString stringWithFormat:@"%d ℃", (int) ceil(temp.doubleValue)];
    }
    return _temperature;
}

-(NSString *)pressure
{
    if (!_pressure) {
        _pressure = [NSString stringWithFormat:@"%@ hPa", self.main[@"pressure"]];
    }
    return _pressure;
}

-(NSString *)humidity
{
    if (!_humidity) {
        _humidity = [NSString stringWithFormat:@"%@ %%", self.main[@"humidity"]];
    }
    return _humidity;
}

-(NSString *)windSpeed
{
    if (!_windSpeed) {
        NSNumber *windSpd = self.wind[@"speed"];
        NSInteger windSpeed = windSpd.longValue;
        _windSpeed = [NSString stringWithFormat:@"%ld meter/sec", windSpeed];
    }
    return _windSpeed;
}

-(NSString *)windDirection
{
    if (!_windDirection) {
        NSNumber *windDir = self.wind[@"deg"];
        _windDirection = [self getWindDirection:windDir.integerValue];
    }
    return _windDirection;
}

-(NSString *)getWindDirection:(double)windDegree
{
    NSString *windDirection;
    
    if (windDegree > 11.25 && windDegree <= 33.75) {
        windDirection = @"North-Northeast";
    } else if (windDegree > 33.75 && windDegree <= 56.25) {
        windDirection = @"Northeast";
    } else if (windDegree > 56.25 && windDegree <= 78.75) {
        windDirection = @"East-Northeast";
    } else if (windDegree > 78.75 && windDegree <= 101.25) {
        windDirection = @"East";
    } else if (windDegree > 101.25 && windDegree <= 123.75) {
        windDirection = @"East-Southeast";
    } else if (windDegree > 123.75 && windDegree <= 146.25) {
        windDirection = @"Southeast";
    } else if (windDegree > 146.25 && windDegree <= 168.75) {
        windDirection = @"South-Southeast";
    } else if (windDegree > 168.75 && windDegree <= 191.25) {
        windDirection = @"South";
    } else if (windDegree > 191.25 && windDegree <= 213.75) {
        windDirection = @"South-Southwest";
    } else if (windDegree > 213.75 && windDegree <= 236.25) {
        windDirection = @"Southwest";
    } else if (windDegree > 236.25 && windDegree <= 258.75) {
        windDirection = @"West-Southwest";
    } else if (windDegree > 258.75 && windDegree <= 281.25) {
        windDirection = @"West";
    } else if (windDegree > 281.25 && windDegree <= 303.75) {
        windDirection = @"West-Northwest";
    } else if (windDegree > 303.75 && windDegree <= 326.25) {
        windDirection = @"Northwest";
    } else if (windDegree > 326.25 && windDegree <= 348.75) {
        windDirection = @"North-Northwest";
    } else {
        windDirection = @"North";
    }
    
    return windDirection;
}

-(void) printProperties
{
    NSLog(@"%@",self.weatherState);
    NSLog(@"%@",self.weatherDescription);
    NSLog(@"%@",self.temperature);
    NSLog(@"%@",self.pressure);
    NSLog(@"%@",self.humidity);
    NSLog(@"%@",self.windSpeed);
    NSLog(@"%@",self.windDirection);
}

@end
