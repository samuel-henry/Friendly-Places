//
//  ViewController.m
//  Friendly Places
//
//  Created by Sam on 3/2/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController
AppDelegate* appDelegate;
NSManagedObjectContext* context;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appDelegate = [AppDelegate sharedAppDelegate];
    context = appDelegate.managedObjectContext;
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
    
    
     //NSString * city;
     //NSString * country;
     //NSString * fb_about;
     //id fb_categories;
     //NSNumber * fb_checkins;
    //[newLocation setValue:[NSNumber numberWithInt:[[location objectForKey:@"fb_checkins"] intValue]] forKey:@"checkins"];
     //NSString * fb_description;
     //NSNumber * fb_fan_count;
    //[newLocation setValue:[NSNumber numberWithInt:[[location objectForKey:@"fb_fan_count"] intValue]] forKey:@"fan_count"];
     //NSNumber * fb_is_published;
     //NSNumber * fb_page_id;
     //NSString * fb_pic_square;
     //NSNumber * fb_were_here_count;
     //id hours;
     //NSNumber * id;
     //NSNumber * latitude;
     //NSNumber * longitude;
     //NSString * name;
     //NSString * phone;
     //NSString * state;
     //NSString * street;
     //NSString * website;
     //NSString * zip;
     //NSSet *checkers;
    
    
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
    /*
     NSNumber * fb_checkin_id;
     NSNumber * id;
     NSDate * timestamp;
     NSManagedObject *checkin_location;
     */
    
    //[newCheckin setValue:[NSNumber numberWithInt:[[checkin objectForKey:@"fb_checkin_id"] intValue]] forKey:@"checkin_id"];
    //[newCheckin setValue:[checkin objectForKey:@"timestamp"] forKey:@"timestamp"];
}

#pragma mark -- Facebook methods

- (IBAction)getDataClicked:(UIButton *)sender {
    [self loadFBData];
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
    @"'querylocationinfo':'SELECT page_id, location, is_published, fan_count, hours, phone, pic_square, website, were_here_count, about, categories, description FROM page WHERE page_id IN (select page_id from #queryfriendcheckins)',"
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
                                  //NSLog(@"Result: %@", result);
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
                                
                              }
                          }];
    
}
@end
