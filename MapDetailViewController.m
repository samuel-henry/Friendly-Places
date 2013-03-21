//
//  MapDetailViewController.m
//  Friendly Places
//
//  Created by Sam on 3/20/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//
//  Description:    Detail view for callouts. Contains name and website
//                  properties for rendering view
//

#import "MapDetailViewController.h"
#import "Location.h"
#import "AppDelegate.h"

@interface MapDetailViewController ()
@end

@implementation MapDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //update the view's title with the name of the location
    self.title = self.name;

}

- (void)viewWillAppear:(BOOL)animated
{
    //create a url for the passed in website link
    NSURL *passedURL = [NSURL URLWithString:self.website];
    
    //create a request to load this website
    NSURLRequest *request = [NSURLRequest requestWithURL:passedURL];
    
    //load webview
    [self.detailViewWebView loadRequest:request];
    [self.detailViewWebView autoresizesSubviews];
}

/*******************************************************************************
 * @method          backButtonTapped
 * @description     Called when the back button for the webview is tapped.
 *                  Goes back one page in the history
 ******************************************************************************/
- (IBAction)backButtonTapped:(id)sender {
    [self.detailViewWebView goBack];
}

/*******************************************************************************
 * @method          forwardButtonTapped
 * @description     Called when the forward button for the webview is tapped.
 *                  Goes forward one page in the history
 ******************************************************************************/
- (IBAction)forwardButtonTapped:(id)sender {
    [self.detailViewWebView goForward];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
