//
//  CitiesListViewController.m
//  Current Weather
//
//  Created by Serhii Kovtunenko on 19.11.18.
//  Copyright © 2018 Serhii Kovtunenko. All rights reserved.
//

#import "CitiesListViewController.h"
#import "Weather.h"
#import <RestKit/RestKit.h>
#import "CityDetailsViewController.h"

#define kAPPID @"f05519111df4ee763f1c0e3cf501f728"
#define kUNITS @"metric"

@interface CitiesListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *citiesList;
@property (weak, nonatomic) IBOutlet UITextField *addedCityName;
@property (nonatomic) NSMutableArray *citiesByDefault;

@property (nonatomic, strong) NSMutableDictionary *loadedWeather;
@property (nonatomic) NSMutableArray *mappedCities;
@property (nonatomic) NSMutableArray *currentWeather;

@end

@implementation CitiesListViewController

-(NSMutableDictionary *)loadedWeather
{
    if (!_loadedWeather) {
        _loadedWeather = [[NSMutableDictionary alloc] init];
    }
    return _loadedWeather;
}

-(NSMutableArray *)mappedCities
{
    _mappedCities = [[NSMutableArray alloc] initWithArray:[self.loadedWeather allValues]] ;
    return _mappedCities;
}

-(NSArray *)citiesByDefault
{
    if (!_citiesByDefault) {
        _citiesByDefault = [[NSMutableArray alloc] initWithArray:@[@"Kyiv", @"Rivne", @"Lviv"]] ;
    }
    return _citiesByDefault;
}
- (IBAction)addCity:(UIBarButtonItem *)sender {
    NSString *newCityName = self.addedCityName.text;
    if ([newCityName rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location == NSNotFound) {
        if (newCityName.length) {
            if (![self.citiesByDefault containsObject:newCityName]) {
                [newCityName capitalizedString];
                [self.citiesByDefault addObject:newCityName];
                [self updateWeather];
            }
        }
    } else {
        [self showWarning:@"Bad city name" withTitle:@"Error"];
    }
    self.addedCityName.text = @"";

//    if let nameForNewCity = newCityName.text?.capitalized {
//        let numbersRange = nameForNewCity.rangeOfCharacter(from: .decimalDigits)
//        if numbersRange == nil {
//            if !nameForNewCity.isEmpty {
//                if !defaultCities.contains(nameForNewCity) {
//                    defaultCities.append(nameForNewCity)
//                }
//                updateWeatherData(defaultCities)
//            }
//        } else {
//            showWarning("Bad city Name", code: "")
//        }
//        newCityName.text = ""
//    }

    
}
- (IBAction)updateWeather:(UIBarButtonItem *)sender {
    [self updateWeather];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUserDefaults];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self configureRestKit];
    [self updateWeather];
//    for (NSString *cityName in self.citiesByDefault) {
//        [self loadWeather:cityName];
//    }
//    [self.tableView reloadData];

//    [self loadWeather:@"Kyiv"];
//    for (NSDictionary *item in self.loadedWeather) {
//        [self extractWeatherData:item];
//    }
//    [self transformLoadedData];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - User defaults

-(void) loadUserDefaults
{
    self.loadedWeather = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"loadedWeather"]] ;
    self.citiesByDefault = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"citiesByDefault"]] ;
    self.mappedCities = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"mappedCities"]];
    
    if (!self.loadedWeather.count && !self.citiesByDefault.count && !self.mappedCities.count) {
        self.citiesByDefault = [[NSMutableArray alloc] initWithArray:@[@"Kyiv", @"Rivne", @"Lviv"]];
    } else {
        for (Weather *key in self.loadedWeather) {
            [self.citiesByDefault addObject:key.name];
        }
    }
    
}

-(void) updateUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.loadedWeather] forKey:@"loadedWeather"];
    
//    [[NSUserDefaults standardUserDefaults] setObject:self.loadedWeather forKey:@"loadedWeather"];
    [[NSUserDefaults standardUserDefaults] setObject:self.citiesByDefault forKey:@"citiesByDefault"];
    [[NSUserDefaults standardUserDefaults] setObject:self.mappedCities forKey:@"mappedCities"];
    
    /*///////////////
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[NSKeyedArchiver archivedDataWithRootObject:self.myDictionary] forKey:@"MyData"];
    [def synchronize];
    
    
    into a dictionary from sandbox:
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *data = [def objectForKey:@"MyData"];
    NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.myDictionary = [[NSDictionary alloc] initWithDictionary:retrievedDictionary];
    Hope this he

     */
     
}

#pragma mark - Networking

- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://api.openweathermap.org"];
    AFRKHTTPClient *client = [[AFRKHTTPClient alloc] initWithBaseURL:baseURL];  //
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *weatherMapping = [RKObjectMapping mappingForClass:[Weather class]];
    [weatherMapping addAttributeMappingsFromArray:@[@"name", @"weather", @"main", @"wind"]];
//    [weatherMapping addAttributeMappingsFromArray:@[@"name"]];
    
    /*
    
#warning consider array handling
    RKObjectMapping *weatherDescriptionMapping = [RKObjectMapping mappingForClass:[WeatherDescription class]];
    [weatherDescriptionMapping addAttributeMappingsFromArray:@[@"main", @"description"]];
    
     
    RKObjectMapping *weatherConditionsMapping = [RKObjectMapping mappingForClass:[WeatherConditions class]];
    [weatherConditionsMapping addAttributeMappingsFromArray:@[@"temp", @"pressure", @"humidity"]];
    
#warning array or dictionary?
    RKObjectMapping *windMapping = [RKObjectMapping mappingForClass:[Wind class]];
    [windMapping addAttributeMappingsFromArray:@[@"speed", @"deg"]];
    
    
    [weatherMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"weather" toKeyPath:@"weather" withMapping:weatherDescriptionMapping]];
     
    
    [weatherMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"main" toKeyPath:@"main" withMapping:weatherConditionsMapping]];
    
    [weatherMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"wind" toKeyPath:@"wind" withMapping:windMapping]];
    
    */

    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:weatherMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/data/2.5/weather"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

- (void)loadWeather:(NSString *)cityName
{
    NSString *appID = kAPPID;
    NSString *units = kUNITS;
    
    NSDictionary *queryParams = @{@"q" : cityName,
                                  @"units" : units,
                                  @"APPID" : appID
                                  };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/data/2.5/weather"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSArray *resultArray = mappingResult.array;
//                                                  for (int i = 0; i < resultArray.count; i++) {
//                                                      Weather *result = [[Weather alloc] initWithProperties];
//                                                      [self.loadedWeather setObject:result forKey:result.name];
//                                                  }
                                                  
                                                  
                                                  for (Weather *result in resultArray) {
//                                                      [self checkForDuplicates: result];
                                                      [result printProperties];
                                                      [self.loadedWeather setObject:result forKey:result.name];
                                                  }
//                                                  [self.loadedWeather addObjectsFromArray:mappingResult.array];
//                                                  self.loadedWeather = mappingResult.array;
//                                                  for (NSDictionary *item in self.loadedWeather) {
//                                                      [self extractWeatherData:item];
//                                                  }
                                                  
                                                  [self.citiesList reloadData];
                                                  [self updateUserDefaults];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Request fail: %@", error);
                                                  [self showWarning:@"Request failed" withTitle:@"Error"];
                                              }];
}

/*
-(void)checkForDuplicates:(Weather *)objectToCheck
{
    NSDictionary *temp = [[NSDictionary alloc] initWithDictionary:self.loadedWeather];
    
    for (NSString *key in temp) {
        [self.loadedWeather setObject:objectToCheck forKey:key];
    }
 
    NSArray *temp = [[NSArray alloc] initWithArray:self.loadedWeather]; //[self.loadedWeather copy];
    if (temp.count) {
        for (id object in self.loadedWeather) {
            long index = [self.loadedWeather indexOfObject:objectToCheck];
            if (index) {
                self.loadedWeather[index] = objectToCheck;
//                [self.loadedWeather removeObjectAtIndex: index];
//                [self.loadedWeather insertObject:object atIndex:index];
            } else {
                [self.loadedWeather addObject:objectToCheck];
            }
        }
    } else {
        [self.loadedWeather addObject:objectToCheck];
    }
 
}
*/

-(void)updateWeather
{
    for (NSString *cityName in self.citiesByDefault) {
        [self loadWeather:cityName];
    }
}

