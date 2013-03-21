//
//  MapDetailViewController.m
//  Friendly Places
//
//  Created by Sam on 3/20/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//

#import "MapDetailViewController.h"
#import "Location.h"
#import "AppDelegate.h"

@interface MapDetailViewController ()
@end

@implementation MapDetailViewController
AppDelegate* appDelegate;
NSManagedObjectContext* context;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    appDelegate = [AppDelegate sharedAppDelegate];
    context = appDelegate.managedObjectContext;
    
    //get locations from DB
    [self displayLocation];
}

- (void) displayLocation
{
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"fb_page_id == %@", self.fb_page_id];
    [fetchRequest setPredicate:predicate];
    
    
    NSError *error;
    
    Location *currLocation = [context executeFetchRequest:fetchRequest error:&error];
    
    if (currLocation == nil) {
        NSLog(@"error fetching location in detail view");
    } else {
        NSLog(@"fetched location in detail view");
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
