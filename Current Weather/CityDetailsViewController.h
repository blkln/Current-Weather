//
//  CityDetailsViewController.h
//  Current Weather
//
//  Created by Serhii Kovtunenko on 19.11.18.
//  Copyright © 2018 Serhii Kovtunenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"

@interface CityDetailsViewController : UITableViewController

@property (nonatomic) Weather *currentWeather;

@property (nonatomic) NSArray *detailedWeather;

@end
