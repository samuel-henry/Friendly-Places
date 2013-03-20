//
//  MapDetailViewController.m
//  Friendly Places
//
//  Created by Sam on 3/20/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//

#import "MapDetailViewController.h"
#import "Location.h"

@interface MapDetailViewController ()
@end

@implementation MapDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(self.detailLocation.name);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
