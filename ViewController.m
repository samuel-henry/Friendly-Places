//
//  ViewController.m
//  Friendly Places
//
//  Created by Sam on 3/2/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Location.h"
#import "Checkin.h"
#import "FriendlyLocation.h"
#import <MapKit/MapKit.h>
#import "LocationTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController
AppDelegate* appDelegate;
NSManagedObjectContext* context;
NSArray* locations;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appDelegate = [AppDelegate sharedAppDelegate];
    context = appDelegate.managedObjectContext;
    
    [self fetchLocations];
    
    //LocationTableViewController *tvc = [[LocationTableViewController alloc] init];
    
    //self.tableView = tvc.tableView;
    
    //[self.tableView reloadData];
    self.tableView = [[UITableView alloc] init];
    
   
    
    //self.tableView.dataSource = [self.mapView annotationsInMapRect:self.mapView.visibleMapRect];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    // Configure the cell...
    Location *currLocation = [locations objectAtIndex:indexPath.row];
    cell.textLabel.text = currLocation.name;
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Core Data methods
//TODO: move to own class

//Methods for adding Friends
- (void)addFriends:(NSMutableArray *)friends {
    NSLog(@"adding friends");
    for (FBGraphObject *friend in friends) {
        [self addFriend:friend];
    }
}

- (void)addFriend:(FBGraphObject *)friend
{
    NSManagedObject *newFriend = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Friend"
                                    inManagedObjectContext:context];
    [newFriend setValue:[NSNumber numberWithInt:[[friend objectForKey:@"uid2"] intValue]] forKey:@"fb_id"];

}

//Methods for adding Locations
- (void)addLocations:(NSMutableArray *)locations {
    NSLog(@"adding locations");
    for (FBGraphObject *location in locations) {
        [self addLocation:location];
    }
}

- (void)addLocation:(FBGraphObject *)location
{
    NSManagedObject *newLocation = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Location"
                                    inManagedObjectContext:context];

    Location *newLocationInstance = (Location *)newLocation;
    
    //TODO: change model
    //NSNumber * city;
    //NSNumber * country;
    //NSNumber * id;
    //NSSet *checkers;
    //populate using predicate off friends and checkins
    
    //NSString * fb_about;
    newLocationInstance.fb_about = [location objectForKey:@"about"];
    //NSLog(newLocationInstance.fb_about);
    
    //id fb_categories;
    newLocationInstance.fb_categories = [location objectForKey:@"categories"];
    
    //NSNumber * fb_checkins;
    newLocationInstance.fb_checkins = [NSNumber numberWithInt:[[location objectForKey:@"checkins"] intValue]];
    
    //NSString * fb_description;
    newLocationInstance.fb_description = [location objectForKey:@"description"];
    //NSLog(newLocationInstance.fb_description);
    
    //NSNumber * fb_fan_count;
    newLocationInstance.fb_fan_count = [NSNumber numberWithInt:[[location objectForKey:@"fan_count"] intValue]];
    
    //NSNumber * fb_is_published;
    newLocationInstance.fb_is_published = [NSNumber numberWithInt:[[location objectForKey:@"is_published"] intValue]];
    
    //NSNumber * fb_page_id;
    newLocationInstance.fb_page_id = [NSNumber numberWithInt:[[location objectForKey:@"page_id"] intValue]];
    
    //NSString * fb_pic_square;
    newLocationInstance.fb_pic_square = [location objectForKey:@"pic_square"];
    //NSLog(newLocationInstance.fb_pic_square);
    
    //NSNumber * fb_were_here_count;
    newLocationInstance.fb_were_here_count = [NSNumber numberWithInt:[[location objectForKey:@"were_here_count"] intValue]];
    
    //id hours;
    newLocationInstance.hours = [location objectForKey:@"hours"];
    
    //NSNumber * latitude;
    newLocationInstance.latitude = [NSNumber numberWithFloat:[[[location objectForKey:@"location"] objectForKey:@"latitude"] floatValue]];
    
    //NSNumber * longitude;
    newLocationInstance.longitude = [NSNumber numberWithFloat:[[[location objectForKey:@"location"] objectForKey:@"longitude"] floatValue]];
    
    //NSString * name;
    newLocationInstance.name = [location objectForKey:@"name"];
    //NSLog(newLocationInstance.name);
    
    //NSString * phone;
    newLocationInstance.phone = [location objectForKey:@"phone"];
    
    //NSString * state;
    newLocationInstance.state = [[location objectForKey:@"location"] objectForKey:@"state"];
    
    //NSString * street;
    newLocationInstance.street = [[location objectForKey:@"location"] objectForKey:@"street"];
    
    //NSString * website;
    newLocationInstance.website = [location objectForKey:@"website"];
    
    //NSString * zip;
    newLocationInstance.zip = [[location objectForKey:@"location"] objectForKey:@"zip"];
    
    //[self addToMap newLocationInstance];
}

