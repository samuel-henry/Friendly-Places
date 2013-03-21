//
//  ViewController.m
//  Friendly Places
//
//  Created by Sam on 3/2/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//
//  Description:    Main view controller. Handles FB authorization, FB data retrieval,
//                  and map view population.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Location.h"
#import "MKPointAnnotationLocation.h"
#import "MapDetailViewController.h"
#import "SplashScreenViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()

@end

@implementation ViewController
AppDelegate* appDelegate;
NSManagedObjectContext* context;
NSMutableArray* visibleAnnotations;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //get locations from DB
    [self fetchLocations];
    
    //reference to the Peek View
    SplashScreenViewController *ssvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"SplashScreenViewController"];
    [self presentViewController:ssvc animated:NO completion:^{
        NSLog(@"SplashScreenViewController did appear");
        
        [self performSelector:@selector(dismissSplashScreenController) withObject:nil afterDelay:5];
    }];
    
    self.locationManager = [[CLLocationManager alloc] init];
    //self.locationManager.purpose = @"Friendly Places needs your location to suggest places nearby"; //purpose --> deprecated
    self.locationManager.delegate = self;
    [self.locationManager setDistanceFilter:50]; // meters
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setHeadingFilter:kCLDistanceFilterNone];
    [self.locationManager startUpdatingLocation];
    
    self.mapView.delegate = self;

}

- (void)dismissSplashScreenController
{
    [self dismissViewControllerAnimated:YES completion:^{
        ALog(@"SplashScreenViewController is dismissed");
    }];
}

# pragma mark - Map View methods

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    ALog(@"didUpdateUserLocation");

    //get the region to display
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.1;
    mapRegion.span.longitudeDelta = 0.1;
    
    //display the region
    [self.mapView setRegion:mapRegion animated: NO];
    
}

/*******************************************************************************
 * @method          addToMap
 * @description     Add a Core Data Location object to the map by creating 
 *                  an annotation.
 ******************************************************************************/
- (void)addToMap:(Location *)someLocation {
    
    //get coordinates from lat/long
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = [someLocation.latitude doubleValue];
    coordinates.longitude = [someLocation.longitude doubleValue];
    
    //create annotation
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinates];
    [annotation setTitle:someLocation.name];
    [annotation setSubtitle:someLocation.website];
    
    //add to mapview
    [self.mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MyLocation";
        
    CLLocation *location = (CLLocation *) annotation;
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [theMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
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
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"tapped callout");
    MapDetailViewController *mdvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"MapDetailViewController"];
    MKPointAnnotationLocation *locationAnnotation = (MKPointAnnotationLocation *)view.annotation;
    mdvc.website = locationAnnotation.subtitle;
    mdvc.name = locationAnnotation.title;
    DLog(@"Transitioning to map detail view");
    DLog(mdvc.name);
    DLog(mdvc.website);
    
    [self.navigationController pushViewController:mdvc animated:YES];
}

#pragma mark -- Core Location Manager methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:
(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //re-center the map
    CLLocation *userLoc = self.mapView.userLocation.location;
    [self.mapView setCenterCoordinate:userLoc.coordinate animated:YES];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError
                                                                       *)error
{
    ALog(@"Could not find location: %@", error);
}

#pragma mark -- Core Data methods

/*******************************************************************************
 * @method          addLocations
 * @description     Loops through FBGraphObjects representing locations and calls
 *                  method to generate Core Data Location object
 ******************************************************************************/
- (void)addLocations:(NSMutableArray *)locations {
    ALog(@"Creating Core Data Locations from FBGraphObjects");
    for (FBGraphObject *location in locations) {
        [self createCoreDataLocation:location];
    }
}

/*******************************************************************************
 * @method          createCoreDataLocation
 * @description     Creates an individual Core Data Loction object from a
 *                  FBGraphObject
 ******************************************************************************/
- (void)createCoreDataLocation:(FBGraphObject *)location
{
    NSManagedObject *newLocation = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Location"
                                    inManagedObjectContext:context];

    Location *newLocationInstance = (Location *)newLocation;
    
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
    
}

/*******************************************************************************
 * @method          fetchLocations
 * @description     Fetch all Core Data Location objects from data store
 ******************************************************************************/
- (void)fetchLocations {
    //get appdelegate and context for core data fetch
    appDelegate = [AppDelegate sharedAppDelegate];
    context = appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    
    NSError *error;
    
    NSArray *locations = [context executeFetchRequest:fetchRequest error:&error];
    
    if (locations == nil) {
        [self getFBMultiQUeryResults];
    } else {
        ALog(@"fetched locations");
        for (int i=0; i<locations.count; i++) {
            [self addToMap:locations[i]];
        }
    }
    
    
}

#pragma mark -- Facebook methods

/*******************************************************************************
 * @method          loginNavButtonTapped
 * @description     Initiates user authorizing/signing in app with Facebook
 ******************************************************************************/
- (IBAction)loginNavButtonTapped:(UIButton *)sender {
    ALog(@"Login clicked");
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    [appDelegate openSessionWithAllowLoginUI:YES];
}

/*******************************************************************************
 * @method          getCheckinsNavButtonTapped
 * @description     Initiates retrieval of user's Facebook friends, their 
 *                  checkins, and the corresponding Facebook page locations
 ******************************************************************************/
- (IBAction)getCheckinsNavButtonTapped:(UIButton *)sender {
    ALog(@"Get Data clicked");
    [self getFBMultiQUeryResults];
}

/*******************************************************************************
 * @method          getFBMultiQUeryResults
 * @description     Executes FQL multiquery against Facebook Graph to retrieve
 *                  user's Facebook friends, their checkins, and the 
 *                  corresponding Facebook page locations
 ******************************************************************************/
- (void)getFBMultiQUeryResults
{
    //three-part FQL multi-query:
    //  1. Get user's friends
    //  2. Use results of 1 to get user's friends' checkins
    //  3. Use results of 2 to get checkin locations
    //
    //  Execute as multiquery rather than three individual queries for best performance
    
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
                                  ALog(@"Error: %@", [error localizedDescription]);
                              } else {
                                  DLog(@"Result: %@", result);
                                  
                                  //get locations (HACK: don't hardcode index)
                                  NSMutableArray *locations = [NSMutableArray arrayWithArray:[[[result objectForKey:@"data"] objectAtIndex:2] objectForKey:@"fql_result_set"]];
                                  
                                  //add locations to context
                                  [self addLocations:locations];
                                  
                                  if (![context save:&error]) {
                                      //handle error
                                  } else {
                                      ALog(@"Saved context");
                                      [self fetchLocations];
                                  }
                                
                              }
                          }];
    
}


@end
