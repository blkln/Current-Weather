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
}

- (IBAction)updateWeather:(UIBarButtonItem *)sender {
    [self updateWeather];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUserDefaults];
    [self configureRestKit];
    [self updateWeather];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - User defaults

-(void) loadUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *encodedLoadedWeather = [userDefaults objectForKey:@"loadedWeather"];
    self.loadedWeather = [NSKeyedUnarchiver unarchiveObjectWithData:encodedLoadedWeather];
    
    NSData *encodedCitiesByDefault = [userDefaults objectForKey:@"citiesByDefault"];
    self.citiesByDefault = [NSKeyedUnarchiver unarchiveObjectWithData:encodedCitiesByDefault];
    
    for (int i = 0; i < self.citiesByDefault.count; i++) {
        NSString *cityName = self.citiesByDefault[i];
        self.citiesByDefault[i] = [cityName capitalizedString];
    }
    
    NSData *encodedMappedCities = [userDefaults objectForKey:@"mappedCities"];
    self.mappedCities = [NSKeyedUnarchiver unarchiveObjectWithData:encodedMappedCities];
    
    if (!self.loadedWeather.count && !self.citiesByDefault.count && !self.mappedCities.count) {
        self.citiesByDefault = [[NSMutableArray alloc] initWithArray:@[@"Kyiv", @"Rivne", @"Lviv"]];
    }
    
}

-(void) updateUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSData *encodedLoadedWeather = [NSKeyedArchiver archivedDataWithRootObject:self.loadedWeather];
    [userDefaults setObject:encodedLoadedWeather forKey:@"loadedWeather"];
    
    NSData *encodedCitiesByDefault = [NSKeyedArchiver archivedDataWithRootObject:self.citiesByDefault];
    [userDefaults setObject:encodedCitiesByDefault forKey:@"citiesByDefault"];
    
    NSData *encodedMappedCities = [NSKeyedArchiver archivedDataWithRootObject:self.mappedCities];
    [userDefaults setObject:encodedMappedCities forKey:@"mappedCities"];
    
    [userDefaults synchronize];
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
                                                  for (Weather *result in resultArray) {
                                                      [result printProperties];
                                                      [self.loadedWeather setObject:result forKey:result.name];
                                                  }
                                                  [self.citiesList reloadData];
                                                  [self updateUserDefaults];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Request fail: %@", error);
                                                  [self showWarning:@"Request failed" withTitle:@"Error"];
                                              }];
}

-(void)updateWeather
{
    for (NSString *cityName in self.citiesByDefault) {
        [self loadWeather:cityName];
    }
}

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
 
     UILabel *cityLabel = (UILabel *)[cell.contentView viewWithTag:1];
     UILabel *tempLabel = (UILabel *)[cell.contentView viewWithTag:2];
     
     cityLabel.text = weather.name;
     tempLabel.text = weather.temperature;
     
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
     }
 }

#pragma mark - Navigation
 
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
 }


@end