/*
#pragma mark - Data extracting

-(void)extractWeatherData:(NSDictionary *) loadedItem
{
    NSString *cityName = loadedItem[@"name"];
    NSArray *weather = loadedItem[@"wether"];
    NSDictionary *weatherItem = weather.firstObject;
    NSString *weatherState = weatherItem[@"main"];
    NSString *weatherDescription = weatherItem[@"description"];
    
    NSDictionary *main = loadedItem[@"main"];
    NSString *temp = [NSString stringWithFormat:@"%@ ℃", main[@"temp"]];
    NSString *pressure = [NSString stringWithFormat:@"%@ hPa", main[@"pressure"]];
    NSString *humidity = [NSString stringWithFormat:@"%@ %%", main[@"humidity"]];
    NSDictionary *wind = loadedItem[@"wind"];
    NSString *windSpeed = [NSString stringWithFormat:@"%@ meter/sec", wind[@"speed"]];
    NSNumber *windDir = wind[@"deg"];
    NSString *windDirection = [self getWindDirection:windDir.doubleValue];

//    NSInteger windDegree = windDir.doubleValue;
    
    NSString *windString = [NSString stringWithFormat:@"%@, %@ meter/sec", windDirection, windSpeed];

    NSDictionary *extractedWeather = @{
                                       @"name" : cityName,
                                       @"weatherState" : weatherState,
                                       @"weatherDescription" : weatherDescription,
                                       @"temp" : temp,
                                       @"pressure" : pressure,
                                       @"humidity" : humidity,
                                       @"wind" : windString
                                       };
    
    [self.currentWeather addObject:extractedWeather];
    [self.tableView reloadData];
}

-(NSString *)getWindDirection:(double)windDegree
{
    NSString *windDirection;
    
    if (windDegree > 11.25 && windDegree <= 33.75) {
        windDirection = @"NNE";
    } else if (windDegree > 33.75 && windDegree <= 56.25) {
        windDirection = @"NE";
    } else if (windDegree > 56.25 && windDegree <= 78.75) {
        windDirection = @"ENE";
    } else if (windDegree > 78.75 && windDegree <= 101.25) {
        windDirection = @"E";
    } else if (windDegree > 101.25 && windDegree <= 123.75) {
        windDirection = @"ESE";
    } else if (windDegree > 123.75 && windDegree <= 146.25) {
        windDirection = @"SE";
    } else if (windDegree > 146.25 && windDegree <= 168.75) {
        windDirection = @"SSE";
    } else if (windDegree > 168.75 && windDegree <= 191.25) {
        windDirection = @"S";
    } else if (windDegree > 191.25 && windDegree <= 213.75) {
        windDirection = @"SSW";
    } else if (windDegree > 213.75 && windDegree <= 236.25) {
        windDirection = @"SW";
    } else if (windDegree > 236.25 && windDegree <= 258.75) {
        windDirection = @"WSW";
    } else if (windDegree > 258.75 && windDegree <= 281.25) {
        windDirection = @"W";
    } else if (windDegree > 281.25 && windDegree <= 303.75) {
        windDirection = @"WNW";
    } else if (windDegree > 303.75 && windDegree <= 326.25) {
        windDirection = @"NW";
    } else if (windDegree > 326.25 && windDegree <= 348.75) {
        windDirection = @"NNW";
    } else if (windDegree > 348.75 && windDegree <= 11.25) {
        windDirection = @"N";
    }
    
    return windDirection;
}



-(void)transformLoadedData//:(NSDictionary *)loadedItem
{
    for (NSDictionary *item in self.loadedWeather) {
        [self.currentWeather addObject:[[Weather alloc] initWithLoadedData:item]];
    }
}
 
 */

#pragma mark - Alerts

-(void)showWarning:(NSString *)description withTitle:(NSString *)title
{
UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                               message:description
                                                        preferredStyle:UIAlertControllerStyleAlert];

UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {}];
[alert addAction:okAction];
[self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.loadedWeather.count;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CitiesListCell" forIndexPath:indexPath];
     Weather *weather = self.mappedCities[indexPath.row];
//     Weather *weather = self.loadedWeather[indexPath.row];

     
 // Configure the cell...
 
     UILabel *cityLabel = (UILabel *)[cell.contentView viewWithTag:1];
     UILabel *tempLabel = (UILabel *)[cell.contentView viewWithTag:2];
     
//     NSNumber *temp = weather.main[@"temp"];
     
     cityLabel.text = weather.name;
     tempLabel.text = weather.temperature;
//     tempLabel.text = [NSString stringWithFormat:@"%@", temp.stringValue];
     
 return cell;
 }

 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         
         Weather *key = self.mappedCities[indexPath.row];
         [self.mappedCities removeObjectAtIndex:indexPath.row];
         [self.citiesByDefault removeObject:key.name];
         [self.loadedWeather removeObjectForKey:key.name];
         [self updateUserDefaults];

         // Delete the row from the data source
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//     } else if (editingStyle == UITableViewCellEditingStyleInsert) {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
 }

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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
*/

#pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     // Make sure your segue name in storyboard is the same as this line
     if ([[segue identifier] isEqualToString:@"ShowDetailsSegue"])
     {
         // Get reference to the destination view controller
         CityDetailsViewController *cityDetailsVC = [segue destinationViewController];
         NSIndexPath *citiesListIndex = self.citiesList.indexPathForSelectedRow;
         // Pass any objects to the view controller here, like...
         cityDetailsVC.currentWeather = self.mappedCities[citiesListIndex.row];
     }
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }


@end
