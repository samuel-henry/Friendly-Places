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
bool initializedByPlaceHomepage = NO;
NSString const *googPrefix = @"http://www.google.com/search?q=";
NSString const *httpPrefix = @"http://";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //update the view's title with the name of the location
    self.title = self.name;
    self.detailViewWebView.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadWebView];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    ALog(@"started");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    ALog(@"loaded");
    initializedByPlaceHomepage = NO;
}

- (void)loadWebView {
    if ([self.website length] > 0) {
        initializedByPlaceHomepage = YES;
        [self loadPlaceWebsite];
    } else {
        [self loadGoogleSearch];
    }
}

- (void)loadGoogleSearch {
    NSString *searchQuery = [googPrefix stringByAppendingString:[self.name stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    ALog(searchQuery);
    //create a url for the passed in website link
    NSURL *passedURL = [NSURL URLWithString:searchQuery];
    
    //create a request to load this website
    NSURLRequest *request = [NSURLRequest requestWithURL:passedURL];
    
    //load webview
    [self.detailViewWebView loadRequest:request];
    [self.detailViewWebView autoresizesSubviews];

}

- (void)loadPlaceWebsite {
    NSMutableString *locationURL = self.website;
    
    //if we have a website but it doesn't begin with http://, we should prepend that
    if ([locationURL hasPrefix:httpPrefix] == false) {
        locationURL = [httpPrefix stringByAppendingString:locationURL];
        ALog(@"prepended http://");
    }
    
    //create a url for the passed in website link
    NSURL *passedURL = [NSURL URLWithString:locationURL];
    
    //create a request to load this website
    NSURLRequest *request = [NSURLRequest requestWithURL:passedURL];
    
    //load webview
    [self.detailViewWebView loadRequest:request];
    [self.detailViewWebView autoresizesSubviews];
}

/*******************************************************************************
 * @method          didFailLoadWithError
 * @description     UIWebView delegate method called when we fail to load a URL.
 *                  We will attempt to load a google search for this place if
 *                  the failure came from trying to load the place's actual 
 *                  webpage from Facebook's data
 ******************************************************************************/
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    ALog(@"failed");
    ALog(error.description);
    ALog(error.debugDescription);
    if (initializedByPlaceHomepage) {
        [self loadGoogleSearch];
    }
    
}

/*******************************************************************************
 * @method          backButtonTapped
 * @description     Called when the back button for the webview is tapped.
 *                  Goes back one page in the history
 ******************************************************************************/
- (IBAction)backButtonClicked:(id)sender {
    ALog(@"Back button tapped");
    [self.detailViewWebView goBack];
}

/*******************************************************************************
 * @method          forwardButtonTapped
 * @description     Called when the forward button for the webview is tapped.
 *                  Goes forward one page in the history
 ******************************************************************************/
- (IBAction)forwardButtonClicked:(id)sender {
    ALog(@"Forward button tapped");
    [self.detailViewWebView goForward];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
