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
    
    NSURL *passedURL = [NSURL URLWithString:self.website];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:passedURL];
    
    //load webview
    [self.detailViewWebView loadRequest:request];
    [self.detailViewWebView autoresizesSubviews];

}

- (IBAction)backButtonTapped:(id)sender {
    [self.detailViewWebView goBack];
}

- (IBAction)forwardButtonTapped:(id)sender {
    [self.detailViewWebView goForward];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.nameLabel.text = self.name;
    
    NSLog(@"adding street");
    self.addressLabel.text = self.street;
    
    NSLog(@"adding website");
    self.websiteLabel.text = self.website;
    
    NSLog(@"adding phone number");
    self.phoneLabel.text = self.phone;
    NSLog(@"adding description");
    self.descriptionLabel.text = self.description;
    
    
    //NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat: @"name == %@", self.name];
    //[fetchRequest setPredicate:predicate];
    
    
    //NSError *error;
    
    //NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    //Location *currLocation = results[0];
    
    /*
    if (currLocation == nil) {
        NSLog(@"error fetching location in detail view");
    } else {
        NSLog(@"fetched location in detail view");
        NSLog(@"adding name");
        self.nameLabel.text = currLocation.name;
     
        NSLog(@"adding street");
        self.addressLabel.text = currLocation.street;
        
        NSLog(@"adding website");
        self.websiteLabel.text = currLocation.website;
        
        NSLog(@"adding phone number");
        self.phoneLabel.text = currLocation.phone;
        NSLog(@"adding description");
        //self.descriptionLabel.text = currLocation.description;
    }*/

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
