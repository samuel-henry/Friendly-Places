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
    self.title = self.name;

}

- (IBAction)backButtonTapped:(id)sender {
    [self.detailViewWebView goBack];
}

- (IBAction)forwardButtonTapped:(id)sender {
    [self.detailViewWebView goForward];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSURL *passedURL = [NSURL URLWithString:self.website];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:passedURL];
    
    //load webview
    [self.detailViewWebView loadRequest:request];
    [self.detailViewWebView autoresizesSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
