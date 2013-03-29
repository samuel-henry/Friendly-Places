//
//  MapDetailViewController.h
//  Friendly Places
//
//  Created by Sam on 3/20/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//
//  Description:    Detail view for callouts. Contains name and website
//                  properties for rendering view
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface MapDetailViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSString *website;
@property (weak, nonatomic) IBOutlet UIWebView *detailViewWebView;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)forwardButtonClicked:(id)sender;

@end
