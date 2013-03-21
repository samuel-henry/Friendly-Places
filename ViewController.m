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
#import "CustomLocationCell.h"
#import "MapDetailViewController.h"
#import "MKPinAnnotationViewLocation.h"
#import "MKPointAnnotationLocation.h"

@interface ViewController ()

@end

@implementation ViewController
AppDelegate* appDelegate;
NSManagedObjectContext* context;
NSMutableArray* visibleAnnotations;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appDelegate = [AppDelegate sharedAppDelegate];
    context = appDelegate.managedObjectContext;
    
    //get locations from DB
    [self fetchLocations];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.purpose = @"Friendly Places needs your location to suggest places nearby";
    self.locationManager.delegate = self;
    [self.locationManager setDistanceFilter:50]; // meters
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setHeadingFilter:kCLDistanceFilterNone];
    [self.locationManager startUpdatingLocation];
    
    self.mapView.delegate = self;
    
    //self.tableView = [[UITableView alloc] init];
    //self.tableView.delegate = self;
    
    //[self updateVisibleAnnotations];

}

# pragma mark - Map View methods
- (void)updateVisibleAnnotations
{
    //update the visible annotations on the map
    NSLog(@"updateVisibleAnnotations");
    visibleAnnotations = [[self.mapView annotationsInMapRect:self.mapView.visibleMapRect] allObjects];
    
    //get the center of the visible map
    const CLLocationCoordinate2D mapCenterCoordinate = self.mapView.centerCoordinate;
    const CLLocation *visibleCenter = [[CLLocation alloc] initWithLatitude:mapCenterCoordinate.latitude longitude:mapCenterCoordinate.longitude];
    
    //sort
    NSLog(@"sorting");
    visibleAnnotations = [visibleAnnotations sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        //cast objects to MKPointAnnotations
        MKPointAnnotation *location1 = (MKPointAnnotation *)obj1;
        MKPointAnnotation *location2 = (MKPointAnnotation *)obj2;
        
        //get CLLocation objects from the MKPointAnnotations' coordinates
        CLLocation *locFromAnnot1 = [[CLLocation alloc] initWithLatitude:location1.coordinate.latitude longitude:location2.coordinate.longitude];
        CLLocation *locFromAnnot2 = [[CLLocation alloc] initWithLatitude:location1.coordinate.latitude longitude:location2.coordinate.longitude];
        
        //compute each CLLocation's distance from the center of the screen
        double distance1 = [locFromAnnot1 distanceFromLocation:visibleCenter] ;
        double distance2 = [locFromAnnot2 distanceFromLocation:visibleCenter];
        
        //do the comparisons for ordering
        if (distance1 > distance2) {
            return (NSComparisonResult)NSOrderedDescending;
        } else if (distance1 < distance2) {
            return (NSComparisonResult)NSOrderedAscending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    //reload the table after sorting
    //[self.tableView reloadData];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"regiondidchangeanimated");
    //determine how best to balance updating table vs performance given region changes often
    //[self updateVisibleAnnotations];
}

//user location changed, so we need to update the map
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation");
    
    //get the region to display
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.1;
    mapRegion.span.longitudeDelta = 0.1;
    
    //display the region
    [self.mapView setRegion:mapRegion animated: NO];
    
    //update the visible annotaitons onscreen
    [self updateVisibleAnnotations];
    
}

//add locations to mapview
- (void)addToMap:(Location *)someLocation {
    // Add some new pins
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = [someLocation.latitude doubleValue];
    coordinates.longitude = [someLocation.longitude doubleValue];
    //NSLog(@"adding location to map");
    
    NSString *name = someLocation.name;
    NSString *website = someLocation.website;
    NSLog([someLocation.fb_page_id stringValue]);
    //NSString *fb_id = @"test";
    NSString *fb_id = [NSString stringWithFormat:@"%@", someLocation.fb_page_id];
    //FriendlyLocation *annotation = [[FriendlyLocation alloc] initWithName:name coordinate:coordinates];
    
    MKPointAnnotationLocation *annotation = [[MKPointAnnotationLocation alloc] init];
    [annotation setCoordinate:coordinates];
    [annotation setTitle:name];
    [annotation setSubtitle:website];
    /*annotation.website = someLocation.website;
    annotation.street = someLocation.street;
    annotation.description = someLocation.description;
    annotation.phone = someLocation.phone;*/
    
    [self.mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    //NSLog(@"entering theMapView");
    //MKPointAnnotationLocation *test = (MKPointAnnotationLocation *)annotation;

    static NSString *identifier = @"MyLocation";
    
    //if ([annotation isKindOfClass:[MyLocation class]]) {
        
    CLLocation *location = (CLLocation *) annotation;
    MKPinAnnotationViewLocation *annotationView = (MKPinAnnotationViewLocation *) [theMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:location reuseIdentifier:identifier];
    } else {
        annotationView.annotation = location;
    }
        
    // Set the pin properties
    annotationView.animatesDrop = NO;
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.pinColor = MKPinAnnotationColorGreen;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //annotationView.website = test.website;
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"tapped callout");
    MapDetailViewController *mdvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"MapDetailViewController"];
    MKPointAnnotationLocation *locationAnnotation = (MKPointAnnotationLocation *)view.annotation;
    mdvc.website = locationAnnotation.subtitle;
    //mdvc.latitude = [[NSNumber alloc] initWithDouble:locationAnnotation.coordinate.latitude];
    //mdvc.longitude = [[NSNumber alloc] initWithDouble:locationAnnotation.coordinate.longitude];
    mdvc.name = locationAnnotation.title;
    //mdvc.description = locationAnnotation.description;
    //mdvc.phone = locationAnnotation.phone;
    //mdvc.street = locationAnnotation.street;
    //mdvc.website = locationAnnotation.website;
    
    [self.navigationController pushViewController:mdvc animated:YES];
}

#pragma mark - Table View implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//TODO: buggy implementation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
    //return [locations count];
}

- (CustomLocationCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomLocationCell";
    CustomLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //TODO: why am I needing to do this? related to numberOfRowsInSection bug?
    if (cell == nil) {
        cell = [[CustomLocationCell alloc] init];
    }
    
    //configure the cell
    FriendlyLocation *currLocation = [visibleAnnotations objectAtIndex:indexPath.row];
    cell.textLabel.text = [currLocation title];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Core Location Manager methods
#pragma mark - Location Delegate
/*******************************************************************************
 * @method locationManager:didUpdateToLocation:fromLocation
 * @abstract <# Abstract #>
 * @description <# Description #>
 ******************************************************************************/
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:
(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation");
    
    //re-center the map
    CLLocation *userLoc = self.mapView.userLocation.location;
    [self.mapView setCenterCoordinate:userLoc.coordinate animated:YES];
    
    //get the updated visible points on the map
    //[self updateVisibleAnnotations];
    //[self.tableView reloadData];
    
}
/*******************************************************************************
 * @method locationManager:didFailWithError
 * @abstract <# Abstract #>
 * @description <# Description #>
 ******************************************************************************/
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError
                                                                       *)error
{
    NSLog(@"Could not find location: %@", error);
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

//fetch Core Data Locations
- (void)fetchLocations {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    
    NSError *error;
    
    NSArray *locations = [context executeFetchRequest:fetchRequest error:&error];
    
    if (locations == nil) {
        NSLog(@"error fetching locations");
    } else {
        NSLog(@"fetched locations");
    }
    
    for (int i=0; i<locations.count; i++) {
        [self addToMap:locations[i]];
    }
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
