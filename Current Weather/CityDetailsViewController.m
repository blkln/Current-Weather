//
//  CityDetailsViewController.m
//  Current Weather
//
//  Created by Serhii Kovtunenko on 19.11.18.
//  Copyright © 2018 Serhii Kovtunenko. All rights reserved.
//

#import "CityDetailsViewController.h"

@interface CityDetailsViewController ()

@end

@implementation CityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityDetailsCell" forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *detailLabel = (UILabel *)[cell.contentView viewWithTag:2];
    
    switch (indexPath.row) {
        case 0:
            titleLabel.text = self.currentWeather.name;
            detailLabel.text = self.currentWeather.weatherDescription;
            break;
        
        case 1:
            titleLabel.text = @"Temperature";
            detailLabel.text = self.currentWeather.temperature;
            break;
            
        case 2:
            titleLabel.text = @"Pressure";
            detailLabel.text = self.currentWeather.pressure;
            break;
            
        case 3:
            titleLabel.text = @"Humidity";
            detailLabel.text = self.currentWeather.humidity;
            break;
            
        case 4:
            titleLabel.text = @"Wind direction";
            detailLabel.text = self.currentWeather.windDirection;
            break;
            
        case 5:
            titleLabel.text = @"Wind Speed";
            detailLabel.text = self.currentWeather.windSpeed;
            break;
            
        default:
            break;
    }
    return cell;
}

@end
