//
//  CityDetailsViewController.m
//  Current Weather
//
//  Created by Serhii Kovtunenko on 19.11.18.
//  Copyright © 2018 Serhii Kovtunenko. All rights reserved.
//

#import "CityDetailsViewController.h"
//#import "Weather.h"

@interface CityDetailsViewController ()

//@property (nonatomic) NSArray *detailedWeather;
//@property (nonatomic) Weather *currentWeather;

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

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
 */


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