- (void)fetchLocations {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    
    NSError *error;
    
    locations = [context executeFetchRequest:fetchRequest error:&error];
    
    if (locations == nil) {
        NSLog(@"error fetching locations");
    } else {
        NSLog(@"fetched locations");
    }
    
    for (int i=0; i<locations.count; i++) {
        [self addToMap:locations[i]];
    }
}

- (void)addToMap:(Location *)someLocation {
    // Add some new pins
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = [someLocation.latitude doubleValue];
    coordinates.longitude = [someLocation.longitude doubleValue];
    NSLog(@"adding location to map");
    
    NSString *name = someLocation.name;

    //FriendlyLocation *annotation = [[FriendlyLocation alloc] initWithName:name coordinate:coordinates];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinates];
    [annotation setTitle:name];
    //TODO: add callout
    [self.mapView addAnnotation:annotation];
    
    
}

//Methods for adding Checkins
- (void)addCheckins:(NSMutableArray *)checkins {
    NSLog(@"adding checkins");
    for (FBGraphObject *checkin in checkins) {
        [self addCheckin:checkin];
    }
}

- (void)addCheckin:(FBGraphObject *)checkin
{
    NSManagedObject *newCheckin = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Checkin"
                                    inManagedObjectContext:context];
    Checkin *newCheckinInstance = (Checkin *)newCheckin;
    
    //TODO: change model
    //NSNumber * id;
    
    //NSNumber * fb_checkin_id;
    newCheckinInstance.fb_checkin_id = [NSNumber numberWithInt:[[checkin objectForKey:@"checkin_id"] intValue]];
    
    //NSDate * timestamp;
    newCheckinInstance.timestamp = [NSDate dateWithTimeIntervalSince1970:
                                    [[checkin objectForKey:@"timestamp"] doubleValue]];
    
    
    //NSManagedObject *checkin_location;
    //use predicate to fetch off [NSNumber numberWithInt:[[checkin objectForKey:@"page_id"] intValue]];
    
}

#pragma mark -- Facebook methods

- (IBAction)getDataClicked:(UIButton *)sender {
    //[self loadFBData];
}
- (IBAction)loginClicked:(UIButton *)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    [appDelegate openSessionWithAllowLoginUI:YES];
}

- (void)loadFBData
{
    //[self getFBFriends];
    //[self getFBFriendCheckins];
    //[self getFBLocationData];
    [self getFBMultiQUeryResults];
    
}

- (void)getFBMultiQUeryResults
{
    NSString *query =
    @"{"
    @"'queryfriends':'SELECT uid2 FROM friend WHERE uid1 = me()',"
    @"'queryfriendcheckins':'SELECT author_uid, checkin_id, page_id, timestamp from checkin WHERE author_uid IN (select uid2 from #queryfriends)',"
    @"'querylocationinfo':'SELECT name, page_id, location, is_published, fan_count, hours, phone, pic_square, website, were_here_count, about, categories, description FROM page WHERE page_id IN (select page_id from #queryfriendcheckins)',"
    @"}";
    
    // Set up the query parameter
    NSDictionary *queryParam = [NSDictionary dictionaryWithObjectsAndKeys:
                                query, @"q", nil];
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (error) {
                                  NSLog(@"Error: %@", [error localizedDescription]);
                              } else {
                                  NSLog(@"Result: %@", result);
                                  //get friends TODO:don't use index
                                  NSMutableArray *friends = [NSMutableArray arrayWithArray:[[[result objectForKey:@"data"] objectAtIndex:0] objectForKey:@"fql_result_set"]];
                                  
                                  //add new friends to context
                                  [self addFriends:friends];
                                  
                                  //get checkins TODO: don't use index
                                  NSMutableArray *checkins = [NSMutableArray arrayWithArray:[[[result objectForKey:@"data"] objectAtIndex:1] objectForKey:@"fql_result_set"]];
                                  
                                  //add new checkins to context
                                  [self addCheckins:checkins];
                                  
                                  //get locations TODO: don't use index
                                  NSMutableArray *locations = [NSMutableArray arrayWithArray:[[[result objectForKey:@"data"] objectAtIndex:2] objectForKey:@"fql_result_set"]];
                                  
                                  //add new locations to context
                                  [self addLocations:locations];
                                  
                                  if (![context save:&error]) {
                                      //handle error
                                  } else {
                                      NSLog(@"Saved context");
                                  }
                                
                              }
                          }];
    
}
@end
